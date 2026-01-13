create  table glioma__cohort_proc as
select  distinct
        proc.*
from    glioma__cohort_casedef as casedef,
        glioma__cohort_study_population_proc as proc
where   casedef.subject_ref = proc.subject_ref
;