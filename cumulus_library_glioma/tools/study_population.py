from pathlib import Path
from cumulus_library_glioma.tools import filetool, tablespace
from cumulus_library_glioma.tools.tablespace import name_prefix

TABLE_LIST = sorted([
    'cohort_study_period',
    'cohort_study_population',
    'cohort_study_population_dx',
    'cohort_study_population_rx',
    'cohort_study_population_proc',
    'cohort_study_population_lab',
    'cohort_study_population_doc',
    'cohort_study_population_diag',
])

###############################################################################
# caching
###############################################################################
def drop_cache(table_list:list, cache='cache') -> list[str]:
    return [f'drop table {cache}__{table}' for table in table_list]

def create_cache(table_list:list, cache='cache') -> list[str]:
    return [f'create table {cache}__{table} as select * from {name_prefix(table)};' for table in table_list]

def create_view(table:str, cache='cache') -> Path:
    cvas = f"create or replace view {name_prefix(table)} as select * from {cache}__{table};"
    target = tablespace.name_prefix(table) + '.sql'
    return filetool.save_athena(target, cvas)

###############################################################################
# Make
###############################################################################
def make_study_population(table_list:list, cache:str|bool =False) -> list[Path]:
    if cache:
        return [create_view(table, cache) for table in table_list]
    else:
        return [filetool.copy_template(f"{table}.sql") for table in table_list]

if __name__ == '__main__':
    target_list = make_study_population(TABLE_LIST, 'cache')
    # target_list = make_study_population(TABLE_LIST)

    print('#######################################################################')
    print(target_list)
    print('#######################################################################')
