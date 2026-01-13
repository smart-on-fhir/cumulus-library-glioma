CREATE or replace VIEW glioma__cube_patient_llm_variant AS 
    WITH
    filtered_table AS (
        SELECT
            s.subject_ref,
            --noqa: disable=RF03, AL02
            s."has_mention",
            s."hgnc_name",
            s."hgvs_variant",
            s."interpretation"
            --noqa: enable=RF03, AL02
        FROM glioma__llm_variant AS s
    ),
    
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(has_mention AS varchar),
                'cumulus__none'
            ) AS has_mention,
            coalesce(
                cast(hgnc_name AS varchar),
                'cumulus__none'
            ) AS hgnc_name,
            coalesce(
                cast(hgvs_variant AS varchar),
                'cumulus__none'
            ) AS hgvs_variant,
            coalesce(
                cast(interpretation AS varchar),
                'cumulus__none'
            ) AS interpretation
        FROM filtered_table
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "has_mention",
            "hgnc_name",
            "hgvs_variant",
            "interpretation",
            concat_ws(
                '-',
                COALESCE("has_mention",''),
                COALESCE("hgnc_name",''),
                COALESCE("hgvs_variant",''),
                COALESCE("interpretation",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "has_mention",
            "hgnc_name",
            "hgvs_variant",
            "interpretation"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
        p."has_mention",
        p."hgnc_name",
        p."hgvs_variant",
        p."interpretation"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 1
;