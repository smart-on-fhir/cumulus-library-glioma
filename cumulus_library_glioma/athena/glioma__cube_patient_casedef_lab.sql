CREATE or replace VIEW glioma__cube_patient_casedef_lab AS 
    WITH
    filtered_table AS (
        SELECT
            s.subject_ref,
            --noqa: disable=RF03, AL02
            s."enc_class_code",
            s."lab_observation_code",
            s."lab_observation_display",
            s."lab_observation_system"
            --noqa: enable=RF03, AL02
        FROM glioma__cohort_casedef_lab AS s
    ),
    
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(enc_class_code AS varchar),
                'cumulus__none'
            ) AS enc_class_code,
            coalesce(
                cast(lab_observation_code AS varchar),
                'cumulus__none'
            ) AS lab_observation_code,
            coalesce(
                cast(lab_observation_display AS varchar),
                'cumulus__none'
            ) AS lab_observation_display,
            coalesce(
                cast(lab_observation_system AS varchar),
                'cumulus__none'
            ) AS lab_observation_system
        FROM filtered_table
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "enc_class_code",
            "lab_observation_code",
            "lab_observation_display",
            "lab_observation_system",
            concat_ws(
                '-',
                COALESCE("enc_class_code",''),
                COALESCE("lab_observation_code",''),
                COALESCE("lab_observation_display",''),
                COALESCE("lab_observation_system",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "enc_class_code",
            "lab_observation_code",
            "lab_observation_display",
            "lab_observation_system"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
        p."enc_class_code",
        p."lab_observation_code",
        p."lab_observation_display",
        p."lab_observation_system"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
;