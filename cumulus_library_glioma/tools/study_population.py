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

###############################################################################
# Make
###############################################################################

def make_study_population():
    pass

if __name__ == '__main__':
    target_files = make_study_population()

    if VERBOSE:
        print('#######################################################################')
        print(target_files)
        print('#######################################################################')
        print(as_toml())
