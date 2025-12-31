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
linked as
(
    select      distinct
                raw.topography_has_mention,
                nullif(trim(raw.topography_code), '')       as topography_code,
                nullif(trim(raw.topography_display), '')    as topography_display,
                raw.morphology_has_mention,
                nullif(trim(raw.morphology_code), '')       as morphology_code,
                nullif(trim(raw.morphology_display), '')    as morphology_display,
                raw.morphology_histology,
                raw.morphology_behavior,
                casedef.display             as topography_display_casdef,
                nci.morphology_display      as morphology_display_nci,
                nci.category_display        as category_display_nci
    from        raw
    left join   glioma__valueset_casedef    as casedef  on raw.topography_code = casedef.code
    left join   glioma__nci_site_histology  as nci      on raw.morphology_code = nci.morphology_code
),
pretty as
(
    select      distinct
                coalesce(
                    linked.topography_display_casdef,
                    concat(linked.topography_display, ' (?)'),
                    concat(cast(linked.topography_code as varchar), ' (#)'),
                    'NONE') as topography_display_best,

                linked.topography_display_casdef,
                linked.topography_display,
                linked.topography_code,
                linked.topography_has_mention,

                coalesce(
                    linked.morphology_display_nci,
                    concat(linked.morphology_display, ' (?)'),
                    concat(cast(linked.morphology_code as varchar), ' (#)'),
                    'NONE') as morphology_display_best,

                linked.morphology_display_nci,
                linked.morphology_display,
                linked.morphology_code,
                linked.morphology_histology,
                linked.morphology_behavior,
                linked.morphology_has_mention,

                coalesce(
                    linked.category_display_nci,
                    nci.category_display,
                    'NONE') as category_display_best,

                linked.category_display_nci,
                nci.category_display as category_display

    from        linked
    left join   glioma__nci_site_histology  as nci    on linked.morphology_histology = nci.histology_code
)
select * from pretty ;