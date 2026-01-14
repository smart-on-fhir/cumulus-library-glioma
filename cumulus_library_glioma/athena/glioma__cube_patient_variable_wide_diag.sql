CREATE or replace VIEW glioma__cube_patient_variable_wide_diag AS 
    WITH
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(diag_brain_mri AS varchar),
                'cumulus__none'
            ) AS diag_brain_mri,
            coalesce(
                cast(diag_head_neck AS varchar),
                'cumulus__none'
            ) AS diag_head_neck,
            coalesce(
                cast(diag_pathology AS varchar),
                'cumulus__none'
            ) AS diag_pathology,
            coalesce(
                cast(diag_radiology AS varchar),
                'cumulus__none'
            ) AS diag_radiology
        FROM glioma__cohort_variable_wide
        
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "diag_brain_mri",
            "diag_head_neck",
            "diag_pathology",
            "diag_radiology",
            concat_ws(
                '-',
                COALESCE("diag_brain_mri",''),
                COALESCE("diag_head_neck",''),
                COALESCE("diag_pathology",''),
                COALESCE("diag_radiology",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "diag_brain_mri",
            "diag_head_neck",
            "diag_pathology",
            "diag_radiology"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
            p."diag_brain_mri",
            p."diag_head_neck",
            p."diag_pathology",
            p."diag_radiology"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
;