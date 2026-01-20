CREATE or replace VIEW glioma__cube_patient_casedef_rx AS 
    WITH
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(age_at_visit AS varchar),
                'cumulus__none'
            ) AS age_at_visit,
            coalesce(
                cast(gender AS varchar),
                'cumulus__none'
            ) AS gender,
            coalesce(
                cast(race_display AS varchar),
                'cumulus__none'
            ) AS race_display,
            coalesce(
                cast(rx_category_code AS varchar),
                'cumulus__none'
            ) AS rx_category_code,
            coalesce(
                cast(rx_code AS varchar),
                'cumulus__none'
            ) AS rx_code,
            coalesce(
                cast(rx_display AS varchar),
                'cumulus__none'
            ) AS rx_display,
            coalesce(
                cast(rx_status AS varchar),
                'cumulus__none'
            ) AS rx_status,
            coalesce(
                cast(rx_system AS varchar),
                'cumulus__none'
            ) AS rx_system
        FROM glioma__cohort_casedef_rx
        
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "age_at_visit",
            "gender",
            "race_display",
            "rx_category_code",
            "rx_code",
            "rx_display",
            "rx_status",
            "rx_system",
            concat_ws(
                '-',
                COALESCE("age_at_visit",''),
                COALESCE("gender",''),
                COALESCE("race_display",''),
                COALESCE("rx_category_code",''),
                COALESCE("rx_code",''),
                COALESCE("rx_display",''),
                COALESCE("rx_status",''),
                COALESCE("rx_system",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "age_at_visit",
            "gender",
            "race_display",
            "rx_category_code",
            "rx_code",
            "rx_display",
            "rx_status",
            "rx_system"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
            p."age_at_visit",
            p."gender",
            p."race_display",
            p."rx_category_code",
            p."rx_code",
            p."rx_display",
            p."rx_status",
            p."rx_system"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
;