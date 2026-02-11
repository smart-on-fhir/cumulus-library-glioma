create TABLE glioma__llm_progression as
with tabular as
(
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
),
positive as
(
    select  subject_ref
    from    tabular
    where   progression in ('BOTH', 'RADIOGRAPHIC', 'FUNCTIONAL')
),
negative as
(
    select  tabular.subject_ref
    from    tabular
    left join
            positive
    on      tabular.subject_ref = positive.subject_ref
    where   positive.subject_ref    IS NULL
    and     tabular.progression in ('NONE', 'NOT_MENTIONED', 'SUSPECTED')
),
stable as
(
    select  age_at_progression,
            progression,
            regrowth_pattern,
            symptom_burden,
            visual_status,
            neurocognitive_risk,
            endocrine_status,
            therapy_line_number,
            therapy_modality,
            clinical_trial_status,
            has_prior_radiotherapy,
            note_ref,
            encounter_ref,
            tabular.subject_ref
    from    tabular,
            negative
    where   tabular.subject_ref = negative.subject_ref
),
both_radiographic as
(
    select  age_at_progression,
            'RADIOGRAPHIC'  as progression,
            regrowth_pattern,
            symptom_burden,
            visual_status,
            neurocognitive_risk,
            endocrine_status,
            therapy_line_number,
            therapy_modality,
            clinical_trial_status,
            has_prior_radiotherapy,
            note_ref,
            encounter_ref,
            subject_ref
    from    tabular
    where   progression in ('BOTH', 'RADIOGRAPHIC')
),
both_functional as
(
    select  age_at_progression,
            'FUNCTIONAL'  as progression,
            regrowth_pattern,
            symptom_burden,
            visual_status,
            neurocognitive_risk,
            endocrine_status,
            therapy_line_number,
            therapy_modality,
            clinical_trial_status,
            has_prior_radiotherapy,
            note_ref,
            encounter_ref,
            subject_ref
    from    tabular
    where   progression in ('BOTH', 'FUNCTIONAL')
),
both_progression as
(
    select  age_at_progression,
            progression,
            regrowth_pattern,
            symptom_burden,
            visual_status,
            neurocognitive_risk,
            endocrine_status,
            therapy_line_number,
            therapy_modality,
            clinical_trial_status,
            has_prior_radiotherapy,
            note_ref,
            encounter_ref,
            subject_ref
    from    tabular
    where   progression = 'BOTH'
),
any_progression as
(
    select * from both_radiographic
    UNION ALL
    select * from both_functional
    UNION ALL
    select * from both_progression
)
select  distinct 'STABLE'       as progression_bin, * from stable
UNION ALL
select  distinct 'PROGRESSION'  as progression_bin, * from any_progression
;