create  table glioma__cohort_casedef_lab as
select  distinct
        casedef.days_since,
        casedef.ordinal_since,
        casedef.dx_category_code,
        casedef.dx_system,
        casedef.dx_code,
        casedef.dx_display,
        lab.*
from    glioma__cohort_casedef as casedef,
        glioma__cohort_study_population_lab as lab
where   casedef.encounter_ref = lab.encounter_ref
;