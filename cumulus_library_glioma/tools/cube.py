from pathlib import Path
from cumulus_library.builders.counts import CountsBuilder
from cumulus_library_glioma.tools import filetool
from cumulus_library_glioma.tools.tablespace import name_trim, name_cube, ctas_as_view
from cumulus_library_glioma.tools.settings import CUMULUS_CUBE_MIN_SUBJECTS
from cumulus_library_glioma.tools import manifest

def cube_fhir_resource(primary_id:str,
                       source_table='study_population',
                       table_cols=None,
                       table_name=None,
                       min_subject=CUMULUS_CUBE_MIN_SUBJECTS) -> Path:
    """Generates a counts table using a template

    :param primary_id: The type of FHIR resource to count
    :param source_table: The table to create counts data from
    :param table_cols: The columns from the source table to add to the count table
    :param table_name: The name of the table to create. Must start with study prefix
    :param min_subject: Minimum number of patients to include in result groupings
    """
    if not table_name:
        count_type = primary_id.replace('_ref', '')
        count_type = count_type if (count_type!='subject') else 'patient'
        table_name = name_trim(source_table)
        table_name = name_cube(table_name, count_type)

    table_cols = sorted(list(set(table_cols)))
    sql = CountsBuilder(manifest=manifest.get_manifest()).get_count_query(
            table_name=table_name,
            source_table=source_table,
            table_cols=table_cols,
            min_subject=min_subject,
            primary_id=primary_id,
    )
    sql = ctas_as_view(sql, table_name)
    return filetool.save_athena_view(table_name, sql)

def cube_patient(source_table='study_population',
                 table_cols=None,
                 table_name=None,
                 min_subject=CUMULUS_CUBE_MIN_SUBJECTS) -> Path:
    return cube_fhir_resource(
        primary_id='subject_ref',
        source_table=source_table,
        table_cols=table_cols,
        table_name=table_name,
        min_subject=min_subject)

def cube_encounter(source_table='study_population',
                   table_cols=None,
                   table_name=None,
                   min_subject=CUMULUS_CUBE_MIN_SUBJECTS) -> Path:
    return cube_fhir_resource(
        primary_id='encounter_ref',
        source_table=source_table,
        table_cols=table_cols,
        table_name=table_name,
        min_subject=min_subject)

def cube_document(source_table='study_population',
                  table_cols=None,
                  table_name=None,
                  min_subject=CUMULUS_CUBE_MIN_SUBJECTS) -> Path:
    return cube_fhir_resource(
        primary_id='documentreference_ref',
        source_table=source_table,
        table_cols=table_cols,
        table_name=table_name,
        min_subject=min_subject)

def cube_note(source_table='study_population',
              table_cols=None,
              table_name=None,
              min_subject=CUMULUS_CUBE_MIN_SUBJECTS) -> Path:
    """
    Workaround for issue#446, will be fixed in next cumulus-library
    https://github.com/smart-on-fhir/cumulus-library/issues/446
    """
    if not table_name:
        table_name = name_cube(name_trim(source_table), 'note')

    file_path = cube_fhir_resource(
        primary_id='note_ref',
        source_table=source_table,
        table_cols=table_cols,
        table_name=table_name,
        min_subject=min_subject)

    text = filetool.read_text(file_path)
    text = text.replace('documentreference_ref', 'note_ref')
    filetool.write_text(text, file_path)
    file_path.with_name(f'{table_name}.sql')
    return file_path

#-----------------------------------------------------------------------------
# Make CUBE for casedef
#-----------------------------------------------------------------------------
def make_casedef() -> list[Path]:
    return [
        # Count encounters for casedef
        cube_encounter(source_table='glioma__cohort_casedef',
                       table_cols=['dx_category_code',
                                   'age_at_dx_min',
                                   'age_at_visit',
                                   'enc_class_code',
                                   'enc_type_display',
                                   'enc_servicetype_display',
                                   'enc_period_ordinal']),

        # Count patients for casedef
        cube_patient(source_table='glioma__cohort_casedef',
                     table_cols=['dx_category_code',
                                 'dx_code',
                                 'dx_system',
                                 'dx_display',
                                 'age_at_dx_min',
                                 'gender',
                                 'race_display']),

        # Comorbidities
        cube_patient(source_table='glioma__cohort_casedef_dx',
                     table_cols=['dx_category_code',
                                 'dx_code',
                                 'dx_system',
                                 'dx_display',
                                 'age_at_visit',
                                 'gender',
                                 'race_display'],
                     table_name='glioma__cube_patient_casedef_dx_comorbidity'),

        # Drugs
        cube_patient(source_table='glioma__cohort_casedef_rx',
                     table_cols=['rx_status',
                                 'rx_category_code',
                                 'rx_code',
                                 'rx_system',
                                 'rx_display',
                                 'age_at_visit',
                                 'gender',
                                 'race_display']),

        # Glioma Drugs
        cube_patient(source_table='glioma__cohort_casedef_rx_variable',
                     table_cols=['rx_category_code',
                                 'rx_code',
                                 'rx_system',
                                 'rx_display',
                                 'valueset']),

        # Procedures
        cube_patient(source_table='glioma__cohort_casedef_proc',
                     table_cols=['proc_status',
                                 'proc_code',
                                 'proc_system',
                                 'proc_display',
                                 'enc_class_code']),

        # Lab Observations
        cube_patient(source_table='glioma__cohort_casedef_lab',
                     table_cols=['lab_observation_code',
                                 'lab_observation_system',
                                 'lab_observation_display',
                                 'enc_class_code']),

        # Notes (any temporality)
        cube_patient(source_table='glioma__sample_casedef',
                     table_cols=['fhir_resource',
                                 'note_code',
                                 'note_display',
                                 'note_system']),

        cube_note(source_table='glioma__sample_casedef',
                  table_cols=['fhir_resource',
                              'note_code',
                              'note_display',
                              'note_system']),

        # Notes during or after casedef "peri- and post- periods"
        cube_patient(source_table='glioma__sample_casedef_peri_post',
                  table_cols=['fhir_resource',
                              'note_code',
                              'note_display',
                              'note_system']),

        cube_note(source_table='glioma__sample_casedef_peri_post',
                  table_cols=['fhir_resource',
                              'note_code',
                              'note_display',
                              'note_system']),
    ]

#-----------------------------------------------------------------------------
# Make FHIR variables
#-----------------------------------------------------------------------------
def make_fhir_variables_deprecated() -> list[Path]:
    return [

        # Count Patients for Any/All coded Glioma Study Variable
        cube_patient(source_table='glioma__cohort_variable_union',
                     table_cols=['variable',
                                 'code',
                                 'system',
                                 'display'],
                     min_subject=10),

        # Count Encounters for Any/All coded Glioma Study Variable
        cube_encounter(source_table='glioma__cohort_variable_union',
                       table_cols=['variable',
                                 'display',
                                 'enc_class_code',
                                 'enc_period_ordinal',
                                 'age_at_visit',
                                 'gender'],
                       min_subject=10),

        # Glioma specific DiagnosticReports types
        cube_patient(source_table='glioma__cohort_variable_wide',
                     table_name='glioma__cube_patient_variable_wide_diag',
                     table_cols=['diag_brain_mri',
                                 'diag_head_neck',
                                 'diag_pathology',
                                 'diag_radiology'],
                     min_subject=10),

        # Neurology [dx, rx]
        cube_patient(source_table='glioma__cohort_variable_wide',
                     table_name='glioma__cube_patient_variable_wide_neuro',
                     table_cols=['dx_focal_deficit',
                                 'dx_neuro',
                                 'dx_neurofibromatosis',
                                 'dx_neuropathy',
                                 'proc_neurosurgery'],
                     min_subject=10),

        # Endocrine [dx, rx]
        cube_patient(source_table='glioma__cohort_variable_wide',
                     table_name='glioma__cube_patient_variable_wide_endo',
                     table_cols=['dx_endo_diabetes',
                                 'rx_endo_diabetes',
                                 'rx_endo_therapy'],
                     min_subject=10),

        # Cancer [dx, rx]
        cube_patient(source_table='glioma__cohort_variable_wide',
                     table_name='glioma__cube_patient_variable_wide_cancer',
                     table_cols=['dx_brain_tumor',
                                 'dx_cancer',
                                 'rx_cancer_directed',
                                 'rx_chemo',
                                 'rx_chemo_advanced',
                                 'rx_chemo_bevacizumab',
                                 'rx_chemo_platinum',
                                 'rx_chemo_platinum_carboplatin',
                                 'rx_chemo_vincristine'],
                     min_subject=10),
    ]

#-----------------------------------------------------------------------------
# Make LLM variables
#-----------------------------------------------------------------------------
def make_llm_variables_deprecated() -> list[Path]:
    return [
        cube_patient(source_table='glioma__llm_dx',
                     table_cols=['topography_has_mention',
                                 'topography_display_best',
                                 'morphology_has_mention',
                                 'morphology_display_best',
                                 'behavior_has_mention',
                                 'behavior_display_best',
                                 'grade_has_mention',
                                 'grade_display_best',
                                 'category_display_best'],
                     min_subject=10),

        cube_patient(source_table='glioma__llm_surgery',
                     table_cols=['has_mention',
                                 'surgical_type',
                                 'approach',
                                 'extent_of_resection',
                                 'anatomical_site',
                                 'technique_details',
                                 'complications']),

        cube_patient(source_table='glioma__llm_drug',
                     table_cols=['has_mention',
                                 'status',
                                 'category',
                                 'route',
                                 'phase',
                                 'rx_class']),

        cube_patient(source_table='glioma__llm_variant',
                     table_cols=['has_mention',
                                 'hgnc_name',
                                 'hgvs_variant',
                                 'interpretation']),

        cube_patient(source_table='glioma__llm_gene',
                     table_cols=['has_mention',
                                 'braf_altered',
                                 'braf_v600e',
                                 'braf_fusion',
                                 'idh_mutant',
                                 'h3k27m_mutant',
                                 'tp53_altered',
                                 'cdkn2a_deleted'])
    ]

#-----------------------------------------------------------------------------
# MAIN method
#-----------------------------------------------------------------------------
if __name__ == "__main__":
    fhir_cube_files = make_casedef()
    print(manifest.as_toml_parallel(fhir_cube_files, 'cube casedef'))

    #fhir_cube_files = make_fhir_variables_deprecated()
    #print(manifest.as_toml_parallel(fhir_cube_files, 'cube FHIR'))

    #llm_cube_files = make_llm_variables_deprecated()
    #print(manifest.as_toml_parallel(llm_cube_files, 'cube LLM'))
