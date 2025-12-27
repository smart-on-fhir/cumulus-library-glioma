create  table glioma__cohort_dx as
WITH
casedef as
(
    select distinct
            coalesce(dx_code, 'NO_CODE')        as dx_code,
            coalesce(dx_display, 'NO_DISPLAY')  as dx_display,
            dx_system,
            subject_ref,
            encounter_ref
    from    glioma__cohort_casedef
)
select  distinct
        dx.*
from    casedef,
        glioma__cohort_study_population_dx as dx
where   casedef.subject_ref = dx.subject_ref
and     (dx.dx_code, dx.dx_system) not in
        (select distinct code, system from glioma__valueset_casedef)