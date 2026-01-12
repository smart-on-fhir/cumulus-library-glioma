from pathlib import Path
import pandas as pd
from cumulus_library_glioma.tools import filetool, manifest
from cumulus_library_glioma.llm.pydantic_schema.document_types import DocumentType, DocumentTask

def make_valueset() -> Path:
    df = pd.DataFrame(
        [{"system": 'https://github.com/smart-on-fhir/cumulus-library-glioma',
          "code": doctype.name,
          "value": doctype.value} for doctype in DocumentType]
    )
    target_csv = filetool.path_resources('llm_document_type.csv')
    df.to_csv(target_csv, index=False)
    return target_csv

def make_tasks() -> Path:
    output = list()
    for task in DocumentTask:
        for doctype in task.value:
            output.append({"task":task.name, "code":doctype.name})

    df = pd.DataFrame(output)
    target_csv = filetool.path_resources('llm_document_type_task.csv')
    df.to_csv(target_csv, index=False)
    return target_csv

#-----------------------------------------------------------------------------
# Make
#-----------------------------------------------------------------------------
def make() -> list[Path]:
    return [make_valueset(), make_tasks()]

if __name__ == '__main__':
    target_files = make()
    print(manifest.as_toml(target_files, 'sample'))
