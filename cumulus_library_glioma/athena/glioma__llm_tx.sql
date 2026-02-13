create TABLE glioma__llm_tx as
with
observation as
(
    select  'LLM'               as source,
            'OBSERVATION'       as tx_modality,
            'OBSERVATION'       as tx_class,
            'OBSERVATION'       as tx_specific,
            subject_ref,
            encounter_ref
    from    glioma__llm_progression
    where   therapy_modality = 'OBSERVATION'
),
radiotherapy AS
(
    select  'LLM'           as source,
            'RADIOTHERAPY'  as tx_modality,
            'RADIOTHERAPY'  as tx_class,
            'RADIOTHERAPY'  as tx_specific,
            subject_ref,
            encounter_ref
    from    glioma__llm_progression
    where   therapy_modality = 'RADIOTHERAPY'
),
surgery as
(
    select  'LLM'               as source,
            'SURGERY'           as tx_modality,
            case surgical_type
            when 'OTHER'
            then 'OTHER SURGERY'
            when 'RESECTION'
            then extent_of_resection
            else surgical_type  end as tx_class,
            extent_of_resection as tx_specific,
            subject_ref,
            encounter_ref
    from    glioma__llm_surgery
    where   surgical_type != 'NOT_MENTIONED'
),
llm_rx_chemo as
(
    select  'LLM'           as source,
            'CHEMOTHERAPY'  as tx_modality,
            case rx_class
            when 'OTHER'
            then 'CHEMOTHERAPY'
            when 'MULTI_AGENT_CHEMOTHERAPY'
            then 'CHEMOTHERAPY'
            else rx_class end   as tx_class,
            rx_regimen      as tx_specific,
            subject_ref,
            encounter_ref
    from    glioma__llm_rx_chemo
    where   rx_class != 'NOT_MENTIONED'
),
llm_rx_target as
(
    select  'LLM'               as source,
            'TARGETED_THERAPY'  as tx_modality,
            case rx_class
            when 'OTHER'
            then 'OTHER TARGETED'
            else rx_class end   as tx_class,
            NULL                as tx_specific,
            subject_ref,
            encounter_ref
    from    glioma__llm_rx_target
    where   rx_class != 'NOT_MENTIONED'
),
fhir_rx_chemo as
(
    select  'FHIR'          as source,
            'CHEMOTHERAPY'  as tx_modality,
            case valueset
            when 'vsac_rx_chemo'
            then 'CHEMOTHERAPY'
            when 'vsac_rx_chemo_advanced'
            then 'CHEMOTHERAPY'
            when 'vsac_rx_class_platinum'
            then 'PLATINUM'
            else valueset end   as tx_class,
            rx_display          as tx_specific,
            subject_ref,
            encounter_ref
    from    glioma__cohort_casedef_rx_variable
    where   valueset in (
            'vsac_rx_chemo',
            'vsac_rx_chemo_advanced',
            'vsac_rx_class_platinum',
            'rx_class_alkylating',
            'rx_class_antimetabolite',
            'rx_class_platinum',
            'rx_class_topoisomerase',
            'rx_class_vinca',
            'rx_in_carboplatin',
            'rx_in_cisplatin',
            'rx_in_etoposide',
            'rx_in_irinotecan',
            'rx_in_lomustine',
            'rx_in_procarbazine',
            'rx_in_temozolomide',
            'rx_in_thioguanine',
            'rx_in_vincristine',
            'rx_in_vinblastine',
            'rx_in_bevacizumab')
),
fhir_rx_target as
(
    select  'FHIR'              as source,
            'TARGETED_THERAPY'  as tx_modality,
            valueset            as tx_class,
            rx_display          as tx_specific,
            subject_ref,
            encounter_ref
    from    glioma__cohort_casedef_rx_variable
    where   valueset in (
            'rx_class_braf',
            'rx_class_mab',
            'rx_class_mapk',
            'rx_class_mek',
            'rx_class_ret',
            'rx_in_bevacizumab',
            'rx_class_fgfr',
            'rx_class_pan_raf',
            'rx_class_ros1',
            'rx_class_alk',
            'rx_class_idh',
            'rx_class_mtor',
            'rx_class_ntrk',
            'rx_in_trametinib')
),
union_all as
(
    select * from observation
    UNION ALL
    select * from radiotherapy
    UNION ALL
    select * from surgery
    UNION ALL
    select * from llm_rx_chemo
    UNION ALL
    select * from fhir_rx_chemo
    UNION ALL
    select * from llm_rx_target
    UNION ALL
    select * from fhir_rx_target
),
merged as
(
    select  distinct
            subject_ref,
            encounter_ref,
            source,
            tx_modality,
            tx_class as tx_class_source,
            trim(
            upper(
                regexp_replace(
                regexp_replace(
                regexp_replace(
                regexp_replace(
                regexp_replace(
                regexp_replace(tx_class,
                    '(?i)vsac_rx', ''),
                    '(?i)^rx_(class|in)_', ''),
                    '(?i)_(inhibitor|agent)$', ''),
                    'TOP1', 'TOPOISOMERASE'),
                    '\bvinca\b','VINCA_ALKALOID'),
                    '_',' ')
                    )) AS tx_class,
            tx_specific
    from union_all
)
select  distinct
        casedef.enc_period_start_day,
        casedef.days_since,
        merged.*
from    merged,
        glioma__cohort_casedef  as casedef
where   merged.encounter_ref = casedef.encounter_ref
;