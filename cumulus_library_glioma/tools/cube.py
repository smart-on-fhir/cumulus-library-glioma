from pathlib import Path
from cumulus_library.builders.counts import CountsBuilder
from cumulus_library_glioma.tools import filetool
from cumulus_library_glioma.tools.tablespace import name_trim, name_cube, ctas_as_view
from cumulus_library_glioma.tools.settings import CUMULUS_CUBE_MIN_SUBJECTS, CUMULUS_CUBE_AS_VIEW
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
    if CUMULUS_CUBE_AS_VIEW == 1:
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
    return cube_fhir_resource(
        primary_id='note_ref',
        source_table=source_table,
        table_cols=table_cols,
        table_name=table_name,
        min_subject=min_subject)

#-----------------------------------------------------------------------------
# Make CUBE for casedef
#-----------------------------------------------------------------------------
def make_study_population() -> list[Path]:
    return [
        # encounters for study population
        cube_encounter(source_table='glioma__cohort_study_population',
                       table_cols=['enc_type_display',
                                   'enc_class_code',
                                   'enc_servicetype_display']),

        # patients for study population
        cube_patient(source_table='glioma__cohort_study_population',
                     table_cols=['age_at_visit',
                                 'gender',
                                 'race_display']),

        # Diagnosis
        cube_patient(source_table='glioma__cohort_study_population_dx',
                     table_cols=['dx_category_code',
                                 'dx_code',
                                 'dx_system',
                                 'dx_display',
                                 'age_at_visit']),

        # Medications
        cube_patient(source_table='glioma__cohort_study_population_rx',
                     table_cols=['rx_category_code',
                                 'rx_code',
                                 'rx_display']),

        # Procedures
        cube_patient(source_table='glioma__cohort_study_population_proc',
                     table_cols=['proc_status',
                                 'proc_code',
                                 'proc_system',
                                 'proc_display',
                                 'enc_class_code']),

        # Lab Observations
        cube_patient(source_table='glioma__cohort_study_population_lab',
                     table_cols=['lab_observation_code',
                                 'lab_observation_system',
                                 'lab_observation_display',
                                 'enc_class_code']),

        # Documents
        cube_patient(source_table='glioma__cohort_study_population_doc',
                     table_cols=['doc_status',
                                 'doc_type_system',
                                 'doc_type_code',
                                 'doc_type_display',
                                 'enc_class_code']),

        # Diagnostic Reports
        cube_patient(source_table='glioma__cohort_study_population_diag',
                     table_cols=['diag_category_display_best',
                                 'diag_category_system',
                                 'enc_class_code',
                                 'enc_type_display',
                                 'enc_servicetype_display']),
    ]

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

        # Drugs ** GLIOMA specific variables ***
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
                                 'display']),

        # Count Encounters for Any/All coded Glioma Study Variable
        cube_encounter(source_table='glioma__cohort_variable_union',
                       table_cols=['variable',
                                 'display',
                                 'enc_class_code',
                                 'enc_period_ordinal',
                                 'age_at_visit',
                                 'gender']),

        # Glioma specific DiagnosticReports types
        cube_patient(source_table='glioma__cohort_variable_wide',
                     table_name='glioma__cube_patient_variable_wide_diag',
                     table_cols=['diag_brain_mri',
                                 'diag_head_neck',
                                 'diag_pathology',
                                 'diag_radiology']),

        # Neurology [dx, rx]
        cube_patient(source_table='glioma__cohort_variable_wide',
                     table_name='glioma__cube_patient_variable_wide_neuro',
                     table_cols=['dx_focal_deficit',
                                 'dx_neuro',
                                 'dx_neurofibromatosis',
                                 'dx_neuropathy',
                                 'proc_neurosurgery']),

        # Endocrine [dx, rx]
        cube_patient(source_table='glioma__cohort_variable_wide',
                     table_name='glioma__cube_patient_variable_wide_endo',
                     table_cols=['dx_endo_diabetes',
                                 'rx_endo_diabetes',
                                 'rx_endo_therapy']),

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
                                 'rx_chemo_vincristine']),
    ]

#-----------------------------------------------------------------------------
# Make LLM variables
#-----------------------------------------------------------------------------
def make_llm_variables() -> list[Path]:
    return [
        cube_patient(source_table='glioma__llm_dx',
                     table_cols=['age_at_dx',
                                 'histology',
                                 'tumor_location',
                                 'tumor_region',
                                 'tumor_size_mass_effect',
                                 'grade_code',
                                 'behavior_code',
                                 'nf1_status']),

        cube_patient(source_table='glioma__llm_dx_progression',  # requires LLM
                     table_cols=[
                         'age_at_dx',
                         'histology',
                         'grade_code',
                         'tumor_location',
                         'tumor_size_mass_effect',
                         'progression',
                         'progression_bin',
                         'regrowth_pattern',
                         'symptom_burden',
                         'visual_status'
                     ]),

        cube_patient(source_table='glioma__llm_surgery',
                     table_cols=['surgical_type',
                                 'approach',
                                 'extent_of_resection']),

        cube_patient(source_table='glioma__llm_progression',
                     table_cols=['age_at_progression',
                                 'progression',
                                 'progression_bin',
                                 'regrowth_pattern',
                                 'symptom_burden',
                                 'visual_status',
                                 'neurocognitive_risk',
                                 'therapy_modality',
                                 'clinical_trial_status']),

        cube_patient(source_table='glioma__llm_rx_chemo',
                     table_cols=['rx_regimen',
                                 'rx_class',
                                 'rx_status',
                                 'rx_treatment_phase',
                                 'rx_treatment_response',
                                 'rx_toxicity_severity',
                                 'rx_treatment_discontinued']),

        cube_patient(source_table='glioma__llm_rx_target',
                     table_cols=['rx_class',
                                 'rx_status',
                                 'rx_treatment_phase',
                                 'rx_treatment_response',
                                 'rx_toxicity_severity',
                                 'rx_treatment_discontinued']),

        cube_patient(source_table='glioma__llm_tx_response_30_days',  # requires LLM
                     table_cols=['tx_modality',
                                 'tx_class',
                                 'tx_specific',
                                 'progression',
                                 'progression_bin',
                                 'regrowth_pattern',
                                 'symptom_burden',
                                 'visual_status']),

        cube_patient(source_table='glioma__llm_gene',
                     table_cols=['braf_altered',
                                 'braf_v600e',
                                 'braf_fusion',
                                 'idh_mutant',
                                 'variant_interpretation',
                                 'hgnc_name']),

        cube_patient(source_table='glioma__llm_gene_progression',
                     table_cols=['braf_altered',
                                 'braf_v600e',
                                 'braf_fusion',
                                 'idh_mutant',
                                 'progression',
                                 'progression_bin',
                                 'symptom_burden',
                                 'visual_status'])

    ]

#-----------------------------------------------------------------------------
# MAIN method
#-----------------------------------------------------------------------------
if __name__ == "__main__":

    file_list = make_study_population()
    print(manifest.as_toml_parallel(file_list, 'cube study population (dx, rx, lab, proc, doc, diag)'))

    file_list = make_casedef()
    print(manifest.as_toml_parallel(file_list, 'cube casedef'))

    file_list = make_llm_variables()
    print(manifest.as_toml_parallel(file_list, 'cube LLM'))