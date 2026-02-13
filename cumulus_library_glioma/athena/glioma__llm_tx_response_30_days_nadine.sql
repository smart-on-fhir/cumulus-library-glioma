create TABLE glioma__llm_tx_response_30_days_nadine as
with
match_dx as (
    select  subject_ref from glioma__llm_dx
    where   histology = 'PILOCYTIC_ASTROCYTOMA'
    or      tumor_location = 'OPTIC_PATHWAY_HYPOTHALAMIC'
    or      tumor_size_mass_effect = 'HYDROCEPHALUS'
),
match_molecular as (
    select  subject_ref from glioma__llm_gene_progression
    where   braf_altered = 'positive'
    or      hgnc_name = 'BRAF'
),
match_similar as (
    select subject_ref from match_dx
    UNION ALL
    select subject_ref from match_molecular
)
select  distinct
        tx.*
from    match_similar,
        glioma__llm_tx_response_30_days as tx
where   tx.subject_ref = match_similar.subject_ref
;