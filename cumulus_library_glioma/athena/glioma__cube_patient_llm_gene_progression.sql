CREATE TABLE glioma__cube_patient_llm_gene_progression AS (
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
                cast(idh_mutant AS varchar),
                'cumulus__none'
            ) AS idh_mutant,
            coalesce(
                cast(progression AS varchar),
                'cumulus__none'
            ) AS progression,
            coalesce(
                cast(tumor_size_mass_effect AS varchar),
                'cumulus__none'
            ) AS tumor_size_mass_effect,
            coalesce(
                cast(visual_status AS varchar),
                'cumulus__none'
            ) AS visual_status
        FROM glioma__llm_gene_progression
        
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "braf_altered",
            "braf_fusion",
            "braf_v600e",
            "idh_mutant",
            "progression",
            "tumor_size_mass_effect",
            "visual_status",
            concat_ws(
                '-',
                COALESCE("braf_altered",''),
                COALESCE("braf_fusion",''),
                COALESCE("braf_v600e",''),
                COALESCE("idh_mutant",''),
                COALESCE("progression",''),
                COALESCE("tumor_size_mass_effect",''),
                COALESCE("visual_status",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "braf_altered",
            "braf_fusion",
            "braf_v600e",
            "idh_mutant",
            "progression",
            "tumor_size_mass_effect",
            "visual_status"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
            p."braf_altered",
            p."braf_fusion",
            p."braf_v600e",
            p."idh_mutant",
            p."progression",
            p."tumor_size_mass_effect",
            p."visual_status"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
);