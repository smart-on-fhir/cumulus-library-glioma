create or replace view glioma__sample_casedef_task as
WITH
mention as (
    select  distinct
            src_result_mention.doc_type,
            src.note_ref,
            src.encounter_ref,
            src.subject_ref
    from    glioma__nlp_gpt_oss_120b    AS src,
            UNNEST(src.result.doc_type) AS t1(src_result_mention)
    where   task_version = 2000
    and     src_result_mention IS NOT NULL
),
task as (
    select  distinct
            enum_doc_task.task,
            enum_doc_task.code,
            mention.note_ref,
            mention.subject_ref,
            mention.encounter_ref
    from    mention,
            glioma__llm_document_type       as enum_doc_type,
            glioma__llm_document_type_task  as enum_doc_task
    where   (mention.doc_type = enum_doc_type.code or
             mention.doc_type = enum_doc_type.display)
    and     enum_doc_type.code = enum_doc_task.code
)
select * from task;

--    task_doc as
--    (
--        select  task.*,
--                doc.type_system,
--                doc.type_code,
--                doc.type_display
--        from    task, glioma__cohort_study_population_diag as doc
--        where task.note_ref = doc.documentreference_ref
--    )
--    select * from task_doc limit 50



