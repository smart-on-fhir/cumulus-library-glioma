CREATE table glioma__sample_casedef_post as
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
            doc.documentreference_ref,
            doc.doc_author_day,
            doc.doc_date,
            doc.enc_period_start_day,
            doc.enc_period_ordinal,
            doc.doc_type_code,
            doc.doc_type_display,
            doc.doc_type_system
    FROM
            etl__completion_encounters          as etl,
            glioma__cohort_casedef_post         as casedef,
            glioma__cohort_study_population_doc as doc
    WHERE
            casedef.encounter_ref   = doc.encounter_ref
    AND     casedef.encounter_ref   = concat('Encounter/', etl.encounter_id)
    ORDER BY
            casedef.subject_ref
),
encounter_doc_uniq as
(
    SELECT  DISTINCT
            subject_ref,
            documentreference_ref,
            sort_by_date
    FROM    encounter_doc
),
ordered as (
    SELECT  distinct
            subject_ref,
            documentreference_ref,
            sort_by_date,
            ROW_NUMBER() OVER (
                PARTITION   BY  subject_ref
                ORDER       BY  sort_by_date,
                                documentreference_ref
            )   AS doc_ordinal
    FROM    encounter_doc_uniq
)
SELECT  distinct
        encounter_doc.*,
        ordered.doc_ordinal
FROM
        ordered,
        encounter_doc
WHERE
        ordered.documentreference_ref = encounter_doc.documentreference_ref
;