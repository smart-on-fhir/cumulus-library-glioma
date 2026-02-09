CREATE TABLE glioma__cube_patient_llm_tx AS (
    WITH
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(source AS varchar),
                'cumulus__none'
            ) AS source,
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
            ) AS tx_specific
        FROM glioma__llm_tx
        
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "source",
            "tx_class",
            "tx_modality",
            "tx_specific",
            concat_ws(
                '-',
                COALESCE("source",''),
                COALESCE("tx_class",''),
                COALESCE("tx_modality",''),
                COALESCE("tx_specific",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "source",
            "tx_class",
            "tx_modality",
            "tx_specific"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
            p."source",
            p."tx_class",
            p."tx_modality",
            p."tx_specific"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
);