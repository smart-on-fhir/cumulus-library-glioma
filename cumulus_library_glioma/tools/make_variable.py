from typing import List
from pathlib import Path
from cumulus_library_glioma.tools import filetool, tablespace
from tools.tablespace import name_trim

VERBOSE = True

###############################################################################
# List variables
###############################################################################
def list_valueset_vsac() -> List[Path]:
    return filetool.list_valuesets('*valueset*')

def list_valueset_uploads() -> List[Path]:
    return filetool.list_resources('*valueset*')

def list_variable_names() -> List[str]:
    var_list = list_valueset_vsac() + list_valueset_uploads()
    var_list = [v.name for v in var_list]
    var_list = [v for v in var_list if "casedef" not in v]
    if VERBOSE:
        print('files:', '\t', var_list)
    var_list = [tablespace.name_trim(v) for v in var_list]
    var_list = [v.split('.')[0] for v in var_list]
    if VERBOSE:
        print('variables:', '\t', var_list)
    return var_list

def select_union(variable_list: List[str]) -> str:
    sql = list()
    for variable in variable_list:
        variable = name_trim(variable)
        select = f"\tselect distinct '{variable}'\t as variable, code, display, system, encounter_ref "
        from_table = f" from {tablespace.PREFIX}__cohort_{variable}"
        sql.append(select + from_table)
    return ' UNION ALL\n'.join(sql)

def select_lookup(variable_list: List[str]) -> str:
    sql = list()
    for variable in variable_list:
        variable = name_trim(variable)
        sql.append(f"\tIF(lookup.variable='{variable}', lookup.valueset) AS {variable}")
    return ',\n'.join(sql)

def select_lookup_wide(variable_list: List[str]) -> str:
    sql = list()
    for variable in variable_list:
        variable = name_trim(variable)
        sql.append(f"\tarbitrary({variable})    FILTER (where {variable}  is NOT null) as {variable}")
    return ',\n'.join(sql)

###############################################################################
# Cohort variable JOIN study population
###############################################################################
def make_cohort(variable: str) -> Path:
    ref = tablespace.get_reference(variable)

    population = tablespace.name_study_population(ref.name)
    valueset_name = tablespace.name_valueset(variable)
    cohort_name = tablespace.name_cohort(variable)
    if VERBOSE:
        print('cohort: ', cohort_name, '\t',
              'population: ', population, '\t',
              'valueset_name: ', valueset_name)

    where = [f'{population}.{ref.code()} = {valueset_name}.code',
             f'{population}.{ref.system()} = {valueset_name}.system']
    sql = tablespace.ctas(population, variable, where)
    return filetool.save_athena_view(cohort_name, sql)

def make_union() -> Path:
    """
    All study variable cohorts in one table.
    "see `template/cohort_study_variables.sql`"
    :return: Path to SQL file for each study variable 1+ `valueset`
    """
    _cohort = tablespace.name_cohort('variable_union')
    _template = filetool.path_athena('.') / 'template' / f"{_cohort}.sql"
    _target = filetool.path_athena(f"{_cohort}.sql")
    _sql = filetool.read_text(_template)
    _sql = _sql.replace('$prefix__', f"{tablespace.PREFIX}__")
    _sql =  _sql.replace('$variable_list', select_union(list_variable_names()))
    return filetool.save_athena(_target, _sql)

def make_wide() -> Path:
    """
    All study variable cohorts in one table in WIDE format.
    each column is a study variable.

    see `template/cohort_study_variables_wide.sql`
    :return: Path to SQL file `athena/irae__cohort_study_variables_wide.sql`
    """
    variable_list = list_variable_names()

    _cohort = tablespace.name_cohort('variable_wide')
    _template = filetool.path_athena('.') / 'template' / f"{_cohort}.sql"
    _target = filetool.path_athena(f"{_cohort}.sql")
    _lookup = select_lookup(variable_list)
    _wide = select_lookup_wide(variable_list)
    _sql = filetool.read_text(_template)
    _sql = _sql.replace('$variable_list_lookup', _lookup)
    _sql = _sql.replace('$variable_list_wide', _wide)
    return filetool.save_athena(_target, _sql)





###############################################################################
# Make
###############################################################################
def make() -> list[Path]:
    return [make_cohort(variable) for variable in list_variable_names()]

def as_toml() -> str:
    table_list = [tablespace.name_cohort(t) for t in list_variable_names()]
    key = '"variable cohort"'
    values = [f'"athena/{table_name}.sql",' for table_name in table_list]
    return  key + '= [\n\t'+ '\n\t'.join(values) + '\n]'

if __name__ == '__main__':
    target_files = make() + [make_union()]

    if VERBOSE:
        print('#######################################################################')
        print(target_files)
        print('#######################################################################')
        print(as_toml())
