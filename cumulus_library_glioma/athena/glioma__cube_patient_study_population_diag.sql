CREATE or replace VIEW glioma__cube_patient_study_population_diag AS 
    WITH
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(diag_category_display_best AS varchar),
                'cumulus__none'
            ) AS diag_category_display_best,
            coalesce(
                cast(diag_category_system AS varchar),
                'cumulus__none'
            ) AS diag_category_system,
            coalesce(
                cast(enc_class_code AS varchar),
                'cumulus__none'
            ) AS enc_class_code,
            coalesce(
                cast(enc_servicetype_display AS varchar),
                'cumulus__none'
            ) AS enc_servicetype_display,
            coalesce(
                cast(enc_type_display AS varchar),
                'cumulus__none'
            ) AS enc_type_display
        FROM glioma__cohort_study_population_diag
        
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "diag_category_display_best",
            "diag_category_system",
            "enc_class_code",
            "enc_servicetype_display",
            "enc_type_display",
            concat_ws(
                '-',
                COALESCE("diag_category_display_best",''),
                COALESCE("diag_category_system",''),
                COALESCE("enc_class_code",''),
                COALESCE("enc_servicetype_display",''),
                COALESCE("enc_type_display",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "diag_category_display_best",
            "diag_category_system",
            "enc_class_code",
            "enc_servicetype_display",
            "enc_type_display"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
            p."diag_category_display_best",
            p."diag_category_system",
            p."enc_class_code",
            p."enc_servicetype_display",
            p."enc_type_display"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
;