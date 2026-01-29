create or replace view glioma__sample_casedef_post_limit_note_50 as
select  distinct
        subject_ref, note_ordinal, days_since, note_ref, group_name
from
        glioma__sample_casedef_post
where
        note_ordinal <= 50
order by
        subject_ref, note_ordinal;