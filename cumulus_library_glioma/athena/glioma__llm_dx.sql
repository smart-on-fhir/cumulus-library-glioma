create TABLE glioma__llm_dx as
select
        coalesce(result.age_at_diagnosis.age_years, -1)             as age_at_dx,
        coalesce(result.grade.code, 'NOT_MENTIONED')                as grade_code,
        coalesce(result.grade.display, 'NOT_MENTIONED')             as grade_display,
        coalesce(result.histology_mention.histology, 'NOT_MENTIONED' ) as histology,
        coalesce(result.behavior.code, 'NOT_MENTIONED')             as behavior_code,
        coalesce(result.behavior.display, 'NOT_MENTIONED')          as behavior_display,
        coalesce(result.tumor_location.location, 'NOT_MENTIONED' )  as tumor_location,
        coalesce(result.tumor_region.region, 'NOT_MENTIONED' )      as tumor_region,
        coalesce(result.tumor_size.mass_effect, 'NOT_MENTIONED')    as tumor_size_mass_effect,
        coalesce(result.tumor_size.size_text, 'NOT_MENTIONED')      as tumor_size_text,
        coalesce(result.nf1_status.nf1_status, 'NOT_MENTIONED')     as nf1_status,
        nlp.note_ref,
        nlp.encounter_ref,
        nlp.subject_ref
from    glioma__nlp_diagnosis_gpt_oss_120b as nlp
where   task_version = 2
;