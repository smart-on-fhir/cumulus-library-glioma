create or replace view glioma__llm_progression as
select
        coalesce(progress.age_at_progression.age_years, -1 )                    as age_at_progression,
        coalesce(progress.progression_type.progression, 'NOT_MENTIONED' )       as progression,
        coalesce(progress.regrowth_pattern.regrowth_pattern, 'NOT_MENTIONED' )  as regrowth_pattern,
        coalesce(sb, 'NOT_MENTIONED') as symptom_burden,
        coalesce(progress.visual_status.visual_status, 'NOT_MENTIONED')         as visual_status,
        coalesce(progress.neurocognitive_risk.risk, 'NOT_MENTIONED')            as neurocognitive_risk,
        coalesce(progress.endocrine_function.endocrine_status, 'NOT_MENTIONED') as endocrine_status,
        coalesce(progress.therapy_line.line_number, 'NOT_MENTIONED')            as therapy_line_number,
        coalesce(progress.therapy_modality.therapy_modality, 'NOT_MENTIONED')   as therapy_modality,
        coalesce(progress.clinical_trial.trial_status, 'NOT_MENTIONED')         as clinical_trial_status,
        coalesce(progress.radiotherapy_exposure_history.has_prior_radiotherapy, 'NOT_MENTIONED') as has_prior_radiotherapy,
        nlp.note_ref,
        nlp.encounter_ref,
        nlp.subject_ref
from        glioma__nlp_progression_gpt_oss_120b as nlp
LEFT JOIN   UNNEST(nlp.result.glioma_progression_mention)   AS t(progress) ON TRUE
LEFT JOIN UNNEST(progress.symptom_burden.symptom_burden)    AS u(sb)   ON TRUE
;