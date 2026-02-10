create TABLE glioma__llm_gene as
with
driver as
(
    select  gene.has_mention,
            gene.braf_altered,
            gene.braf_v600e,
            gene.braf_fusion,
            gene.idh_mutant,
            gene.h3k27m_mutant,
            gene.tp53_altered,
            gene.cdkn2a_deleted,
            nlp.note_ref,
            nlp.encounter_ref,
            nlp.subject_ref
    from    glioma__nlp_gene_gpt_oss_120b as nlp
    LEFT JOIN   UNNEST(nlp.result.molecular_driver_mention) AS g(gene)
    ON TRUE
),
variant as
(
    select      gene.has_mention,
                gene.hgnc_name,
                gene.hgvs_variant,
                gene.interpretation,
                nlp.note_ref,
                nlp.encounter_ref,
                nlp.subject_ref
    from        glioma__nlp_gene_gpt_oss_120b as nlp
    LEFT JOIN   UNNEST(nlp.result.genetic_variant_mention) AS v(gene)
    ON TRUE
),
patient_list as
(
    select subject_ref, encounter_ref, note_ref from driver where has_mention
    union all
    select subject_ref, encounter_ref, note_ref from variant where has_mention
)
select  distinct
        coalesce(driver.has_mention, False)     as driver_mention,
        case driver.braf_altered
        when True   then 'positive'
        when False  then 'negative'
                    else 'NOT_MENTIONED' end    as braf_altered,
        case driver.braf_v600e
        when True   then 'positive'
        when False  then 'negative'
                    else 'NOT_MENTIONED' end    as braf_v600e,
        case driver.braf_fusion
        when True   then 'positive'
        when False  then 'negative'
                    else 'NOT_MENTIONED' end    as braf_fusion,
        case driver.idh_mutant
        when True   then 'positive'
        when False  then 'negative'
                    else 'NOT_MENTIONED' end    as idh_mutant,
        case driver.h3k27m_mutant
        when True   then 'positive'
        when False  then 'negative'
                    else 'NOT_MENTIONED' end    as h3k27m_mutant,
        case driver.tp53_altered
        when True   then 'positive'
        when False  then 'negative'
                    else 'NOT_MENTIONED' end    as tp53_altered,
        case driver.cdkn2a_deleted
        when True   then 'positive'
        when False  then 'negative'
                    else 'NOT_MENTIONED' end    as cdkn2a_deleted,
        coalesce(variant.has_mention, False)                    as variant_mention,
        coalesce(variant.interpretation,    'NOT_MENTIONED')    as variant_interpretation,
        coalesce(variant.hgnc_name,         'NOT_MENTIONED')    as hgnc_name,
        coalesce(variant.hgvs_variant,      'NOT_MENTIONED')    as hgvs_variant,
        patient_list.subject_ref,
        patient_list.encounter_ref,
        patient_list.note_ref
from    patient_list
left join driver    on patient_list.note_ref = driver.note_ref
left join variant   on patient_list.note_ref = variant.note_ref
;




