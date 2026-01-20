create  table $prefix__cohort_casedef_proc as
select  distinct
        casedef.days_since,
        casedef.ordinal_since,
        casedef.dx_category_code,
        casedef.dx_system,
        casedef.dx_code,
        casedef.dx_display,
        proc.*
from    $prefix__cohort_casedef as casedef,
        $prefix__cohort_study_population_proc as proc
where   casedef.encounter_ref = proc.encounter_ref
;