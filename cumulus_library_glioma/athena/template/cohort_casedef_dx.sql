create  table $prefix__cohort_casedef_dx as
WITH
casedef as
(
    select distinct
            days_since,
            ordinal_since,
            dx_system,
            coalesce(dx_code, 'NO_CODE')        as dx_code,
            coalesce(dx_display, 'NO_DISPLAY')  as dx_display,
            subject_ref,
            encounter_ref
    from    $prefix__cohort_casedef
)
select  distinct
        casedef.days_since,
        casedef.ordinal_since,
        dx.*
from    casedef,
        $prefix__cohort_study_population_dx as dx
where   casedef.subject_ref = dx.subject_ref
and     (dx.dx_code, dx.dx_system) not in
        (select distinct code, system from $prefix__valueset_casedef)