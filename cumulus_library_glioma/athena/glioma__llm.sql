create or replace view glioma__llm as
WITH
raw as
(
    select      distinct
                result.grade_mention.has_mention        as grade_has_mention,
                result.grade_mention.code               as grade_code,
                result.grade_mention.display            as grade_display,

                result.topography_mention.has_mention   as topography_has_mention,
                result.topography_mention.code          as topography_code,
                result.topography_mention.display       as topography_display,

                result.morphology_mention.has_mention   as morphology_has_mention,
                result.morphology_mention.code          as morphology_code,
                result.morphology_mention.display       as morphology_display,

                element_at(split(result.morphology_mention.code, '/'), 1) AS morphology_histology,
                element_at(split(result.morphology_mention.code, '/'), 2) AS morphology_behavior,

                result.behavior_mention.has_mention     as behavior_has_mention,
                result.behavior_mention.code            as behavior_code,
                result.behavior_mention.display         as behavior_display,

                note_ref,
                encounter_ref,
                subject_ref
    from        glioma__nlp_gpt_oss_120b
),
clean as
(
    select      distinct
                raw.grade_has_mention,
                nullif(trim(raw.grade_code), '')            as grade_code,
                nullif(trim(raw.grade_display), '')         as grade_display,

                raw.topography_has_mention,
                nullif(trim(raw.topography_code), '')       as topography_code,
                nullif(trim(raw.topography_display), '')    as topography_display,
                
                raw.morphology_has_mention,
                nullif(trim(raw.morphology_code), '')       as morphology_code,
                nullif(trim(raw.morphology_display), '')    as morphology_display,
                
                nullif(trim(raw.morphology_histology), '')  as morphology_histology,
                nullif(trim(raw.morphology_behavior), '')   as morphology_behavior,
                
                raw.behavior_has_mention,                 
                nullif(trim(raw.behavior_code), '')         as behavior_code,
                nullif(trim(raw.behavior_display), '')      as behavior_display,

                nci_grade.display           as grade_display_nci,
                casedef.display             as topography_display_casdef,
                nci.morphology_display      as morphology_display_nci,
                nci_behave.display          as behavior_display_nci,
                nci.category_display        as category_display_nci,

                note_ref,
                encounter_ref,
                subject_ref
    from        raw
    left join   glioma__valueset_casedef    as casedef   on raw.topography_code = casedef.code
    left join   glioma__nci_site_histology  as nci       on raw.morphology_code = nci.morphology_code
    left join   glioma__nci_grade           as nci_grade on raw.grade_code = nci_grade.code
    left join   glioma__nci_behavior        as nci_behave on raw.behavior_code = nci_behave.code
),
best as
(
    select      distinct
                coalesce(
                    clean.grade_display_nci,
                    concat(clean.grade_display, ' (?)'),
                    concat(cast(clean.grade_code as varchar), ' (#)'),
                    'NONE') as grade_display_best,

                clean.grade_display_nci,
                clean.grade_display,
                clean.grade_code,
                clean.grade_has_mention,

                coalesce(
                    clean.topography_display_casdef,
                    concat(clean.topography_display, ' (?)'),
                    concat(cast(clean.topography_code as varchar), ' (#)'),
                    'NONE') as topography_display_best,

                clean.topography_display_casdef,
                clean.topography_display,
                clean.topography_code,
                clean.topography_has_mention,

                coalesce(
                    clean.morphology_display_nci,
                    concat(clean.morphology_display, ' (?)'),
                    concat(cast(clean.morphology_code as varchar), ' (#)'),
                    'NONE') as morphology_display_best,

                clean.morphology_display_nci,
                clean.morphology_display,
                clean.morphology_code,
                clean.morphology_histology,
                clean.morphology_behavior,
                clean.morphology_has_mention,

                coalesce(
                    clean.behavior_display_nci,
                    concat(clean.behavior_display, ' (?)'),
                    concat(cast(clean.behavior_code as varchar), ' (#)'),
                    'NONE') as behavior_display_best,

                clean.behavior_display_nci,
                clean.behavior_display,
                clean.behavior_code,
                clean.behavior_has_mention,

                coalesce(
                    clean.category_display_nci,
                    nci.category_display,
                    'NONE') as category_display_best,

                clean.category_display_nci,
                nci.category_display as category_display,

                note_ref,
                encounter_ref,
                subject_ref
    from        clean
    left join   glioma__nci_site_histology  as nci    on clean.morphology_histology = nci.histology_code
)
select * from best ;