create TABLE glioma__cohort_casedef_dx as
WITH casedef AS (
    SELECT
        days_since,
        ordinal_since,
--        pre,
--        peri,
--        peri_post,
--        post,
        subject_ref
    FROM
        glioma__cohort_casedef
)
SELECT  distinct
        casedef.days_since,
        casedef.ordinal_since,
--        casedef.pre,
--        casedef.peri,
--        casedef.peri_post,
--        casedef.post,
        dx.dx_category_code,
        dx.dx_system,
        dx.dx_code,
        dx.dx_display,
        dx.status,
--        dx.age_at_visit,
--        dx.gender,
--        dx.enc_period_ordinal,
        dx.subject_ref,
        dx.encounter_ref,
        dx.condition_ref
FROM casedef
JOIN glioma__cohort_study_population_dx as dx
  ON casedef.subject_ref = dx.subject_ref
LEFT JOIN glioma__valueset_casedef as valueset
  ON valueset.system = dx.dx_system
 AND valueset.code   = dx.dx_code
WHERE valueset.code IS NULL;
