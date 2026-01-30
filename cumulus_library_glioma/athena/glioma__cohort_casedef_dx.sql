create  table glioma__cohort_casedef_dx as
WITH
casedef as
(
    select  days_since,
            ordinal_since,
            pre,
            peri,
            peri_post,
            post,
            dx_system,
            coalesce(dx_code, 'NO_CODE')        as dx_code,
            coalesce(dx_display, 'NO_DISPLAY')  as dx_display,
            subject_ref,
            encounter_ref
    from    glioma__cohort_casedef
)
select  distinct
        casedef.days_since,
        casedef.ordinal_since,
        casedef.pre,
        casedef.peri,
        casedef.peri_post,
        casedef.post,
        dx.*
from    casedef,
        glioma__cohort_study_population_dx as dx
where   casedef.subject_ref = dx.subject_ref
and     (dx.dx_code, dx.dx_system) not in
        (select distinct code, system from glioma__valueset_casedef)