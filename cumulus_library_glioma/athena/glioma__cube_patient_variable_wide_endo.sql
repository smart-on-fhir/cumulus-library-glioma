CREATE or replace VIEW glioma__cube_patient_variable_wide_endo AS 
    WITH
    filtered_table AS (
        SELECT
            s.subject_ref,
            --noqa: disable=RF03, AL02
            s."dx_endo_diabetes",
            s."rx_endo_diabetes",
            s."rx_endo_therapy"
            --noqa: enable=RF03, AL02
        FROM glioma__cohort_variable_wide AS s
    ),
    
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(dx_endo_diabetes AS varchar),
                'cumulus__none'
            ) AS dx_endo_diabetes,
            coalesce(
                cast(rx_endo_diabetes AS varchar),
                'cumulus__none'
            ) AS rx_endo_diabetes,
            coalesce(
                cast(rx_endo_therapy AS varchar),
                'cumulus__none'
            ) AS rx_endo_therapy
        FROM filtered_table
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "dx_endo_diabetes",
            "rx_endo_diabetes",
            "rx_endo_therapy",
            concat_ws(
                '-',
                COALESCE("dx_endo_diabetes",''),
                COALESCE("rx_endo_diabetes",''),
                COALESCE("rx_endo_therapy",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "dx_endo_diabetes",
            "rx_endo_diabetes",
            "rx_endo_therapy"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
        p."dx_endo_diabetes",
        p."rx_endo_diabetes",
        p."rx_endo_therapy"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
;