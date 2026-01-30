create  table glioma__cohort_casedef_rx as
select  distinct
        casedef.days_since,
        casedef.ordinal_since,
        casedef.pre,
        casedef.peri,
        casedef.peri_post,
        casedef.post,
        casedef.dx_category_code,
        casedef.dx_system,
        casedef.dx_code,
        casedef.dx_display,
        rx.*
from    glioma__cohort_casedef as casedef,
        glioma__cohort_study_population_rx as rx
where   casedef.encounter_ref = rx.encounter_ref
;