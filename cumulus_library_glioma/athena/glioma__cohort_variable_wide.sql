create table glioma__cohort_variable_wide as
with lookup as
(
    select  distinct variable, encounter_ref
    from    glioma__cohort_variable_union
),
join_study_period as
(
    select  distinct
            	IF(lookup.variable='diag_pathology', True) AS diag_pathology,
	IF(lookup.variable='dx_neurofibromatosis', True) AS dx_neurofibromatosis,
	IF(lookup.variable='lab_sirolimus', True) AS lab_sirolimus,
	IF(lookup.variable='rx_everolimus', True) AS rx_everolimus,
	IF(lookup.variable='rx_sirolimus', True) AS rx_sirolimus,
            SP.encounter_ref
    from    glioma__cohort_study_period as SP
    left join lookup on SP.encounter_ref = lookup.encounter_ref
),
tabular as
(
    select  distinct
            	arbitrary(diag_pathology)    FILTER (where diag_pathology ) as diag_pathology,
	arbitrary(dx_neurofibromatosis)    FILTER (where dx_neurofibromatosis ) as dx_neurofibromatosis,
	arbitrary(lab_sirolimus)    FILTER (where lab_sirolimus ) as lab_sirolimus,
	arbitrary(rx_everolimus)    FILTER (where rx_everolimus ) as rx_everolimus,
	arbitrary(rx_sirolimus)    FILTER (where rx_sirolimus ) as rx_sirolimus,
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