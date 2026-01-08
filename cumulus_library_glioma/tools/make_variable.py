from typing import List
from pathlib import Path
from cumulus_library_glioma.tools import filetool, tablespace
from tools.tablespace import name_trim

#-----------------------------------------------------------------------------
# List variables
#-----------------------------------------------------------------------------
def list_valueset_vsac() -> List[Path]:
    """
    :return: list of ValueSet Files from VSAC (source:National Library of Medicine)
    """
    return filetool.list_valuesets('*valueset*')

def list_valueset_uploads() -> List[Path]:
    """
    :return: list of ValueSet Files from upload directory (source= user provided)
    """
    return filetool.list_resources('*valueset*')

def list_valueset_variable_names() -> List[str]:
    """
    List of valueset variable names, excluding special "case definition" and "FHIR diagnostic category".
    :return: sorted list of ValueSet variable names (sources: VSAC and Uploads)
    """
    var_list = list_valueset_vsac() + list_valueset_uploads()
    var_list = [v.name for v in var_list]
    var_list = [v for v in var_list if "casedef" not in v]
    var_list = [v for v in var_list if "diag_category" not in v]
    var_list = [tablespace.name_trim(v) for v in var_list]
    var_list = [v.split('.')[0] for v in var_list]
    return sorted(list(set(var_list)))

def select_union(variable_list: List[str]) -> str:
    """
    :param variable_list: variable names (typically list of valuesets)
    :return: str SQL select UNION ALL for the provided variable list
    """
    sql = list()
    for variable in variable_list:
        variable = name_trim(variable)
        select = f"\tselect distinct '{variable}'\t as variable, code, display, system, encounter_ref "
        from_table = f" from {tablespace.PREFIX}__cohort_{variable}"
        sql.append(select + from_table)
    return ' UNION ALL\n'.join(sql)

def select_lookup_variable_as_column(variable_list: List[str]) -> str:
    """
    :param variable_list: variable names (typically list of valuesets)
    :return: str SQL select variable table as column name
    """
    sql = list()
    for variable in variable_list:
        variable = name_trim(variable)
        sql.append(f"\tIF(lookup.variable='{variable}', True) AS {variable}")
    return ',\n'.join(sql)

def select_lookup_wide(variable_list: List[str]) -> str:
    """
    :param variable_list: variable names (typically list of valuesets)
    :return: str SQL select variable for any arbitrary match (typically on the FHIR encounter)
    """
    sql = list()
    for variable in variable_list:
        variable = name_trim(variable)
        sql.append(f"\tarbitrary({variable})    FILTER (where {variable} ) as {variable}")
    return ',\n'.join(sql)

#-----------------------------------------------------------------------------
# Cohort variable JOIN study population
#-----------------------------------------------------------------------------
def make_cohort(variable: str) -> Path:
    """
    :param variable: variable name (typically valueets)
    :return: str SQL create table for variable with metadata from corresponding study_population_{$Reference}
    """
    ref = tablespace.get_reference(variable)

    population = tablespace.name_study_population(ref.name)
    valueset_name = tablespace.name_valueset(variable)
    cohort_name = tablespace.name_cohort(variable)

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
    template_sql = filetool.load_template(f"cohort_variable_union.sql")
    template_sql = template_sql.replace('$variable_list', select_union(list_valueset_variable_names()))

    cohort_name = tablespace.name_cohort('variable_union')
    target_file = filetool.path_athena(f"{cohort_name}.sql")

    return filetool.save_athena(target_file, template_sql)

def make_wide() -> Path:
    """
    All study variable cohorts in one table in WIDE format.
    each column is a study variable.

    see `template/cohort_study_variables_wide.sql`
    :return: Path to SQL file `athena/irae__cohort_study_variables_wide.sql`
    """
    variable_list = list_valueset_variable_names()
    template_sql = filetool.load_template(f"cohort_variable_wide.sql")
    template_sql = template_sql.replace('$variable_list_lookup', select_lookup_variable_as_column(variable_list))
    template_sql = template_sql.replace('$variable_list_wide', select_lookup_wide(variable_list))

    cohort_name = tablespace.name_cohort('variable_wide')
    target_file = filetool.path_athena(f"{cohort_name}.sql")

    return filetool.save_athena(target_file, template_sql)

def as_toml() -> str:
    """
    Workaround for https://github.com/smart-on-fhir/cumulus-library/issues/439
    :return: str content for `manifest.toml`
    """
    table_list = [tablespace.name_cohort(t) for t in list_valueset_variable_names()]
    key = '"variable cohort"'
    values = [f'"athena/{table_name}.sql",' for table_name in table_list]
    return  key + '= [\n\t'+ '\n\t'.join(values) + '\n]'

#-----------------------------------------------------------------------------
# Make
#-----------------------------------------------------------------------------
def make() -> list[Path]:
    return [make_cohort(variable) for variable in list_valueset_variable_names()]

if __name__ == '__main__':
    target_files = make() + [make_union(), make_wide()]
    print(target_files)
    print(as_toml())
