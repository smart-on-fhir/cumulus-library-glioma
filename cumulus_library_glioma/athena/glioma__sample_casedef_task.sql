create TABLE glioma__sample_casedef_task as
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
            mention.note_ref
    from    mention,
            glioma__llm_note_type   as enum_note_type,
            glioma__llm_note_task   as enum_doc_task
    where   (mention.doc_type = enum_note_type.code     OR
             mention.doc_type = enum_note_type.display   )
    and     enum_note_type.code = enum_doc_task.code
)
select  task.task,
        task.code,
        sample.*
from    task,
        glioma__sample_casedef_peri_post as sample
where   task.note_ref = sample.note_ref;




