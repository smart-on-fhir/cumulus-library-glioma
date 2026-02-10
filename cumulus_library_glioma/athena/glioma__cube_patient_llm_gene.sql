CREATE TABLE glioma__cube_patient_llm_gene AS (
    WITH
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
                cast(hgnc_name AS varchar),
                'cumulus__none'
            ) AS hgnc_name,
            coalesce(
                cast(idh_mutant AS varchar),
                'cumulus__none'
            ) AS idh_mutant,
            coalesce(
                cast(variant_interpretation AS varchar),
                'cumulus__none'
            ) AS variant_interpretation
        FROM glioma__llm_gene
        
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "braf_altered",
            "braf_fusion",
            "braf_v600e",
            "hgnc_name",
            "idh_mutant",
            "variant_interpretation",
            concat_ws(
                '-',
                COALESCE("braf_altered",''),
                COALESCE("braf_fusion",''),
                COALESCE("braf_v600e",''),
                COALESCE("hgnc_name",''),
                COALESCE("idh_mutant",''),
                COALESCE("variant_interpretation",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "braf_altered",
            "braf_fusion",
            "braf_v600e",
            "hgnc_name",
            "idh_mutant",
            "variant_interpretation"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
            p."braf_altered",
            p."braf_fusion",
            p."braf_v600e",
            p."hgnc_name",
            p."idh_mutant",
            p."variant_interpretation"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
);