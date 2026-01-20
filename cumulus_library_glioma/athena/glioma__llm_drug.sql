create or replace view glioma__llm_drug as
select      distinct
            coalesce(drug.has_mention, False)           as has_mention,
            coalesce(drug.rx_class, 'NOT_MENTIONED')    as rx_class,
            coalesce(drug.status, 'NOT_MENTIONED')      as status,
            coalesce(drug.category, 'NOT_MENTIONED')    as category,
            coalesce(drug.route, 'NOT_MENTIONED')       as route,
            coalesce(drug.phase, 'NOT_MENTIONED')       as phase,
            coalesce(drug.frequency, 'NOT_MENTIONED')   as frequency,
            drug.start_date,
            drug.end_date,
            drug.quantity_unit,
            drug.quantity_value,
            drug.expected_supply_days,
            drug.number_of_repeats_allowed,
            nlp.note_ref,
            nlp.encounter_ref,
            nlp.subject_ref
from        glioma__nlp_gpt_oss_120b as nlp
LEFT JOIN   UNNEST(nlp.result.cancer_medication_mention) AS t(drug)
ON TRUE;
