CREATE TABLE glioma__sample_casedef_index_post_with_diag as
WITH
encounter_doc as (
    SELECT  distinct
            etl.group_name,
            casedef.subject_ref,
            casedef.encounter_ref,
            case
            when (doc.doc_author_day    is NOT null)    then doc.doc_author_day
            when (doc.doc_date          is NOT null)    then doc.doc_date
            else doc.enc_period_start_day               end as sort_by_date,
            doc.doc_author_day      as note_author_day,
            doc.doc_date            as note_date,
            doc.enc_period_start_day,
            doc.enc_period_ordinal,
            doc.doc_type_system     as note_system,
            doc.doc_type_code       as note_code,
            doc.doc_type_display    as note_display,
            doc.documentreference_ref as note_ref
    FROM
            etl__completion_encounters          as etl,
            glioma__cohort_casedef_index_post   as casedef,
            glioma__cohort_study_population_doc as doc
    WHERE
            casedef.encounter_ref   = doc.encounter_ref
    AND     casedef.encounter_ref   = concat('Encounter/', etl.encounter_id)
    ORDER BY
            casedef.subject_ref
),
encounter_diag as (
    SELECT  distinct
            etl.group_name,
            casedef.subject_ref,
            casedef.encounter_ref,
            case
            when (diag.diag_effectivedatetime_day is NOT null)    then diag.diag_effectivedatetime_day
            when (diag.diag_effectivedatetime_day is NOT null)    then diag.diag_effectivedatetime_day
            else diag.enc_period_start_day                        end as sort_by_date,
            diag.diag_effectivedatetime_day as note_author_day,
            diag.diag_effectivedatetime_day as note_date,
            diag.enc_period_start_day,
            diag.enc_period_ordinal,
            diag.diag_system                as note_system,
            diag.diag_code                  as note_code,
            diag.diag_display               as note_display,
            diag.diagnosticreport_ref       as note_ref
    FROM
            etl__completion_encounters           as etl,
            glioma__cohort_casedef_index_post    as casedef,
            glioma__cohort_study_population_diag as diag
    WHERE
            casedef.encounter_ref   = diag.encounter_ref
    AND     casedef.encounter_ref   = concat('Encounter/', etl.encounter_id)
    ORDER BY
            casedef.subject_ref
),
encounter_note as
(
    select * from encounter_doc
    UNION ALL
    select * from encounter_diag
),
encounter_note_uniq as
(
    SELECT  DISTINCT
            subject_ref,
            note_ref,
            sort_by_date
    FROM    encounter_note
),
ordered as (
    SELECT  distinct
            subject_ref,
            note_ref,
            sort_by_date,
            ROW_NUMBER() OVER (
                PARTITION   BY  subject_ref
                ORDER       BY  sort_by_date,
                                note_ref
            )   AS note_ordinal
    FROM    encounter_note_uniq
)
SELECT  distinct
        encounter_note.*,
        ordered.note_ordinal
FROM
        ordered,
        encounter_note
WHERE
        ordered.note_ref = encounter_note.note_ref
;
