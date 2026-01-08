from pathlib import Path
from cumulus_library_glioma.tools import filetool, tablespace
from cumulus_library_glioma.tools.settings import CUMULUS_CACHE_PREFIX
from cumulus_library_glioma.tools.tablespace import name_prefix

#-----------------------------------------------------------------------------
# List of study population tables.
#
# cohort_study_period = patient encounters specified by "include_study_period"
#
# cohort_study_population = patient encounters with additional metadata
#
# cohort_study_population_{$Reference} = see `tools.tablespace.Reference`
#-----------------------------------------------------------------------------
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

#-----------------------------------------------------------------------------
# caching:  study population can include all/nearly all patient encounters.
#           creating cached copies can improve study build time.
#
#-----------------------------------------------------------------------------
def create_view(table:str, cache='cache') -> Path:
    """
    :param table: source table
    :param cache: target table cached copy prefix
    :return: str SQL to create copy of study population table
    """
    cvas = f"create or replace view {name_prefix(table)} as select * from {cache}__{table};"
    target = tablespace.name_prefix(table) + '.sql'
    return filetool.save_athena(target, cvas)

def create_cache(table_list:list, cache='cache') -> list[str]:
    """
    :param table_list: source table list like ['glioma__study_period', 'glioma__study_population']
    :param cache: target table prefix like 'cache' -> ['cache__study_period', 'cache__study_population']
    :return: str SQL to create a cached copy of study population tables
    """
    return [f'create table {cache}__{table} as select * from {name_prefix(table)};' for table in table_list]

def drop_cache(table_list:list, cache='cache') -> list[str]:
    """
    :return: str SQL to DROP shadow copies of study population tables.
    """
    return [f'drop table {cache}__{table}' for table in table_list]

###############################################################################
# Make
###############################################################################
def make_study_population(table_list:list, cache:str|bool =False) -> list[Path]:
    if cache:
        return [create_view(table, cache) for table in table_list]
    else:
        return [filetool.copy_template(f"{table}.sql") for table in table_list]

if __name__ == '__main__':
    target_list = make_study_population(TABLE_LIST, CUMULUS_CACHE_PREFIX)
    print(target_list)
