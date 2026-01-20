create  table $prefix__cohort_casedef_lab as
select  distinct
        casedef.days_since,
        casedef.ordinal_since,
        casedef.dx_category_code,
        casedef.dx_system,
        casedef.dx_code,
        casedef.dx_display,
        lab.*
from    $prefix__cohort_casedef as casedef,
        $prefix__cohort_study_population_lab as lab
where   casedef.encounter_ref = lab.encounter_ref
;