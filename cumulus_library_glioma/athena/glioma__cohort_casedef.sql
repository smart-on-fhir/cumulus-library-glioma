create  table glioma__cohort_casedef as
WITH
match_casedef as
(
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
    from    glioma__valueset_casedef as casedef,
            glioma__cohort_study_population_dx as SP,            
            core__condition as dx
    where   casedef.code = dx.code
    and     casedef.system = dx.system
    and     dx.encounter_ref = sp.encounter_ref
),
duration as
(
    select  distinct
            min(age_at_visit) as age_at_dx_min,
            max(age_at_visit) as age_at_dx_max,
            min(enc_period_ordinal)  as enc_period_ordinal_min,
            min(enc_period_start_day) as enc_period_start_day_min,
            subject_ref
    from    match_casedef
    group by subject_ref
), 
cohort as 
(
    select  distinct
            duration.age_at_dx_min,
            duration.age_at_dx_max,
            duration.enc_period_ordinal_min,
            duration.enc_period_start_day_min,
            match_casedef.*
    from    match_casedef, 
            duration 
    where   duration.subject_ref   = match_casedef.subject_ref
),
longitudinal as
(
    select  distinct
            sp.age_at_visit,
            sp.gender,
            sp.race_display,
            sp.status,
            sp.enc_period_start_day,
            sp.enc_period_start_year,
            sp.enc_period_ordinal,
            sp.enc_class_code,
            sp.enc_type_display,
            sp.enc_servicetype_display,
            sp.subject_ref,            
            sp.encounter_ref
    from    match_casedef,
            glioma__cohort_study_population as SP
    where   match_casedef.subject_ref = sp.subject_ref
)
select      distinct
            cohort.age_at_dx_min,
            cohort.age_at_dx_max,
            cohort.enc_period_ordinal_min,
            cohort.enc_period_start_day_min,
            cohort.dx_category_code, 
            cohort.dx_code,
            cohort.dx_system,
            cohort.dx_display,
            longitudinal.*
from        longitudinal
left join   cohort
       on   longitudinal.encounter_ref = cohort.encounter_ref
;
