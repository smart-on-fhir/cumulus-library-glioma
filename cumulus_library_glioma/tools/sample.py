from pathlib import Path
import pandas as pd
from cumulus_library_glioma.tools import filetool
from cumulus_library_glioma.llm.pydantic_schema.document_type import DocumentType, DocumentTask

def make_valueset() -> Path:
    """
    Make CSV of curated document types
    """
    df = pd.DataFrame(
        [{"system": 'https://github.com/smart-on-fhir/cumulus-library-glioma',
          "code": doctype.name,
          "display": doctype.value} for doctype in DocumentType]
    )
    target_csv = filetool.path_resources('llm_note_type.csv')
    df.to_csv(target_csv, index=False)
    return target_csv

def make_tasks() -> Path:
    """
    Make CSV mapping of document tasks to document typas
    """
    output = list()
    for task in DocumentTask:
        for doctype in task.value:
            output.append({"task":task.name, "code":doctype.name})

    df = pd.DataFrame(output)
    target_csv = filetool.path_resources('llm_note_task.csv')
    df.to_csv(target_csv, index=False)
    return target_csv

def make_views() -> list[Path]:
    """
    Make SQL views of glioma__llm_note_task for each task
    """
    view_list = list()
    source = 'glioma__sample_casedef_task'

    for task in list(DocumentTask):
        target = f"{source}_{task.name.lower()}"
        sql = f"create table {target} as select * from {source} where task = '{task.name}'"
        view_list.append(filetool.save_athena_view(target, sql))
    return view_list
#-----------------------------------------------------------------------------
# Make
#-----------------------------------------------------------------------------
def make() -> list[Path]:
    return [make_valueset(), make_tasks()] +  make_views()

if __name__ == '__main__':
    target_files = make()
