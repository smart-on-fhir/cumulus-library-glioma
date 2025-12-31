create table glioma__cohort_study_variables_wide as
with lookup as
(
    select  distinct variable, encounter_ref
    from    glioma__cohort_study_variables
),
join_study_period as
(
    select  distinct
	IF(lookup.variable='diag_pathology', True) AS diag_pathology,
	IF(lookup.variable='lab_sirolimus', True) AS lab_sirolimus,
	IF(lookup.variable='rx_everolimus', True) AS rx_everolimus,
	IF(lookup.variable='rx_sirolimus', True) AS rx_sirolimus,
	IF(lookup.variable='diag_brain_mri', True) AS diag_brain_mri,
	IF(lookup.variable='diag_head_neck', True) AS diag_head_neck,
	IF(lookup.variable='dx_brain_tumor', True) AS dx_brain_tumor,
	IF(lookup.variable='dx_cancer', True) AS dx_cancer,
	IF(lookup.variable='dx_focal_deficit', True) AS dx_focal_deficit,
	IF(lookup.variable='dx_neuropathy', True) AS dx_neuropathy,
	IF(lookup.variable='proc_neurosurgery', True) AS proc_neurosurgery,
	IF(lookup.variable='rx_cancer_directed', True) AS rx_cancer_directed,
	IF(lookup.variable='rx_checkpoint', True) AS rx_checkpoint,
	IF(lookup.variable='rx_chemo', True) AS rx_chemo,
	IF(lookup.variable='rx_chemo_advanced', True) AS rx_chemo_advanced,
	IF(lookup.variable='rx_chemo_platinum', True) AS rx_chemo_platinum,
	IF(lookup.variable='rx_chemo_platinum_carboplatin', True) AS rx_chemo_platinum_carboplatin,
            SP.encounter_ref
    from    glioma__cohort_study_period as SP
    left join lookup on SP.encounter_ref = lookup.encounter_ref
),
tabular as
(
    select  distinct
	arbitrary(diag_pathology)    FILTER (where diag_pathology  is True) as diag_pathology,
	arbitrary(lab_sirolimus)    FILTER (where lab_sirolimus  is True) as lab_sirolimus,
	arbitrary(rx_everolimus)    FILTER (where rx_everolimus  is True) as rx_everolimus,
	arbitrary(rx_sirolimus)    FILTER (where rx_sirolimus  is True) as rx_sirolimus,
	arbitrary(diag_brain_mri)    FILTER (where diag_brain_mri  is True) as diag_brain_mri,
	arbitrary(diag_head_neck)    FILTER (where diag_head_neck  is True) as diag_head_neck,
	arbitrary(dx_brain_tumor)    FILTER (where dx_brain_tumor  is True) as dx_brain_tumor,
	arbitrary(dx_cancer)    FILTER (where dx_cancer  is True) as dx_cancer,
	arbitrary(dx_focal_deficit)    FILTER (where dx_focal_deficit  is True) as dx_focal_deficit,
	arbitrary(dx_neuropathy)    FILTER (where dx_neuropathy  is True) as dx_neuropathy,
	arbitrary(proc_neurosurgery)    FILTER (where proc_neurosurgery  is True) as proc_neurosurgery,
	arbitrary(rx_cancer_directed)    FILTER (where rx_cancer_directed  is True) as rx_cancer_directed,
	arbitrary(rx_checkpoint)    FILTER (where rx_checkpoint  is True) as rx_checkpoint,
	arbitrary(rx_chemo)    FILTER (where rx_chemo  is True) as rx_chemo,
	arbitrary(rx_chemo_advanced)    FILTER (where rx_chemo_advanced  is True) as rx_chemo_advanced,
	arbitrary(rx_chemo_platinum)    FILTER (where rx_chemo_platinum  is True) as rx_chemo_platinum,
	arbitrary(rx_chemo_platinum_carboplatin)    FILTER (where rx_chemo_platinum_carboplatin  is True) as rx_chemo_platinum_carboplatin,
            encounter_ref
    from    join_study_period
    group by encounter_ref
)
select  distinct
        tabular.*   ,
        subject_ref
from    irae__cohort_study_population as study_pop,
        tabular
where   tabular.encounter_ref = study_pop.encounter_ref
;