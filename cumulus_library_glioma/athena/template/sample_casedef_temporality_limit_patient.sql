create or replace view $prefix__sample_casedef_$temporality_limit_patient_$limit as
WITH
patient_list as (
    select  distinct
            subject_ref
    from    $prefix__sample_casedef_$temporality
    limit   $limit
)
select      distinct
            note.*
from        $prefix__sample_casedef_$temporality as note,
            patient_list as P
where       P.subject_ref = note.subject_ref
order by    subject_ref,
            enc_period_ordinal,
            note_ordinal;
