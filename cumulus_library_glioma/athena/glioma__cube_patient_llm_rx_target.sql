CREATE or replace VIEW glioma__cube_patient_llm_rx_target AS 
    WITH
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(rx_class AS varchar),
                'cumulus__none'
            ) AS rx_class,
            coalesce(
                cast(rx_status AS varchar),
                'cumulus__none'
            ) AS rx_status,
            coalesce(
                cast(rx_toxicity_severity AS varchar),
                'cumulus__none'
            ) AS rx_toxicity_severity,
            coalesce(
                cast(rx_treatment_discontinued AS varchar),
                'cumulus__none'
            ) AS rx_treatment_discontinued,
            coalesce(
                cast(rx_treatment_phase AS varchar),
                'cumulus__none'
            ) AS rx_treatment_phase,
            coalesce(
                cast(rx_treatment_response AS varchar),
                'cumulus__none'
            ) AS rx_treatment_response
        FROM glioma__llm_rx_target
        
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "rx_class",
            "rx_status",
            "rx_toxicity_severity",
            "rx_treatment_discontinued",
            "rx_treatment_phase",
            "rx_treatment_response",
            concat_ws(
                '-',
                COALESCE("rx_class",''),
                COALESCE("rx_status",''),
                COALESCE("rx_toxicity_severity",''),
                COALESCE("rx_treatment_discontinued",''),
                COALESCE("rx_treatment_phase",''),
                COALESCE("rx_treatment_response",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "rx_class",
            "rx_status",
            "rx_toxicity_severity",
            "rx_treatment_discontinued",
            "rx_treatment_phase",
            "rx_treatment_response"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
            p."rx_class",
            p."rx_status",
            p."rx_toxicity_severity",
            p."rx_treatment_discontinued",
            p."rx_treatment_phase",
            p."rx_treatment_response"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
;