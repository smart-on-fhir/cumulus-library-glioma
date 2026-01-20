from pathlib import Path
from cumulus_library_glioma.tools import filetool, tablespace, manifest

def make_cohort() -> list[Path]:
    """
    Make case definition cohort(s)
    """
    return [filetool.copy_template('cohort_casedef.sql')]

def make_cohort_aspects() -> list[Path]:
    """
    Make cohort for casdef [dx, rx, lab, proc]
    """
    return [filetool.copy_template(f'cohort_casedef_{aspect}.sql')
            for aspect in ['dx', 'rx', 'lab', 'proc']]

def make_samples() -> list[Path]:
    """
    Make note samples for each casedef temporality [pre, per, peri_post, post]
    """
    samples = list()
    samples.append(filetool.copy_template('sample_casedef.sql')) # all note samples for casedef
    for temporality in ['pre', 'peri', 'peri_post', 'post']:
        replacements = {'$temporality': temporality}
        text = filetool.load_template('sample_casedef_temporality.sql', replacements)
        target_table = tablespace.name_prefix(f'sample_casedef_{temporality}')
        target_file = filetool.path_athena(f'{target_table}.sql')
        samples.append(Path(filetool.write_text(text, target_file)))
    return samples

#-----------------------------------------------------------------------------
# Make
#-----------------------------------------------------------------------------
def make() -> list[Path]:
    cohort_files = make_cohort()
    aspect_files = make_cohort_aspects()
    sample_files = make_samples()

    toml_files = [
        manifest.as_toml_parallel(cohort_files, 'cohort from case definition (valueset_casedef)'),
        manifest.as_toml_parallel(aspect_files, 'cohort for case definition aspects [dx, rx, lab, proc]'),
        manifest.as_toml_parallel(sample_files, 'samples for casedef temporality [pre, per, peri_post, post]'),
    ]
    toml_files = '\n'.join(toml_files)
    print(toml_files)

    return cohort_files + sample_files

if __name__ == '__main__':
    make()


