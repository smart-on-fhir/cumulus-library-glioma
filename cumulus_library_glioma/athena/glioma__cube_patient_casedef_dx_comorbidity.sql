CREATE or replace VIEW glioma__cube_patient_casedef_dx_comorbidity AS 
    WITH
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(dx_category_code AS varchar),
                'cumulus__none'
            ) AS dx_category_code,
            coalesce(
                cast(dx_code AS varchar),
                'cumulus__none'
            ) AS dx_code,
            coalesce(
                cast(dx_display AS varchar),
                'cumulus__none'
            ) AS dx_display
        FROM glioma__cohort_casedef_dx
        
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "dx_category_code",
            "dx_code",
            "dx_display",
            concat_ws(
                '-',
                COALESCE("dx_category_code",''),
                COALESCE("dx_code",''),
                COALESCE("dx_display",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "dx_category_code",
            "dx_code",
            "dx_display"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
            p."dx_category_code",
            p."dx_code",
            p."dx_display"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
;