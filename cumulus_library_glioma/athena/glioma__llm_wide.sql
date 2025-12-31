WITH
visit as 
(
    select distinct encounter_ref from glioma__llm
    UNION
    select distinct encounter_ref from glioma__llm_drug
    UNION
    select distinct encounter_ref from glioma__llm_surgery
    UNION
    select distinct encounter_ref from glioma__llm_gene
    UNION
    select distinct encounter_ref from glioma__llm_variant
),
join_dx as
(
    select      distinct
                dx.grade_code,
                dx.grade_display_best,
                dx.topography_code,
                dx.topography_display_best,
                dx.morphology_code,
                dx.morphology_display_best,
                dx.behavior_code,
                dx.behavior_display_best,
                dx.category_display,
                dx.category_display_best,
                visit.encounter_ref
    from        visit
    left join   glioma__llm as dx on visit.encounter_ref = dx.encounter_ref
),
join_surgery as
(
    select      distinct
                join_dx.*,
                surgery.anatomical_site,    -- <String>
                surgery.surgical_type,
                surgery.approach,
                surgery.extent_of_resection,
                surgery.technique_details,  -- <String>
                surgery.complications       -- <String>
    from        join_dx
    left join   glioma__llm_surgery as surgery on join_dx.encounter_ref = surgery.encounter_ref
),
join_molecular as (
    select      distinct
                join_surgery.*,
                gene.braf_altered,
                gene.braf_v600e,
                gene.braf_fusion,
                gene.idh_mutant,
                gene.h3k27m_mutant,
                gene.tp53_altered,
                gene.cdkn2a_deleted,
                variant.hgnc_name,
                variant.hgvs_variant,
                variant.interpretation
    from        join_surgery
    left join   glioma__llm_gene    as gene     on join_surgery.encounter_ref = gene.encounter_ref
    left join   glioma__llm_variant as variant  on join_surgery.encounter_ref = variant.encounter_ref
)

select * from join_molecular limit 50
