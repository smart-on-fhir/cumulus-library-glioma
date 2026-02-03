CREATE TABLE glioma__cube_patient_casedef_rx_variable AS (
    WITH
    null_replacement AS (
        SELECT
            subject_ref,
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
                cast(rx_system AS varchar),
                'cumulus__none'
            ) AS rx_system,
            coalesce(
                cast(valueset AS varchar),
                'cumulus__none'
            ) AS valueset
        FROM glioma__cohort_casedef_rx_variable
        
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "rx_category_code",
            "rx_code",
            "rx_display",
            "rx_system",
            "valueset",
            concat_ws(
                '-',
                COALESCE("rx_category_code",''),
                COALESCE("rx_code",''),
                COALESCE("rx_display",''),
                COALESCE("rx_system",''),
                COALESCE("valueset",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "rx_category_code",
            "rx_code",
            "rx_display",
            "rx_system",
            "valueset"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
            p."rx_category_code",
            p."rx_code",
            p."rx_display",
            p."rx_system",
            p."valueset"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
);