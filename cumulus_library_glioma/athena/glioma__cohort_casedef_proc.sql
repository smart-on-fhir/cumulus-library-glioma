create  table glioma__cohort_casedef_proc as
select  distinct
        casedef.days_since,
        casedef.ordinal_since,
        casedef.dx_category_code,
        casedef.dx_system,
        casedef.dx_code,
        casedef.dx_display,
        proc.*
from    glioma__cohort_casedef as casedef,
        glioma__cohort_study_population_proc as proc
where   casedef.encounter_ref = proc.encounter_ref
;