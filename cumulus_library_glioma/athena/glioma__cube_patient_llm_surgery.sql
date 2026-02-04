CREATE TABLE glioma__cube_patient_llm_surgery AS (
    WITH
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(approach AS varchar),
                'cumulus__none'
            ) AS approach,
            coalesce(
                cast(extent_of_resection AS varchar),
                'cumulus__none'
            ) AS extent_of_resection,
            coalesce(
                cast(surgical_type AS varchar),
                'cumulus__none'
            ) AS surgical_type
        FROM glioma__llm_surgery
        
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "approach",
            "extent_of_resection",
            "surgical_type",
            concat_ws(
                '-',
                COALESCE("approach",''),
                COALESCE("extent_of_resection",''),
                COALESCE("surgical_type",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "approach",
            "extent_of_resection",
            "surgical_type"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
            p."approach",
            p."extent_of_resection",
            p."surgical_type"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
);