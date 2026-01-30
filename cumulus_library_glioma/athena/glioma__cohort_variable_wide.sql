create table glioma__cohort_variable_wide as
with lookup as
(
    select  distinct variable, encounter_ref
    from    glioma__cohort_variable_union
),
join_study_period as
(
    select  distinct
            	IF(lookup.variable='diag_brain_mri', True) AS diag_brain_mri,
	IF(lookup.variable='diag_head_neck', True) AS diag_head_neck,
	IF(lookup.variable='diag_pathology', True) AS diag_pathology,
	IF(lookup.variable='diag_radiology', True) AS diag_radiology,
	IF(lookup.variable='dx_brain_tumor', True) AS dx_brain_tumor,
	IF(lookup.variable='dx_cancer', True) AS dx_cancer,
	IF(lookup.variable='dx_endo_diabetes', True) AS dx_endo_diabetes,
	IF(lookup.variable='dx_focal_deficit', True) AS dx_focal_deficit,
	IF(lookup.variable='dx_neuro', True) AS dx_neuro,
	IF(lookup.variable='dx_neurofibromatosis', True) AS dx_neurofibromatosis,
	IF(lookup.variable='dx_neuropathy', True) AS dx_neuropathy,
	IF(lookup.variable='lab_mtor_sirolimus', True) AS lab_mtor_sirolimus,
	IF(lookup.variable='proc_neurosurgery', True) AS proc_neurosurgery,
	IF(lookup.variable='rx_cancer_directed', True) AS rx_cancer_directed,
	IF(lookup.variable='rx_chemo', True) AS rx_chemo,
	IF(lookup.variable='rx_chemo_advanced', True) AS rx_chemo_advanced,
	IF(lookup.variable='rx_chemo_bevacizumab', True) AS rx_chemo_bevacizumab,
	IF(lookup.variable='rx_chemo_platinum', True) AS rx_chemo_platinum,
	IF(lookup.variable='rx_chemo_platinum_carboplatin', True) AS rx_chemo_platinum_carboplatin,
	IF(lookup.variable='rx_chemo_vincristine', True) AS rx_chemo_vincristine,
	IF(lookup.variable='rx_endo_diabetes', True) AS rx_endo_diabetes,
	IF(lookup.variable='rx_endo_therapy', True) AS rx_endo_therapy,
	IF(lookup.variable='rx_mtor_everolimus', True) AS rx_mtor_everolimus,
	IF(lookup.variable='rx_mtor_sirolimus', True) AS rx_mtor_sirolimus,
            SP.encounter_ref
    from    glioma__cohort_study_period as SP
    left join lookup on SP.encounter_ref = lookup.encounter_ref
),
tabular as
(
    select  distinct
            	arbitrary(diag_brain_mri)    FILTER (where diag_brain_mri ) as diag_brain_mri,
	arbitrary(diag_head_neck)    FILTER (where diag_head_neck ) as diag_head_neck,
	arbitrary(diag_pathology)    FILTER (where diag_pathology ) as diag_pathology,
	arbitrary(diag_radiology)    FILTER (where diag_radiology ) as diag_radiology,
	arbitrary(dx_brain_tumor)    FILTER (where dx_brain_tumor ) as dx_brain_tumor,
	arbitrary(dx_cancer)    FILTER (where dx_cancer ) as dx_cancer,
	arbitrary(dx_endo_diabetes)    FILTER (where dx_endo_diabetes ) as dx_endo_diabetes,
	arbitrary(dx_focal_deficit)    FILTER (where dx_focal_deficit ) as dx_focal_deficit,
	arbitrary(dx_neuro)    FILTER (where dx_neuro ) as dx_neuro,
	arbitrary(dx_neurofibromatosis)    FILTER (where dx_neurofibromatosis ) as dx_neurofibromatosis,
	arbitrary(dx_neuropathy)    FILTER (where dx_neuropathy ) as dx_neuropathy,
	arbitrary(lab_mtor_sirolimus)    FILTER (where lab_mtor_sirolimus ) as lab_mtor_sirolimus,
	arbitrary(proc_neurosurgery)    FILTER (where proc_neurosurgery ) as proc_neurosurgery,
	arbitrary(rx_cancer_directed)    FILTER (where rx_cancer_directed ) as rx_cancer_directed,
	arbitrary(rx_chemo)    FILTER (where rx_chemo ) as rx_chemo,
	arbitrary(rx_chemo_advanced)    FILTER (where rx_chemo_advanced ) as rx_chemo_advanced,
	arbitrary(rx_chemo_bevacizumab)    FILTER (where rx_chemo_bevacizumab ) as rx_chemo_bevacizumab,
	arbitrary(rx_chemo_platinum)    FILTER (where rx_chemo_platinum ) as rx_chemo_platinum,
	arbitrary(rx_chemo_platinum_carboplatin)    FILTER (where rx_chemo_platinum_carboplatin ) as rx_chemo_platinum_carboplatin,
	arbitrary(rx_chemo_vincristine)    FILTER (where rx_chemo_vincristine ) as rx_chemo_vincristine,
	arbitrary(rx_endo_diabetes)    FILTER (where rx_endo_diabetes ) as rx_endo_diabetes,
	arbitrary(rx_endo_therapy)    FILTER (where rx_endo_therapy ) as rx_endo_therapy,
	arbitrary(rx_mtor_everolimus)    FILTER (where rx_mtor_everolimus ) as rx_mtor_everolimus,
	arbitrary(rx_mtor_sirolimus)    FILTER (where rx_mtor_sirolimus ) as rx_mtor_sirolimus,
            encounter_ref
    from    join_study_period
    group by encounter_ref
)
select  distinct
        tabular.*   ,
        subject_ref
from    glioma__cohort_study_population as study_pop,
        tabular
where   tabular.encounter_ref = study_pop.encounter_ref
;