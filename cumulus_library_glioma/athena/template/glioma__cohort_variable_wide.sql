create table $prefix__cohort_study_variables_wide as
with lookup as
(
    select  distinct variable, valueset, encounter_ref
    from    $prefix__cohort_study_variables
),
join_study_period as
(
    select  distinct
            $variable_list_lookup,
            SP.encounter_ref
    from    $prefix__cohort_study_period as SP
    left join lookup on SP.encounter_ref = lookup.encounter_ref
),
tabular as
(
    select  distinct
            $variable_list_wide,
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