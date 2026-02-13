CREATE TABLE glioma__cube_patient_llm_tx_response_30_days_bin AS (
    WITH
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(progression_bin AS varchar),
                'cumulus__none'
            ) AS progression_bin,
            coalesce(
                cast(symptom_burden_bin AS varchar),
                'cumulus__none'
            ) AS symptom_burden_bin,
            coalesce(
                cast(tx_class AS varchar),
                'cumulus__none'
            ) AS tx_class,
            coalesce(
                cast(tx_modality AS varchar),
                'cumulus__none'
            ) AS tx_modality,
            coalesce(
                cast(tx_specific AS varchar),
                'cumulus__none'
            ) AS tx_specific,
            coalesce(
                cast(visual_status_bin AS varchar),
                'cumulus__none'
            ) AS visual_status_bin
        FROM glioma__llm_tx_response_30_days
        
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "progression_bin",
            "symptom_burden_bin",
            "tx_class",
            "tx_modality",
            "tx_specific",
            "visual_status_bin",
            concat_ws(
                '-',
                COALESCE("progression_bin",''),
                COALESCE("symptom_burden_bin",''),
                COALESCE("tx_class",''),
                COALESCE("tx_modality",''),
                COALESCE("tx_specific",''),
                COALESCE("visual_status_bin",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "progression_bin",
            "symptom_burden_bin",
            "tx_class",
            "tx_modality",
            "tx_specific",
            "visual_status_bin"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
            p."progression_bin",
            p."symptom_burden_bin",
            p."tx_class",
            p."tx_modality",
            p."tx_specific",
            p."visual_status_bin"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
);