import os
from cumulus_library import StudyManifest

CUMULUS_CACHE_PREFIX = os.environ.get("CUMULUS_CACHE_PREFIX", False)
CUMULUS_CUBE_MIN_SUBJECTS = int(os.environ.get("CUMULUS_CUBE_MIN_SUBJECTS") or 1)

print('###########################################################')
print('[Settings]')
print()
print('study prefix for tablespace', '=', StudyManifest().get_study_prefix())
print()
print('Optional: Use cached copies of study population tables')
print('CUMULUS_CACHE_PREFIX', '=', CUMULUS_CACHE_PREFIX)
print()
print('Optional: Minimum number of patients per set size in CUBE data')
print('CUMULUS_CUBE_MIN_SUBJECTS', '=', CUMULUS_CUBE_MIN_SUBJECTS)
print()
print('###########################################################')
