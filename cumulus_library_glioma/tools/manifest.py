from pathlib import Path
from cumulus_library import StudyManifest
from cumulus_library_glioma.tools import filetool

#-----------------------------------------------------------------------------
# get study manifest using cumulus library
#-----------------------------------------------------------------------------
def get_manifest(manifest_path: Path|str = None) -> StudyManifest:
    if not manifest_path:
        manifest_path = filetool.path_project()
    if isinstance(manifest_path, str):
        manifest_path = filetool.path_project(manifest_path)
    return StudyManifest(manifest_path)

def list_rx_valuesets():
    workflows = get_manifest().get_all_workflows()
    rx_list = [item.replace('.toml', '') for item in workflows if item.startswith('rx_')]
    table_list = [f'glioma__{rx}_valuesets' for rx in rx_list]
    select_list = [f'select * from {table}' for table in table_list]
    union_list = '\tUNION ALL\n'.join(select_list)
    ctas = 'create TABLE glioma__valueset_casedef_rx_union AS '
    return ctas + union_list

#-----------------------------------------------------------------------------
# TOML helpers
#-----------------------------------------------------------------------------
def _quote(text:str, quote_char:str='"') -> str:
    return quote_char + text + quote_char

def as_toml_parallel(file_list:list[Path], toml_key:str, subdir='athena') -> str:
    """
    Workaround for https://github.com/smart-on-fhir/cumulus-library/issues/439
    :param toml_key: key name to display during build
    :param file_list: list of paths to files to execute in parallel
    :param subdir: folder containing items in file_list
    :return: str content for `manifest.toml`
    """
    file_list = [t.name for t in file_list]
    values = [f'"{subdir}/{file_name}",' for file_name in file_list]
    return  _quote(toml_key) + '= [\n\t'+ '\n\t'.join(values) + '\n]'

def as_toml_valuesets(file_list:list[Path]) -> str:
    """
    Workaround for https://github.com/smart-on-fhir/cumulus-library/issues/439
    :return: str content for `manifest.toml`
    """
    out = list()
    for filename in file_list:
        out.append(f'[tables.valueset_{filetool.file_to_variable(filename.name)}]')
        out.append(f'file = "valueset_data/{filename.name}"')
        out.append('')
    return '\n'.join(out)
