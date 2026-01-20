import os
import json
from pathlib import Path
from typing import Dict, Any
from cumulus_library_glioma.tools.tablespace import PREFIX, name_trim

#-----------------------------------------------------------------------------
# PROJECT HOME
#-----------------------------------------------------------------------------
def path_project(filename=None) -> Path:
    project_dir = Path(__file__).resolve().parent.parent
    if filename:
        return project_dir/ filename
    return project_dir

#-----------------------------------------------------------------------------
# resources dir (user curated files)
#-----------------------------------------------------------------------------
def path_resources(filename: Path | str) -> Path:
    """
    :param filename: name of JSON file
    :return: Path to JSON valueset
    """
    return Path(os.path.join(path_project(), '..', 'resources', filename))

#-----------------------------------------------------------------------------
# VSAC Valueset(s)
#-----------------------------------------------------------------------------
def path_valueset(filename: Path | str) -> Path:
    """
    :param filename: name of JSON file
    :return: Path to JSON valueset
    """
    return path_project() / 'valueset_data' / filename

def load_valueset(filename: Path | str) -> dict:
    """
    :param filename: name of JSON file
    :return: dict of valueset contents
    """
    return read_json(path_valueset(filename))

def save_valueset(filename: Path | str, contents: dict) -> Path:
    """
    Save JSON to valueset folder.
    :param filename: name of JSON file (destination)
    :param contents: dict JSON
    :return: Path to JSON filename
    """
    return Path(write_json(contents, path_valueset(filename)))

def list_valuesets(pattern:str = '*.*') -> list[Path]:
    return sorted(list(path_valueset('.').glob(pattern)))

def list_resources(pattern:str = '*.*') -> list[Path]:
    return sorted(list(path_resources('.').glob(pattern)))

#-----------------------------------------------------------------------------
# Athena SQL File(s)
#-----------------------------------------------------------------------------
def path_athena(file_sql: Path | str) -> Path:
    return path_project() / 'athena' / file_sql

def save_athena(file_sql: Path | str, contents: str) -> Path:
    return Path(write_text(contents, path_athena(file_sql)))

def save_athena_view(view_name: str, contents: str) -> Path:
    return Path(write_text(contents, path_athena(f'{view_name}.sql')))

def path_template(file_sql: Path | str) -> Path:
    return path_project() / 'athena' / 'template' / file_sql

def load_template(file_sql: Path | str, replacements:dict = None) -> str:
    text= replace_text(read_text(path_template(file_sql)))
    return replace_text(text, replacements)

def copy_template(file_sql: Path | str, replacements:dict = None) -> Path:
    file_name = file_sql.name if isinstance(file_sql, Path) else file_sql
    text = load_template(path_template(file_name))
    text = replace_text(text, replacements)
    target = path_athena(f"{PREFIX}__{file_name}")
    return save_athena(target, text)

def replace_text(original:str, replacements:dict = None) -> str:
    if not replacements:
        replacements = dict()
    if '$prefix' not in replacements:
        replacements['$prefix']=PREFIX
    output = original
    for key, value in replacements.items():
        output = output.replace(key, value)
    return output

#-----------------------------------------------------------------------------
# Read/Write Text
#-----------------------------------------------------------------------------
def read_text(text_file: Path | str, encoding: str = 'UTF-8') -> str:
    """
    Read text from file
    :param text_file: absolute path to file
    :param encoding: provided file's encoding
    :return: file text contents
    """
    with m_open(file=text_file, encoding=encoding) as t_file:
        return t_file.read()

def write_text(contents: str, file_path: Path | str, encoding: str = 'UTF-8') -> str:
    """
    Write file contents
    :param contents: string contents
    :param file_path: absolute path of target file
    :param encoding: provided file's encoding
    :return: text_file name
    """
    with m_open(file=file_path, mode='w', encoding=encoding) as file_path:
        file_path.write(contents)
        file_path.close()
        return file_path.name

def m_open(**kwargs):
    """
    Wrapper for built in open with exception handling and logging
    :return: file like object
    """
    try:
        return open(**kwargs)
    except Exception:
        print('m_open raised an exception', exc_info=True)
        raise

#-----------------------------------------------------------------------------
# Read/Write JSON
#-----------------------------------------------------------------------------
def read_json(json_file: Path | str, encoding: str = 'UTF-8') -> Dict[Any, Any]:
    """
    Read json from file
    :param json_file: absolute path to file
    :param encoding: provided file's encoding
    :return: json file contents
    """
    with m_open(file=json_file, encoding=encoding) as j_file:
        return json.load(j_file)

def write_json(contents: Dict[Any, Any], json_file_path: Path | str, encoding: str = 'UTF-8') -> Path:
    """
    Write JSON to file
    :param contents: json (dict) contents
    :param json_file_path: absolute destination file path
    :param encoding: provided file's encoding
    :return: file name
    """
    directory = os.path.dirname(json_file_path)
    os.makedirs(directory, exist_ok=True)
    with m_open(file=json_file_path, mode='w', encoding=encoding) as json_file_path:
        # json.dump(contents, json_file_path, indent=4, cls=jsonifiers.CustomJsonEncoder)
        json.dump(contents, json_file_path, indent=4)
        return Path(json_file_path.name)

#-----------------------------------------------------------------------------
# filename to variable (tablespace) name
#-----------------------------------------------------------------------------
def file_to_variable(filename:Path|str) -> str:
    """
    Get variable name for file
    :return: return simplified variable name for a filepath
    """
    name_part = filename.name if isinstance(filename, Path) else filename
    return name_trim(name_part).split('.')[0]
