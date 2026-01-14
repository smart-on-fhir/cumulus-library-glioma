create  table $prefix__cohort_casedef as
WITH
match_casedef as (
    select  distinct
            casedef.code        as dx_code,
            casedef.display     as dx_display,
            casedef.system      as dx_system,
            dx.category_code    as dx_category_code,
            sp.age_at_visit,
            sp.enc_period_start_day,
            sp.enc_period_ordinal,
            dx.subject_ref,
            dx.encounter_ref
    from    $prefix__valueset_casedef as casedef,
            $prefix__cohort_study_population_dx as SP,
            core__condition as dx
    where   casedef.code = dx.code
    and     casedef.system = dx.system
    and     dx.encounter_ref = sp.encounter_ref
),
longitudinal as (
    select  distinct
            sp.enc_period_ordinal,
            sp.enc_period_start_day,
            sp.age_at_visit,
            sp.gender,
            sp.race_display,
            sp.status,
            sp.enc_class_code,
            sp.enc_type_display,
            sp.enc_servicetype_display,
            sp.subject_ref,
            sp.encounter_ref
    from    match_casedef,
            $prefix__cohort_study_population as SP
    where   match_casedef.subject_ref = sp.subject_ref
),
calc_duration as (
    select  distinct
            min(age_at_visit) as age_at_dx_min,
            max(age_at_visit) as age_at_dx_max,
            min(enc_period_ordinal)  as enc_period_ordinal_min,
            min(enc_period_start_day) as enc_period_start_day_min,
            subject_ref
    from    match_casedef
    group by subject_ref
),
calc_days_since as (
    select  date_diff(
                'day',
                date(calc_duration.enc_period_start_day_min),
                date(longitudinal.enc_period_start_day)) as days_since,
            (longitudinal.enc_period_ordinal - enc_period_ordinal_min) as ordinal_since,
            longitudinal.encounter_ref
    from    longitudinal,
            calc_duration
    where   longitudinal.subject_ref = calc_duration.subject_ref
),
calc_ordinal as (
    select  distinct
            days_since,
            ordinal_since,
            (days_since < 0)    as pre,
            (days_since = 0)    as peri,
            (days_since >= 0)   as peri_post,
            (days_since > 0)    as post,
            calc_days_since.encounter_ref
    from    calc_days_since
),
join_longitudinal as (
    select  distinct
            longitudinal.subject_ref,
            longitudinal.encounter_ref,
            calc_ordinal.days_since,
            calc_ordinal.ordinal_since,
            calc_ordinal.pre,
            calc_ordinal.peri,
            calc_ordinal.peri_post,
            calc_ordinal.post,
            calc_duration.enc_period_ordinal_min,
            longitudinal.enc_period_ordinal,
            calc_duration.enc_period_start_day_min,
            longitudinal.enc_period_start_day,
            calc_duration.age_at_dx_min,
            calc_duration.age_at_dx_max,
            longitudinal.age_at_visit,
            longitudinal.gender,
            longitudinal.race_display,
            longitudinal.status,
            longitudinal.enc_class_code,
            longitudinal.enc_type_display,
            longitudinal.enc_servicetype_display
    from    longitudinal,
            calc_duration,
            calc_ordinal
    where   longitudinal.subject_ref = calc_duration.subject_ref
    and     longitudinal.encounter_ref = calc_ordinal.encounter_ref
)
select  distinct
        join_longitudinal.*,
        dx_category_code,
        dx_system,
        dx_code,
        dx_display
from    join_longitudinal
left    join match_casedef
        on  join_longitudinal.encounter_ref = match_casedef.encounter_ref
;