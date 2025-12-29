create or replace view glioma__llm as
select      distinct
            result.topography_mention.has_mention   as topography_has_mention,
            result.topography_mention.code          as topography_code,
            result.topography_mention.display       as topography_display,
            result.morphology_mention.has_mention   as morphology_has_mention,
            result.morphology_mention.code          as morphology_code,
            result.morphology_mention.display       as morphology_display,
            result.behavior_mention.has_mention     as behavior_has_mention,
            result.behavior_mention.code            as behavior_code,
            result.behavior_mention.display         as behavior_display,
            result.grade_mention.has_mention        as grade_has_mention,
            result.grade_mention.code               as grade_code,
            result.grade_mention.display            as grade_display,
            note_ref,
            encounter_ref,
            subject_ref
from        glioma__nlp_gpt_oss_120b;
