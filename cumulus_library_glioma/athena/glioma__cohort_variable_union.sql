create table glioma__cohort_variable_union as
with variable_cohorts as
(
	select distinct 'diag_brain_mri'	 as variable, code, display, system, encounter_ref  from glioma__cohort_diag_brain_mri UNION ALL
	select distinct 'diag_head_neck'	 as variable, code, display, system, encounter_ref  from glioma__cohort_diag_head_neck UNION ALL
	select distinct 'diag_pathology'	 as variable, code, display, system, encounter_ref  from glioma__cohort_diag_pathology UNION ALL
	select distinct 'diag_radiology'	 as variable, code, display, system, encounter_ref  from glioma__cohort_diag_radiology UNION ALL
	select distinct 'dx_brain_tumor'	 as variable, code, display, system, encounter_ref  from glioma__cohort_dx_brain_tumor UNION ALL
	select distinct 'dx_cancer'	 as variable, code, display, system, encounter_ref  from glioma__cohort_dx_cancer UNION ALL
	select distinct 'dx_endo_diabetes'	 as variable, code, display, system, encounter_ref  from glioma__cohort_dx_endo_diabetes UNION ALL
	select distinct 'dx_focal_deficit'	 as variable, code, display, system, encounter_ref  from glioma__cohort_dx_focal_deficit UNION ALL
	select distinct 'dx_neuro'	 as variable, code, display, system, encounter_ref  from glioma__cohort_dx_neuro UNION ALL
	select distinct 'dx_neurofibromatosis'	 as variable, code, display, system, encounter_ref  from glioma__cohort_dx_neurofibromatosis UNION ALL
	select distinct 'dx_neuropathy'	 as variable, code, display, system, encounter_ref  from glioma__cohort_dx_neuropathy UNION ALL
	select distinct 'lab_mtor_sirolimus'	 as variable, code, display, system, encounter_ref  from glioma__cohort_lab_mtor_sirolimus UNION ALL
	select distinct 'proc_neurosurgery'	 as variable, code, display, system, encounter_ref  from glioma__cohort_proc_neurosurgery UNION ALL
	select distinct 'rx_cancer_directed'	 as variable, code, display, system, encounter_ref  from glioma__cohort_rx_cancer_directed UNION ALL
	select distinct 'rx_chemo'	 as variable, code, display, system, encounter_ref  from glioma__cohort_rx_chemo UNION ALL
	select distinct 'rx_chemo_advanced'	 as variable, code, display, system, encounter_ref  from glioma__cohort_rx_chemo_advanced UNION ALL
	select distinct 'rx_chemo_bevacizumab'	 as variable, code, display, system, encounter_ref  from glioma__cohort_rx_chemo_bevacizumab UNION ALL
	select distinct 'rx_chemo_platinum'	 as variable, code, display, system, encounter_ref  from glioma__cohort_rx_chemo_platinum UNION ALL
	select distinct 'rx_chemo_platinum_carboplatin'	 as variable, code, display, system, encounter_ref  from glioma__cohort_rx_chemo_platinum_carboplatin UNION ALL
	select distinct 'rx_chemo_vincristine'	 as variable, code, display, system, encounter_ref  from glioma__cohort_rx_chemo_vincristine UNION ALL
	select distinct 'rx_endo_diabetes'	 as variable, code, display, system, encounter_ref  from glioma__cohort_rx_endo_diabetes UNION ALL
	select distinct 'rx_endo_therapy'	 as variable, code, display, system, encounter_ref  from glioma__cohort_rx_endo_therapy UNION ALL
	select distinct 'rx_mtor_everolimus'	 as variable, code, display, system, encounter_ref  from glioma__cohort_rx_mtor_everolimus UNION ALL
	select distinct 'rx_mtor_sirolimus'	 as variable, code, display, system, encounter_ref  from glioma__cohort_rx_mtor_sirolimus
)
select distinct
    variable_cohorts.variable,
    variable_cohorts.code,
    variable_cohorts.display,
    variable_cohorts.system,
    SP.status,
    SP.age_at_visit,
    SP.gender,
    SP.race_display,
    SP.ethnicity_display,
    SP.enc_class_code,
    SP.enc_period_ordinal,
    SP.enc_period_start_day,
    SP.enc_period_end_day,
    SP.encounter_ref,
    SP.subject_ref
from
    variable_cohorts,
    glioma__cohort_study_population as SP
where
    variable_cohorts.encounter_ref = SP.encounter_ref
;

