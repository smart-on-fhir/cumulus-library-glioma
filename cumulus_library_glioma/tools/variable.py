from typing import List
from pathlib import Path
from cumulus_library_glioma.tools import filetool
from cumulus_library_glioma.tools.tablespace import (
    Reference,
    ctas,
    name_prefix,
    name_study_population,
    name_cohort
)

###############################################################################
# List variables
###############################################################################
def list_variable_path() -> List[Path]:
    return filetool.list_valueset('*.valueset.tsv')

def list_variable_name() -> List[str]:
    var_list = [v.name for v in list_variable_path()]
    var_list = [v.split('.')[0] for v in var_list]
    return var_list

###############################################################################
# EACH Select Variable, make a cohort for each by itself.
###############################################################################
def make_each_study_variable() -> List[Path]:
    """
    :return: List of SQL files for each study variable COHORT.
    """
    group_list = list()
    for variable in list_variable_name():
        ref = Reference.get(variable)
        group_list.append(ref.name)

        cohort_study_population(variable)

        # if '__dx' in variable:
        #     group_list.append(cohort_dx(variable))
        # elif '__rx' in variable:
        #     group_list.append(cohort_rx(variable))
        # elif '__lab' in variable:
        #     group_list.append(cohort_lab(variable))
        # elif '__proc' in variable:
        #     group_list.append(cohort_proc(variable))
        # elif '__doc' in variable:
        #     group_list.append(cohort_doc(variable))
        # else:
        #     raise Exception(f'unknown variable type {variable}')
    return group_list

###############################################################################
# Cohort variable JOIN study population
###############################################################################
def cohort_study_population(variable: str) -> Path:
    key = Reference.get(variable)
    population = name_study_population(key.name)
    where = [f'{population}.{key.code()} = {variable}.code',
             f'{population}.{key.system()} = {variable}.system']

    view_name = name_cohort(variable)
    sql = ctas(population, variable, where)
    return filetool.save_athena_view(view_name, sql)

###############################################################################
# Make
###############################################################################
def make() -> list[Path]:
    return make_each_study_variable()

if __name__ == '__main__':
    target_files = make()
    print(target_files)
