from pathlib import Path
from cumulus_library_glioma.tools import filetool, tablespace, manifest

def make_cohort() -> list[Path]:
    return [filetool.copy_template('cohort_casedef.sql')]

def make_samples() -> list[Path]:
    samples = list()
    for temporality in ['pre', 'peri', 'peri_post', 'post']:
        replacements = {'$temporality': temporality}
        text = filetool.load_template('sample_casedef.sql', replacements)
        target_table = tablespace.name_prefix(f'sample_casedef_{temporality}')
        target_file = filetool.path_athena(f'{target_table}.sql')
        samples.append(Path(filetool.write_text(text, target_file)))
    return samples

#-----------------------------------------------------------------------------
# Make
#-----------------------------------------------------------------------------
def make() -> list[Path]:
    return make_cohort()

if __name__ == '__main__':
    cohort_files = make_cohort()
    print(manifest.as_toml(cohort_files, 'cohort case definition'))

    sample_files = make_samples()
    print(manifest.as_toml(sample_files, 'samples of case definition'))
