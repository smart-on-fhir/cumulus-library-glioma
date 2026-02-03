CREATE TABLE glioma__cube_patient_study_population_rx AS (
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
            ) AS rx_display
        FROM glioma__cohort_study_population_rx
        
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "rx_category_code",
            "rx_code",
            "rx_display",
            concat_ws(
                '-',
                COALESCE("rx_category_code",''),
                COALESCE("rx_code",''),
                COALESCE("rx_display",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "rx_category_code",
            "rx_code",
            "rx_display"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
            p."rx_category_code",
            p."rx_code",
            p."rx_display"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
);