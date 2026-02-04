-- ############################################################################
-- Clinical decision making << Clinical Gene Tests >>
-- See also glioma__llm_variant
create or replace view glioma__llm_gene as
select      distinct
            coalesce(genetics.has_mention, False)     as has_mention,
            case genetics.braf_altered
                when True   then 'positive'
                when False  then 'negative'
                else 'NOT_MENTIONED' end as braf_altered,
            case genetics.braf_v600e
                when True   then 'positive'
                when False  then 'negative'
                else 'NOT_MENTIONED' end as braf_v600e,
            case genetics.braf_fusion
                when True   then 'positive'
                when False  then 'negative'
                else 'NOT_MENTIONED' end as braf_fusion,
            case genetics.idh_mutant
                when True   then 'positive'
                when False  then 'negative'
                else 'NOT_MENTIONED' end as idh_mutant,
            case genetics.h3k27m_mutant
                when True   then 'positive'
                when False  then 'negative'
                else 'NOT_MENTIONED' end as h3k27m_mutant,
            case genetics.tp53_altered
                when True   then 'positive'
                when False  then 'negative'
                else 'NOT_MENTIONED' end as tp53_altered,
            case genetics.cdkn2a_deleted
                when True   then 'positive'
                when False  then 'negative'
                else 'NOT_MENTIONED' end as cdkn2a_deleted,
            nlp.note_ref,
            nlp.encounter_ref,
            nlp.subject_ref
from        glioma__nlp_document_type_claude_sonnet45 as nlp
LEFT JOIN   UNNEST(nlp.result.target_genetic_test_mention) AS t(genetics)
ON TRUE;
