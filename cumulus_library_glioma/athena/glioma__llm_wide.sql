create TABLE glioma__llm_wide_note AS WITH
patient_list as
(
    select  subject_ref, encounter_ref, note_ref from glioma__llm_dx
    UNION ALL
    select  subject_ref, encounter_ref, note_ref from glioma__llm_rx_chemo
    UNION ALL
    select  subject_ref, encounter_ref, note_ref from glioma__llm_rx_target
    UNION ALL
    select  subject_ref, encounter_ref, note_ref from glioma__llm_surgery
    UNION ALL
    select  subject_ref, encounter_ref, note_ref from glioma__llm_gene
),
wide as
(
    select      -- diagnosis.py
                dx.age_at_dx,
                dx.histology,
                dx.grade_code,
                dx.grade_display,
                dx.behavior_code,
                dx.behavior_display,
                dx.tumor_location,
                dx.tumor_region,
                dx.tumor_size_mass_effect,
                dx.tumor_size_text,
                dx.nf1_status,
                -- surgery.py
                surgery.surgical_type,
                surgery.extent_of_resection,
                surgery.approach,
                -- genes.py
                gene.braf_altered,
                gene.braf_v600e,
                gene.braf_fusion,
                gene.idh_mutant,
                gene.h3k27m_mutant,
                gene.tp53_altered,
                gene.cdkn2a_deleted,
                gene.hgnc_name,
                gene.hgvs_variant,
                gene.variant_interpretation,
                -- drugs_glioma.py
                rx_chemo.rx_class                   as rx_chemo_class,
                rx_chemo.rx_regimen                 as rx_chemo_regimen,
                rx_chemo.rx_status                  as rx_chemo_status,
                rx_chemo.rx_treatment_phase         as rx_chemo_treatment_phase,
                rx_chemo.rx_treatment_response      as rx_chemo_treatment_response,
                rx_chemo.rx_toxicity_severity       as rx_chemo_toxicity_severity,
                rx_chemo.rx_treatment_discontinued  as rx_chemo_treatment_discontinued,
                rx_target.rx_class                  as rx_target_class,
                rx_target.rx_status                 as rx_target_status,
                rx_target.rx_treatment_phase        as rx_target_treatment_phase,
                rx_target.rx_treatment_response     as rx_target_treatment_response,
                rx_target.rx_toxicity_severity      as rx_target_toxicity_severity,
                rx_target.rx_treatment_discontinued as rx_target_treatment_discontinued,
                patient_list.note_ref,
                patient_list.encounter_ref,
                patient_list.subject_ref
    from        patient_list
    left join   glioma__llm_dx          as dx       on patient_list.note_ref = dx.note_ref
    left join   glioma__llm_gene        as gene     on patient_list.note_ref = gene.note_ref
    left join   glioma__llm_surgery     as surgery  on patient_list.note_ref = surgery.note_ref
    left join   glioma__llm_rx_chemo    as rx_chemo on patient_list.note_ref = rx_chemo.note_ref
    left join   glioma__llm_rx_target   as rx_target on patient_list.note_ref = rx_target.note_ref
)
select distinct * from wide;

