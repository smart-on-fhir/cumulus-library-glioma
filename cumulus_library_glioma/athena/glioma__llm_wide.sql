create or replace VIEW glioma__llm_wide_note AS WITH
note as
(
    select note_ref from glioma__llm_dx
    UNION ALL
    select note_ref from glioma__llm_drug
    UNION ALL
    select note_ref from glioma__llm_surgery
    UNION ALL
    select note_ref from glioma__llm_gene
    UNION ALL
    select note_ref from glioma__llm_variant
),
wide as
(
    select      distinct
                note.note_ref,
                -- Diagnosis
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
                -- Surgery
                surgery.anatomical_site,    -- <LLM String>
                surgery.surgical_type,
                surgery.approach,
                surgery.extent_of_resection,
                surgery.technique_details,   -- <LLM String>
                surgery.complications,       -- <LLM String>
                -- Gene Tests
                gene.braf_altered,
                gene.braf_v600e,
                gene.braf_fusion,
                gene.idh_mutant,
                gene.h3k27m_mutant,
                gene.tp53_altered,
                gene.cdkn2a_deleted,
                -- Gene Variants
                variant.hgnc_name,
                variant.hgvs_variant,
                variant.interpretation
    from        note
    left join   glioma__llm_dx      as dx       on note.note_ref = dx.note_ref
    left join   glioma__llm_surgery as surgery  on note.note_ref = surgery.note_ref
    left join   glioma__llm_gene    as gene     on note.note_ref = gene.note_ref
    left join   glioma__llm_variant as variant  on note.note_ref = variant.note_ref
)
select * from wide;

