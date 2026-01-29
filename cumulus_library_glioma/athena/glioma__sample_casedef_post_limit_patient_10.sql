create or replace view glioma__sample_casedef_post_limit_patient_10 as
WITH
patient_list as (
    select  distinct
            subject_ref
    from    glioma__sample_casedef_post
    limit   10
)
select      distinct
            note.*
from        glioma__sample_casedef_post as note,
            patient_list as P
where       P.subject_ref = note.subject_ref
order by    subject_ref,
            enc_period_ordinal,
            note_ordinal;
