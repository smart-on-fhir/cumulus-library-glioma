from pathlib import Path
from cumulus_library_glioma.tools import filetool, tablespace
from cumulus_library_glioma.tools.tablespace import name_prefix

VERBOSE = True

TABLE_LIST = [
    'cohort_study_period',
    'cohort_study_population',
    'cohort_study_population_dx',
    'cohort_study_population_rx',
    'cohort_study_population_obs',
    'cohort_study_population_lab',
    'cohort_study_population_doc',
    'cohort_study_population_diag',
]

def drop_cache(table_list:list, cache='cache') -> list[str]:
    return [f'drop table {cache}__{table}' for table in table_list]

def create_cache(table_list:list, cache='cache') -> list[str]:
    return [f'create table {cache}__{table} as select * from {name_prefix(table)};' for table in table_list]

def view_cache(table_list:list, cache='cache') -> list[str]:
    return [f'create or replace view {cache}__{table} as select * from {table};' for table in table_list]

###############################################################################
# Make
###############################################################################

def make_study_population():
    pass

if __name__ == '__main__':
    target_list = create_cache(TABLE_LIST)

    if VERBOSE:
        print('#######################################################################')
        print(target_list)
        print('#######################################################################')
