from pathlib import Path
from cumulus_library_glioma.tools import filetool, tablespace, manifest

def make_cohort() -> list[Path]:
    """
    Make case definition cohort(s)
    """
    return [filetool.copy_template('cohort_casedef.sql')]

def make_temporality() -> list[Path]:
    """
    Make case definition for each temporality [pre, per, peri_post, post]
    """
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
    cohort_files = make_cohort()
    sample_files = make_temporality()

    toml_files = [
        manifest.as_toml(cohort_files, 'cohort for case definition'),
        manifest.as_toml(sample_files, 'temporality for case definition')
    ]
    toml_files = '\n'.join(toml_files)
    print(toml_files)

    return cohort_files + sample_files

if __name__ == '__main__':
    make()


