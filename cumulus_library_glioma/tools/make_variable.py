from typing import List
from pathlib import Path
from cumulus_library_glioma.tools import filetool, tablespace

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

###############################################################################
# Make
###############################################################################
def make() -> list[Path]:
    return [make_cohort(variable) for variable in list_variable_names()]

if __name__ == '__main__':
    target_files = make()
    print(target_files)
