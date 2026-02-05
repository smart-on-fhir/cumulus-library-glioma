create or replace view glioma__treatment as
with
surgery as
(
    select
            'SURGERY'               as tx_modality,
            tx.surgical_type        as tx_class,
            tx.extent_of_resection  as tx_regimen,
            tx.subject_ref,
            tx.encounter_ref,
            casedef.enc_period_start_day,
            casedef.days_since
    from
            glioma__llm_surgery     as tx,
            glioma__cohort_casedef  as casedef
    where
            tx.encounter_ref = casedef.encounter_ref
),
llm_rx_chemo as
(
    select
            'CHEMOTHERAPY'      as tx_modality,
            tx.rx_class         as tx_class,
            tx.rx_regimen       as tx_regimen,
            tx.subject_ref,
            tx.encounter_ref,
            casedef.enc_period_start_day,
            casedef.days_since
    from
            glioma__llm_rx_chemo    as tx,
            glioma__cohort_casedef  as casedef
    where
            tx.encounter_ref = casedef.encounter_ref
),
llm_rx_target as
(
    select
            'TARGETED_THERAPY'  as tx_modality,
            tx.rx_class         as tx_class,
            NULL                as tx_regimen,
            tx.subject_ref,
            tx.encounter_ref,
            casedef.enc_period_start_day,
            casedef.days_since
    from
            glioma__llm_rx_target   as tx,
            glioma__cohort_casedef  as casedef
    where
            tx.encounter_ref = casedef.encounter_ref
)
select * from surgery
UNION ALL
select * from llm_rx_chemo
UNION ALL
select * from llm_rx_target