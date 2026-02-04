create or replace view glioma__llm_rx_target as
SELECT
    coalesce(target.targeted_therapy, 'NOT_MENTIONED')         as rx_class,
    coalesce(target.status, 'NOT_MENTIONED')                   as rx_status,
    coalesce(target.treatment_phase, 'NOT_MENTIONED')          as rx_treatment_phase,
    coalesce(target.treatment_response, 'NOT_MENTIONED')       as rx_treatment_response,
    coalesce(target.toxicity_severity, 'NOT_MENTIONED')        as rx_toxicity_severity,
    coalesce(target.treatment_discontinued, 'NOT_MENTIONED')   as rx_treatment_discontinued,
    nlp.note_ref,
    nlp.encounter_ref,
    nlp.subject_ref
FROM glioma__nlp_medications_gpt_oss_120b as nlp
LEFT JOIN UNNEST(
    COALESCE(nlp.result.targeted_therapy_mention, ARRAY[])
) AS t(target) ON TRUE
;