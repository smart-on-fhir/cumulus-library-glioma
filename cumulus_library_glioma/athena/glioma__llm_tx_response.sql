create TABLE glioma__llm_tx_response as
with
progression as
(
    select  casedef.days_since,
            casedef.enc_period_start_day,
            llm.*
    from    glioma__llm_progression     as llm,
            glioma__cohort_casedef      as casedef
    where   llm.encounter_ref = casedef.encounter_ref
)
select  distinct
        tx_modality,
        tx_class_source,
        tx_class,
        tx_specific,
        (progression.days_since -
        tx.days_since)                      as response_days_since_tx,
        tx.enc_period_start_day             as treatment_date,
        progression.enc_period_start_day    as response_date,
        progression.progression,
        progression.progression_bin,
        progression.regrowth_pattern,
        progression.symptom_burden,
        progression.visual_status,
        progression.neurocognitive_risk,
        progression.has_prior_radiotherapy,
        tx.subject_ref,
        tx.encounter_ref as tx_encounter_ref,
        progression.encounter_ref
from    progression,
        glioma__llm_tx   as tx
where   progression.progression != 'NOT_MENTIONED'
and     tx.subject_ref = progression.subject_ref
and     tx.tx_modality = progression.therapy_modality
and     tx.enc_period_start_day < progression.enc_period_start_day
;



