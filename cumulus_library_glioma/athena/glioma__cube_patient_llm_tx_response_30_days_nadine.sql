CREATE TABLE glioma__cube_patient_llm_tx_response_30_days_nadine AS (
    WITH
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(progression AS varchar),
                'cumulus__none'
            ) AS progression,
            coalesce(
                cast(progression_bin AS varchar),
                'cumulus__none'
            ) AS progression_bin,
            coalesce(
                cast(regrowth_pattern AS varchar),
                'cumulus__none'
            ) AS regrowth_pattern,
            coalesce(
                cast(symptom_burden AS varchar),
                'cumulus__none'
            ) AS symptom_burden,
            coalesce(
                cast(tx_class AS varchar),
                'cumulus__none'
            ) AS tx_class,
            coalesce(
                cast(tx_modality AS varchar),
                'cumulus__none'
            ) AS tx_modality,
            coalesce(
                cast(visual_status AS varchar),
                'cumulus__none'
            ) AS visual_status
        FROM glioma__llm_tx_response_30_days_nadine
        
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "progression",
            "progression_bin",
            "regrowth_pattern",
            "symptom_burden",
            "tx_class",
            "tx_modality",
            "visual_status",
            concat_ws(
                '-',
                COALESCE("progression",''),
                COALESCE("progression_bin",''),
                COALESCE("regrowth_pattern",''),
                COALESCE("symptom_burden",''),
                COALESCE("tx_class",''),
                COALESCE("tx_modality",''),
                COALESCE("visual_status",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "progression",
            "progression_bin",
            "regrowth_pattern",
            "symptom_burden",
            "tx_class",
            "tx_modality",
            "visual_status"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
            p."progression",
            p."progression_bin",
            p."regrowth_pattern",
            p."symptom_burden",
            p."tx_class",
            p."tx_modality",
            p."visual_status"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
);