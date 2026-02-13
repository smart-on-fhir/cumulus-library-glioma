create or replace view glioma__llm_surgery as
select      distinct
            coalesce(result.surgical_type_mention.surgical_type,
                    'NOT_MENTIONED') as surgical_type,
            coalesce(result.approach_mention.approach,
                    'NOT_MENTIONED') as approach,
            coalesce(result.extent_of_resection_mention.extent_of_resection,
                    'NOT_MENTIONED') as extent_of_resection,
            nlp.note_ref,
            nlp.encounter_ref,
            nlp.subject_ref
from        glioma__nlp_surgical_gpt_oss_120b as nlp
where       task_version = 1
;