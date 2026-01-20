import os
CUMULUS_CACHE_PREFIX = os.environ.get("CUMULUS_CACHE_PREFIX", None)
CUMULUS_CUBE_MIN_SUBJECTS = int(os.environ.get("CUMULUS_CUBE_MIN_SUBJECTS") or 1)

print('###########################################################')
print('[Settings]')
print()
print('Optional: Use cached copies of study population tables')
print('CUMULUS_CACHE_PREFIX', '=', CUMULUS_CACHE_PREFIX)
print()
print('Optional: Minimum number of patients per set size in CUBE data')
print('CUMULUS_CUBE_MIN_SUBJECTS', '=', CUMULUS_CUBE_MIN_SUBJECTS)
print()
print('###########################################################')
