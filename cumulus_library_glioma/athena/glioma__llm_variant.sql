-- ############################################################################
-- DNA sequenced variants
-- See also glioma__llm_gene

create or replace view glioma__llm_variant as
select      distinct
            coalesce(variant.has_mention, False)                as has_mention,
            coalesce(variant.hgnc_name, 'NOT_MENTIONED')        as hgnc_name,
            coalesce(variant.hgvs_variant, 'NOT_MENTIONED')     as hgvs_variant,
            coalesce(variant.interpretation, 'NOT_MENTIONED')   as interpretation,
            nlp.note_ref,
            nlp.encounter_ref,
            nlp.subject_ref
from        glioma__nlp_gpt_oss_120b as nlp
LEFT JOIN   UNNEST(nlp.result.variant_mention) AS t(variant)
ON TRUE;

