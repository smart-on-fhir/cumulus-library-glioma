CREATE or replace VIEW glioma__cube_patient_llm_gene AS 
    WITH
    filtered_table AS (
        SELECT
            s.subject_ref,
            --noqa: disable=RF03, AL02
            s."braf_altered",
            s."braf_fusion",
            s."braf_v600e",
            s."cdkn2a_deleted",
            s."h3k27m_mutant",
            s."has_mention",
            s."idh_mutant",
            s."tp53_altered"
            --noqa: enable=RF03, AL02
        FROM glioma__llm_gene AS s
    ),
    
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(braf_altered AS varchar),
                'cumulus__none'
            ) AS braf_altered,
            coalesce(
                cast(braf_fusion AS varchar),
                'cumulus__none'
            ) AS braf_fusion,
            coalesce(
                cast(braf_v600e AS varchar),
                'cumulus__none'
            ) AS braf_v600e,
            coalesce(
                cast(cdkn2a_deleted AS varchar),
                'cumulus__none'
            ) AS cdkn2a_deleted,
            coalesce(
                cast(h3k27m_mutant AS varchar),
                'cumulus__none'
            ) AS h3k27m_mutant,
            coalesce(
                cast(has_mention AS varchar),
                'cumulus__none'
            ) AS has_mention,
            coalesce(
                cast(idh_mutant AS varchar),
                'cumulus__none'
            ) AS idh_mutant,
            coalesce(
                cast(tp53_altered AS varchar),
                'cumulus__none'
            ) AS tp53_altered
        FROM filtered_table
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "braf_altered",
            "braf_fusion",
            "braf_v600e",
            "cdkn2a_deleted",
            "h3k27m_mutant",
            "has_mention",
            "idh_mutant",
            "tp53_altered",
            concat_ws(
                '-',
                COALESCE("braf_altered",''),
                COALESCE("braf_fusion",''),
                COALESCE("braf_v600e",''),
                COALESCE("cdkn2a_deleted",''),
                COALESCE("h3k27m_mutant",''),
                COALESCE("has_mention",''),
                COALESCE("idh_mutant",''),
                COALESCE("tp53_altered",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "braf_altered",
            "braf_fusion",
            "braf_v600e",
            "cdkn2a_deleted",
            "h3k27m_mutant",
            "has_mention",
            "idh_mutant",
            "tp53_altered"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
        p."braf_altered",
        p."braf_fusion",
        p."braf_v600e",
        p."cdkn2a_deleted",
        p."h3k27m_mutant",
        p."has_mention",
        p."idh_mutant",
        p."tp53_altered"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 1
;