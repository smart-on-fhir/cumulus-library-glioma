CREATE or replace VIEW glioma__cube_patient_llm_surgery AS 
    WITH
    filtered_table AS (
        SELECT
            s.subject_ref,
            --noqa: disable=RF03, AL02
            s."anatomical_site",
            s."approach",
            s."complications",
            s."extent_of_resection",
            s."has_mention",
            s."surgical_type",
            s."technique_details"
            --noqa: enable=RF03, AL02
        FROM glioma__llm_surgery AS s
    ),
    
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(anatomical_site AS varchar),
                'cumulus__none'
            ) AS anatomical_site,
            coalesce(
                cast(approach AS varchar),
                'cumulus__none'
            ) AS approach,
            coalesce(
                cast(complications AS varchar),
                'cumulus__none'
            ) AS complications,
            coalesce(
                cast(extent_of_resection AS varchar),
                'cumulus__none'
            ) AS extent_of_resection,
            coalesce(
                cast(has_mention AS varchar),
                'cumulus__none'
            ) AS has_mention,
            coalesce(
                cast(surgical_type AS varchar),
                'cumulus__none'
            ) AS surgical_type,
            coalesce(
                cast(technique_details AS varchar),
                'cumulus__none'
            ) AS technique_details
        FROM filtered_table
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "anatomical_site",
            "approach",
            "complications",
            "extent_of_resection",
            "has_mention",
            "surgical_type",
            "technique_details",
            concat_ws(
                '-',
                COALESCE("anatomical_site",''),
                COALESCE("approach",''),
                COALESCE("complications",''),
                COALESCE("extent_of_resection",''),
                COALESCE("has_mention",''),
                COALESCE("surgical_type",''),
                COALESCE("technique_details",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "anatomical_site",
            "approach",
            "complications",
            "extent_of_resection",
            "has_mention",
            "surgical_type",
            "technique_details"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
        p."anatomical_site",
        p."approach",
        p."complications",
        p."extent_of_resection",
        p."has_mention",
        p."surgical_type",
        p."technique_details"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 1
;