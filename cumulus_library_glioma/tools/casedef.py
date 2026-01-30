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


########################################################################################################
# make samples
##########################################################################################################
def make_samples() -> list[Path]:
    """
    Make note samples for each casedef temporality [pre, per, peri_post, post]
    """
    samples = [filetool.copy_template('sample_casedef.sql')]

    for temporality in ['pre', 'peri', 'peri_post', 'post']:
        samples += [make_temporality(f'sample_casedef_temporality', temporality),
                    make_temporality(f'sample_casedef_temporality_limit_patient', temporality, 10),
                    make_temporality(f'sample_casedef_temporality_limit_note', temporality, 50)]
    return samples

def make_temporality(template_name:str, temporality:str, limit: int = None) -> Path:
    """
    :param template_name: name of the SQL template to load
    :param temporality: str one of ['pre', 'peri', 'peri_post', 'post']
    :param limit: int patients or notes in sample
    :return: path to Athena SQL
    """
    table_name = template_name.replace('temporality', temporality)

    if limit:
        limit = str(limit)
        table_name = f'{table_name}_{limit}'
    else:
        limit = ''

    replacements = {'$temporality': temporality, '$limit': limit}
    text = filetool.load_template(f'{template_name}.sql', replacements)
    target_table = tablespace.name_prefix(table_name)
    target_file = filetool.path_athena(f'{target_table}.sql')
    return Path(filetool.write_text(text, target_file))


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


