import os

CUMULUS_STUDY_PREFIX = os.environ.get("CUMULUS_TABLE_STUDY", 'glioma')
CUMULUS_CACHE_PREFIX = os.environ.get("CUMULUS_CACHE_PREFIX", False)
CUMULUS_CUBE_MIN_SUBJECTS = int(os.environ.get("CUMULUS_CUBE_MIN_SUBJECTS") or 1)

print('###########################################################')
print('[Environment variables]')
print()
print('Tables will be created with this prefix')
print('CUMULUS_STUDY_PREFIX', '=', CUMULUS_STUDY_PREFIX)
print()
print('Optional: Use cached copies of study population tables')
print('CUMULUS_CACHE_PREFIX', '=', CUMULUS_CACHE_PREFIX)
print()
print('Minimum number of patients per set size in CUBE data')
print('CUMULUS_CUBE_MIN_SUBJECTS', '=', CUMULUS_CUBE_MIN_SUBJECTS)
print()
print('###########################################################')
