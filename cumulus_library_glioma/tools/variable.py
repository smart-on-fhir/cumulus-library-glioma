from typing import List
from pathlib import Path
from cumulus_library_glioma.tools import filetool, tablespace

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
        ref = tablespace.Reference.get(variable)
        group_list.append(ref.name)

        make_cohort(variable)

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
def make_cohort(variable: str) -> Path:
    key = tablespace.Reference.get(variable)

    population = tablespace.name_study_population(key.name)
    valueset_name = tablespace.name_valueset(variable)
    cohort_name = tablespace.name_cohort(variable)

    where = [f'{population}.{key.code()} = {valueset_name}.code',
             f'{population}.{key.system()} = {valueset_name}.system']

    sql = tablespace.ctas(population, variable, where)
    return filetool.save_athena_view(cohort_name, sql)

###############################################################################
# Make
###############################################################################
def make() -> list[Path]:
    return make_each_study_variable()

if __name__ == '__main__':
    target_files = make()
    print(target_files)
