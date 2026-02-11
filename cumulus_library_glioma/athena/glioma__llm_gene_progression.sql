create TABLE glioma__llm_gene_progression as
with
patient_list as
(
    select subject_ref, encounter_ref, note_ref from glioma__llm_gene
    UNION ALL
    select subject_ref, encounter_ref, note_ref from glioma__llm_progression
),
left_join as
(
    select      driver_mention,
                braf_altered,
                braf_v600e,
                braf_fusion,
                idh_mutant,
                h3k27m_mutant,
                tp53_altered,
                cdkn2a_deleted,
                variant_mention,
                variant_interpretation,
                hgnc_name,
                hgvs_variant,
                progression.progression,
                progression.progression_bin,
                progression.regrowth_pattern,
                progression.symptom_burden,
                progression.visual_status,
                progression.neurocognitive_risk,
                progression.has_prior_radiotherapy,
                progression.subject_ref
    from        patient_list
    left join   glioma__llm_gene    as gene
            on  patient_list.note_ref = gene.note_ref
    left join   glioma__llm_progression as progression
            on  patient_list.note_ref = progression.note_ref
)
select distinct * from left_join
;
