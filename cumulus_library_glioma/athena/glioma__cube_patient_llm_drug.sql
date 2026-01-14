CREATE or replace VIEW glioma__cube_patient_llm_drug AS 
    WITH
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(category AS varchar),
                'cumulus__none'
            ) AS category,
            coalesce(
                cast(has_mention AS varchar),
                'cumulus__none'
            ) AS has_mention,
            coalesce(
                cast(phase AS varchar),
                'cumulus__none'
            ) AS phase,
            coalesce(
                cast(route AS varchar),
                'cumulus__none'
            ) AS route,
            coalesce(
                cast(rx_class AS varchar),
                'cumulus__none'
            ) AS rx_class,
            coalesce(
                cast(status AS varchar),
                'cumulus__none'
            ) AS status
        FROM glioma__llm_drug
        
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "category",
            "has_mention",
            "phase",
            "route",
            "rx_class",
            "status",
            concat_ws(
                '-',
                COALESCE("category",''),
                COALESCE("has_mention",''),
                COALESCE("phase",''),
                COALESCE("route",''),
                COALESCE("rx_class",''),
                COALESCE("status",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "category",
            "has_mention",
            "phase",
            "route",
            "rx_class",
            "status"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
            p."category",
            p."has_mention",
            p."phase",
            p."route",
            p."rx_class",
            p."status"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 1
;