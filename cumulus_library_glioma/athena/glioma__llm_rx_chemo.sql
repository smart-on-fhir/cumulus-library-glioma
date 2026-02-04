create or replace view glioma__llm_rx_chemo as
SELECT
    coalesce(chemo.chemotherapy_class, 'NOT_MENTIONED')    as rx_class,
    coalesce(chemo.chemotherapy_regimen, 'NOT_MENTIONED')  as rx_regimen,
    coalesce(chemo.status, 'NOT_MENTIONED')                as rx_status,
    coalesce(chemo.treatment_phase, 'NOT_MENTIONED')       as rx_treatment_phase,
    coalesce(chemo.treatment_response, 'NOT_MENTIONED')    as rx_treatment_response,
    coalesce(chemo.toxicity_severity, 'NOT_MENTIONED')     as rx_toxicity_severity,
    coalesce(chemo.treatment_discontinued, 'NOT_MENTIONED') as rx_treatment_discontinued,
    nlp.note_ref,
    nlp.encounter_ref,
    nlp.subject_ref
FROM glioma__nlp_medications_gpt_oss_120b as nlp
LEFT JOIN UNNEST(
    COALESCE(nlp.result.chemotherapy_mention, ARRAY[])
) AS c(chemo) ON TRUE
;

