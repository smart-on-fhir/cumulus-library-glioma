create or replace view glioma__llm_surgery as
select      distinct
            coalesce(surgery.has_mention, False)                as has_mention,
            coalesce(surgery.anatomical_site, 'NOT_MENTIONED')  as anatomical_site,
            coalesce(surgery.surgical_type, 'NOT_MENTIONED')    as surgical_type,
            coalesce(surgery.approach, 'NOT_MENTIONED')         as approach,
            coalesce(surgery.extent_of_resection, 'NOT_MENTIONED')  as extent_of_resection,
            coalesce(surgery.technique_details, 'NOT_MENTIONED')    as technique_details,
            coalesce(surgery.complications, 'NOT_MENTIONED')        as complications,
            nlp.note_ref,
            nlp.encounter_ref,
            nlp.subject_ref
from        glioma__nlp_gpt_oss_120b as nlp
LEFT JOIN   UNNEST(nlp.result.surgery_mention) AS t(surgery)
ON TRUE;
