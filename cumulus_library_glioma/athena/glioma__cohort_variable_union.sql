create table glioma__cohort_variable_union as
with variable_cohorts as
(
	select distinct 'diag_pathology'	 as variable, code, display, system, encounter_ref  from glioma__cohort_diag_pathology UNION ALL
	select distinct 'dx_neurofibromatosis'	 as variable, code, display, system, encounter_ref  from glioma__cohort_dx_neurofibromatosis UNION ALL
	select distinct 'lab_sirolimus'	 as variable, code, display, system, encounter_ref  from glioma__cohort_lab_sirolimus UNION ALL
	select distinct 'rx_everolimus'	 as variable, code, display, system, encounter_ref  from glioma__cohort_rx_everolimus UNION ALL
	select distinct 'rx_sirolimus'	 as variable, code, display, system, encounter_ref  from glioma__cohort_rx_sirolimus
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

