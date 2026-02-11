create TABLE glioma__llm_progression as
with unpack as
(
    select
            progress.age_at_progression.age_years,
            progress.progression_type.progression,
            progress.regrowth_pattern.regrowth_pattern,
            sb as symptom_burden,
            progress.visual_status.visual_status,
            progress.neurocognitive_risk.risk,
            progress.endocrine_function.endocrine_status,
            progress.therapy_line.line_number,
            progress.therapy_modality.therapy_modality,
            progress.clinical_trial.trial_status,
            progress.radiotherapy_exposure_history.has_prior_radiotherapy,
            nlp.note_ref,
            nlp.encounter_ref,
            nlp.subject_ref
    from    glioma__nlp_progression_gpt_oss_120b as nlp
    LEFT
    JOIN    UNNEST(nlp.result.glioma_progression_mention)  AS t(progress) ON TRUE
    LEFT
    JOIN    UNNEST(progress.symptom_burden.symptom_burden) AS u(sb)       ON TRUE
),
tabular as
(
    select
            coalesce(progression, 'NOT_MENTIONED' )         as progression,
            coalesce(age_years, -1 )                        as age_at_progression,
            coalesce(regrowth_pattern, 'NOT_MENTIONED')     as regrowth_pattern,
            coalesce(symptom_burden, 'NOT_MENTIONED')       as symptom_burden,
            coalesce(visual_status, 'NOT_MENTIONED')        as visual_status,
            coalesce(risk, 'NOT_MENTIONED')                 as neurocognitive_risk,
            coalesce(endocrine_status, 'NOT_MENTIONED')     as endocrine_status,
            coalesce(line_number, 'NOT_MENTIONED')          as therapy_line_number,
            coalesce(therapy_modality, 'NOT_MENTIONED')     as therapy_modality,
            coalesce(trial_status, 'NOT_MENTIONED')         as clinical_trial_status,
            coalesce(has_prior_radiotherapy, 'NOT_MENTIONED') as has_prior_radiotherapy,
            note_ref,
            encounter_ref,
            subject_ref
    from    unpack
),
-- positive for disease progression =
-- radiographic, functional, or both
pos_prog as
(
    select  subject_ref
    from    tabular
    where   progression in ('BOTH', 'RADIOGRAPHIC', 'FUNCTIONAL')
),
-- negative for disease progression
-- "no confirmed evidence of disease progression"
neg_prog as
(
    select      tabular.subject_ref
    from        tabular
    left join   pos_prog
    on          tabular.subject_ref = pos_prog.subject_ref
    where       pos_prog.subject_ref    IS NULL
    and         tabular.progression in ('NONE', 'NOT_MENTIONED', 'SUSPECTED')
),
stable as
(
    select  progression,
            age_at_progression,
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
            neg_prog
    where   tabular.subject_ref = neg_prog.subject_ref
),
both_radiographic as
(
    select  'RADIOGRAPHIC'  as progression,
            age_at_progression,
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
    select  'FUNCTIONAL'  as progression,
            age_at_progression,
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
    select  progression,
            age_at_progression,
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
discrete_progression as
(
    select  'STABLE'       as progression_bin, *
    from    stable
    UNION ALL
    select  'PROGRESSION'  as progression_bin, *
    from    both_radiographic
    UNION ALL
    select  'PROGRESSION'  as progression_bin, *
    from    both_functional
    UNION ALL
    select  'PROGRESSION'  as progression_bin, *
    from    both_progression
),
discrete_visual_status as
(
    select  'IMPROVING' as visual_status_bin, *
    from    discrete_progression
    where   visual_status
    in      ('STABLE', 'IMPROVING')
    UNION ALL
    select  'DECLINING'  as visual_status_bin, *
    from    discrete_progression
    where   visual_status
    in      ('SEVERE_LOSS', 'DECLINING')
),
pos_symptom as
(
    select  'PRESENT'  as symptom_burden_bin, *
    from    discrete_visual_status
    where   symptom_burden      !='NOT_MENTIONED'
    or      visual_status_bin    ='DECLINING'
),
neg_symptom as
(
    select  'NONE'  as symptom_burden_bin, sx.*
    from    discrete_visual_status as sx
    left
    join    pos_symptom
    on      pos_symptom.subject_ref = sx.subject_ref
    where   pos_symptom.subject_ref IS NULL
    and     sx.symptom_burden = 'NOT_MENTIONED'
),
discrete_symptom_burden as
(
    select * from pos_symptom
    UNION ALL
    select * from neg_symptom
)
select distinct * from discrete_symptom_burden
;