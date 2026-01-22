CREATE or replace VIEW glioma__cube_patient_casedef_rx_variable AS 
    WITH
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(peri AS varchar),
                'cumulus__none'
            ) AS peri,
            coalesce(
                cast(post AS varchar),
                'cumulus__none'
            ) AS post,
            coalesce(
                cast(pre AS varchar),
                'cumulus__none'
            ) AS pre,
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
            "peri",
            "post",
            "pre",
            "rx_category_code",
            "rx_code",
            "rx_display",
            "rx_system",
            "valueset",
            concat_ws(
                '-',
                COALESCE("peri",''),
                COALESCE("post",''),
                COALESCE("pre",''),
                COALESCE("rx_category_code",''),
                COALESCE("rx_code",''),
                COALESCE("rx_display",''),
                COALESCE("rx_system",''),
                COALESCE("valueset",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "peri",
            "post",
            "pre",
            "rx_category_code",
            "rx_code",
            "rx_display",
            "rx_system",
            "valueset"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
            p."peri",
            p."post",
            p."pre",
            p."rx_category_code",
            p."rx_code",
            p."rx_display",
            p."rx_system",
            p."valueset"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
;