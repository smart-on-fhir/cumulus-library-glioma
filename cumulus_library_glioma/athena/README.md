# Glioma CUBE

CUBE(s) are simply the CUBE keyword in a group by "**CUBE**" clause resulting in a mathematical PowerSet 
* https://prestodb.io/docs/current/sql/select.html#group-by-clause
* https://en.wikipedia.org/wiki/Power_set

# SQL Tables as CSV

CSV table naming conventions

| alias             | meaning                                                 |
|-------------------|---------------------------------------------------------|
| glioma__          | cumulus study prefix                                    |
| cube              | powerset counts                                         |
| patient           | count distinct patients                                 |
| encounter         | count distinct encounters                               |
| note              | count distinct clinical notes (document or reprt)       |
| documentreference | count distinct document reference                       |
| diagnosticreport  | count distinct diagnostic report                        |
| casedef           | match case definition for LGG(Low Grade Glioma)         |
| sample            | sample LGG cohort                                       |
| pre               | sample LGG cohort _before_ first LGG diagnosis          |
| peri              | sample LGG cohort _during_ first LGG diagnosis          |
| peri_post         | sample LGG cohort _during or after_ first LGG diagnosis |
| post              | sample LGG cohort _after_ first LGG diagnosis           |

---
# "Patients matching glioma case definition"

## glioma__cube_encounter_casedef

Count distinct **FHIR encounter** in cohort matching glioma case definition.    
Stratified by FHIR Encounter class, type, and serviceType.   

| column                    | type    | description                                                          |
|---------------------------|---------|----------------------------------------------------------------------|
| `cnt`                     | bigint  | count(distinct `encounter`)                                          |
| `age_at_dx_min`           | int     | age at diagnosis of glioma                                           |
| `age_at_visit`            | int     | age at visit (encounter)                                             |
| `dx_category_code`        | varchar | FHIR Condition.category [`encounter-diagnosis`, `problem-list-item`] |
| `enc_class_code`          | varchar | FHIR Encounter.class [AMB, EMER, OBSENC, IMP]                        |
| `enc_period_ordinal`      | varchar | Calculated FHIR Encounter sequence number                            |
| `enc_servicetype_display` | varchar | FHIR Encounter.serviceType display                                   |
| `enc_type_display`        | varchar | FHIR Encounter.type display                                          |

## glioma__cube_patient_casedef

Count distinct **FHIR Patient** in cohort matching glioma case definition.    
Stratified by demographics (age at diagnosis, gender, race) and diagnosis (code, display, system). 

| column             | type    | description                                                          |
|--------------------|---------|----------------------------------------------------------------------|
| `cnt`              | int     | count(distinct `subject`)                                            |
| `age_at_dx_min`    | int     | age at diagnosis of glioma                                           |
| `dx_category_code` | varchar | FHIR Condition.category [`encounter-diagnosis`, `problem-list-item`] |
| `dx_code`          | varchar | FHIR Condition.code code                                             |
| `dx_display`       | varchar | FHIR Condition.code display                                          |
| `dx_system`        | varchar | FHIR Condition.code system                                           |
| `gender`           | varchar | HL7 Administrative Sex                                               |
| `race_display`     | varchar | Patient Reported Race                                                ||

---
# RX "medication requests and/or administration for glioma cases"

## glioma__cube_patient_casedef_rx 

| column             | type    | description                                                             |
|--------------------|---------|-------------------------------------------------------------------------|
| `cnt`              | bigint  | count(distinct `subject_ref`)                                           |
| `age_at_visit`     | int     | patient age at the time of visit. Each patient can have 1+ age_at_visit |
| `gender`           | varchar | HL7 Administrative Sex                                                  |
| `race_display`     | varchar | Patient Reported Race                                                   |
| `rx_category_code` | varchar | FHIR MedicationRequest.category.code                                    |
| `rx_code`          | varchar | FHIR MedicationRequest.medication.code                                  |
| `rx_display`       | varchar | FHIR MedicationRequest.medication.display                               |
| `rx_system`        | varchar | FHIR MedicationRequest.medication.system                                |

## glioma__cube_patient_casedef_rx_variable

(+) adds `valueset` extends  `glioma__cube_patient_casedef_rx`

| column             | type    | description                                   |
|--------------------|---------|-----------------------------------------------|
| `valueset`         | varchar | computable phenotype valuesets for drug class | 

---
# sample "clinical notes starting when glioma was first diagnosed until most recent visit"

## glioma__cube_patient_casedef

| column             | type    | description                                                             |
|--------------------|---------|-------------------------------------------------------------------------|
| `cnt`              | int     | count(distinct `subject_ref`)                                           |
| `age_at_visit`     | int     | patient age at the time of visit. Each patient can have 1+ age_at_visit |
| `gender`           | varchar | HL7 Administrative Sex                                                  |
| `race_display`     | varchar | Patient Reported Race                                                   |
| `dx_category_code` | varchar | FHIR Condition.category.code                                            |
| `dx_code`          | varchar | FHIR Condition.code.code                                                |
| `dx_display`       | varchar | FHIR Condition.code.display                                             |
| `dx_system`        | varchar | FHIR Condition.code.system                                              |

## glioma__cube_note_sample_casedef_peri_post

Count distinct note_ref ( **FHIR DocumentReference** or **FHIR DiagnosticReport)** in cohort matching LGG case definition.    
Stratified by FHIR Encounter.class and "type" (FHIR DocumentReference.type or FHIR DiagnosticReport.code) .   

| column          | type    | description                                   |
|-----------------|---------|-----------------------------------------------|
| `cnt`           | int     | count(distinct `subject_ref`)                 |
| `note_code`     | varchar | FHIR DocumentReference.type code              |
| `note_display`  | varchar | FHIR DocumentReference.type display           |
| `note_system`   | varchar | FHIR DocumentReference.type system            |
| `class_display` | varchar | FHIR Encounter.class [AMB, EMER, OBSENC, IMP] |


# study population "all patients who visited at least 3x during the study period with at least 90 days of history"

## glioma__cube_patient_study_population
| column         | type    | description                                                             |
|----------------|---------|-------------------------------------------------------------------------| 
| `cnt`          | int     | count(distinct `subject_ref`)                                           |
| `site`         | varchar | [ `CHOP` (Philadelphia) and `BCH` (Boston)]                             | 
| `age_at_visit` | int     | patient age at the time of visit. Each patient can have 1+ age_at_visit |
| `gender`       | varchar | HL7 Administrative Sex                                                  |
| `race_display` | varchar | Patient Reported Race                                                   |

## glioma__cube_patient_study_population_dx
| column             | type    | description                  |
|--------------------|---------|------------------------------| 
| `dx_category_code` | varchar | FHIR Condition.category.code |
| `dx_code`          | varchar | FHIR Condition.code.code     |
| `dx_display`       | varchar | FHIR Condition.code.display  |
| `dx_system`        | varchar | FHIR Condition.code.system   |

## glioma__cube_patient_study_population_rx
| column             | type    | description                               |
|--------------------|---------|-------------------------------------------| 
| `rx_category_code` | varchar | FHIR MedicationRequest.category.code      |
| `rx_code`          | varchar | FHIR MedicationRequest.medication.code    |
| `rx_display`       | varchar | FHIR MedicationRequest.medication.display |
| `rx_system`        | varchar | FHIR MedicationRequest.medication.system  |

## glioma__cube_patient_study_population_lab

| column                    | type    | description                                      |
|---------------------------|---------|--------------------------------------------------|
| `lab_observation_code`    | varchar | FHIR Observation `code` or `component` (code)    |
| `lab_observation_display` | varchar | FHIR Observation `code` or `component` (display) |
| `lab_observation_system`  | varchar | FHIR Observation `code` or `component` (system)  |

## glioma__cube_patient_study_population_doc
| column             | type    | description                                   |
|--------------------|---------|-----------------------------------------------|
| `doc_type_code`    | varchar | FHIR DocumentReference.type code              |
| `doc_type_display` | varchar | FHIR DocumentReference.type display           |
| `doc_type_system`  | varchar | FHIR DocumentReference.type system            |
| `class_display`    | varchar | FHIR Encounter.class [AMB, EMER, OBSENC, IMP] |

## glioma__cube_patient_study_population_diag
| column                       | type    | description                                   |
|------------------------------|---------|-----------------------------------------------|
| `diag_category_display_best` | varchar | FHIR DocumentReference.category.display       |
| `diag_category_system`       | varchar | FHIR DocumentReference.category.system        |
| `enc_class_code`             | varchar | FHIR Encounter.class [AMB, EMER, OBSENC, IMP] |

## glioma__cube_patient_study_population_proc
| column         | type    | description                 |
|----------------|---------|-----------------------------|
| `proc_code`    | varchar | FHIR Procedure.code.code    |
| `proc_display` | varchar | FHIR Procedure.code.display |
| `proc_system`  | varchar | FHIR Procedure.code.system  |

--- 
# "LLM enabled computable phenotypes"

## glioma__cube_patient_llm_dx

| column                   | type    | LLM Prompt                                                                 |
|--------------------------|---------|----------------------------------------------------------------------------| 
| `cnt`                    | int     | count( distinct `subject_ref`)                                             |
| `age_at_dx`              | int     | age at diagnosis of glioma                                                 |
| `grade_code`             | int     | ICD-0 grade reflects how closely the tumor cells resemble normal tissue.   |
| `histology`              | varchar | Glioma histology, if stated                                                |
| `behavior_code`          | varchar | IC2D-O behavior code (e.g., /3 = malignant primary site)                   |
| `tumor_location`         | varchar | Primary tumor anatomic location                                            |
| `tumor_region`           | varchar | Tumor region or anatomic compartment (e.g., posterior fossa, diencephalic) |
| `tumor_size_mass_effect` | varchar | Whether MRI/CT describes mass effect or hydrocephalus                      |
| `nf1_status`             | varchar | Whether NF1 is present                                                     |

### _grade_code_
    1 = Well differentiated;
    2 = Moderately differentiated
    3 = Poorly differentiated
    4 = Undifferentiated / Anaplastic
    9 = Grade cannot be assessed

### _histology_
    PILOCYTIC_ASTROCYTOMA
    PILOMYXOID_ASTROCYTOMA
    DIFFUSE_ASTROCYTOMA
    GANGLIOGLIOMA
    DNET # (Dysembryoplastic neuroepithelial tumor)
    OTHER_LGG
    UNKNOWN
    NOT_MENTIONED


### _tumor_location_ 
    CEREBELLUM
    BRAINSTEM
    OPTIC_PATHWAY
    HYPOTHALAMUS 
    OPTIC_PATHWAY_HYPOTHALAMIC
    THALAMUS
    OTHER
    NOT_MENTIONED


### _tumor_region_
    POSTERIOR_FOSSA
    DIENCEPHALIC
    CEREBRAL_HEMISPHERE
    SPINAL
    OTHER
    NOT_MENTIONED


### _tumor_size_mass_effect_
    
    MASS_EFFECT_PRESENT
    HYDROCEPHALUS
    MIDLINE_SHIFT
    IMPENDING_HERNIATION
    OTHER
    NONE
    NOT_MENTIONED


### _behavior_code_
    BENIGN = "/0"
    UNCERTAIN = "/1"
    IN_SITU = "/2"
    MALIGNANT_PRIMARY = "/3"
    MALIGNANT_METASTATIC = "/6"
    MALIGNANT_RECURRENT = "/9"


### _nf1_status_
    POSITIVE
    SUSPECTED
    NEGATIVE
    MENTIONED_BUT_UNKNOWN
    NOT_MENTIONED

## glioma__cube_patient_llm_progression

| column             | type    | LLM Prompt                                                                |
|--------------------|---------|---------------------------------------------------------------------------| 
| `cnt`              | int     | count ( distinct `subject_ref`)                                           |
| `progression`      | varchar | Radiographic / functional progression status as stated                    | 
| `regrowth_pattern` | varchar | Pattern of regrowth on/off therapy (progression vs rebound vs resistance) |
| `symptom_burden`   | varchar | Symptoms attributed to the tumor; may include multiple                    |
| `therapy_modality` | varchar | Previously received modalities (surgery / chemo / targeted / RT / trial)  |
| `visual_status`    | varchar | Directionality of visual function over time                               |

### _progression_ 
    RADIOGRAPHIC
    FUNCTIONAL
    SUSPECTED
    BOTH
    NONE
    NOT_MENTIONED


### _regrowth_pattern_
    PROGRESSION
    REBOUND_AFTER_STOPPING_TARGETED
    RESISTANCE_ON_TARGETED
    PSEUDOPROGRESSION_SUSPECTED
    OTHER
    NOT_MENTIONED


### _symptom_burden_
    SEIZURES
    HEADACHE
    FOCAL_NEURO_DEFICIT
    VISUAL_SYMPTOMS
    ENDOCRINE_SYMPTOMS
    INCREASED_ICP
    OTHER
    NOT_MENTIONED

### _therapy_modality_ 
    OBSERVATION
    SURGERY
    CHEMOTHERAPY
    TARGETED_THERAPY
    RADIOTHERAPY
    CLINICAL_TRIAL
    NOT_MENTIONED

### _therapy_modality_ 
    OBSERVATION
    SURGERY
    CHEMOTHERAPY
    TARGETED_THERAPY
    RADIOTHERAPY
    CLINICAL_TRIAL
    NOT_MENTIONED

### _visual_status_
    DECLINING
    SEVERE_LOSS
    STABLE
    IMPROVING 
    OTHER
    NOT_MENTIONED

## glioma__cube_patient_llm_gene

### molecular drivers

| column                 | type | LLM Prompt                                          |
|------------------------|------|-----------------------------------------------------| 
| `braf_altered`         | bool | **BRAF** alteration is present (any type).          | 
| `braf_v600e`           | bool | **BRAF** V600E mutation is present                  |
| `braf_fusion`          | bool | **BRAF** fusion (e.g., KIAA1549-BRAF) is present    |
| `idh_mutant`           | bool | IDH1 or IDH2 mutation is present                    |
| `h3k27m_mutant`        | bool | Histone H3 K27M (H3-3A or H3C2) mutation is present |
| `tp53_altered`         | bool | TP53 mutation or loss is present                    |
| `cdkn2a_deleted`       | bool | CDKN2A deletion is present                          |
| `nf1_mapk_activation`  | bool | NF1 MAPK activation is present                      |
| `other_raf_alteration` | bool | Other RAF alteration is present                     | 
| `fgfr_alteration`      | bool | FGFR alteration is present                          | 
| `ntrk_fusion`          | bool | NTRK fusion is present                              | 
| `alk_fusion`           | bool | ALK fusion is present                               | 
| `ros1_fusion`          | bool | ROS1 fusion is present                              | 

### genetic variants

| column           | type    | LLM Prompt                                                        |
|------------------|---------|-------------------------------------------------------------------| 
| `hgnc_name`      | varchar | HGNC/HUGO gene naming convention                                  |
| `hgvs_variant`   | varchar | HGVS variant string (e.g., NM_004333.6(BRAF):c.1799T>A).          |
| `interpretation` | varchar | Clinical interpretation of genetic variant or genetic test result |

### _interpretation_
    BENIGN
    LIKELY BENIGN
    VARIANT OF UNKNOWN SIGNIFICANCE
    PATHOGENIC
    LIKELY PATHOGENIC
    NOT_MENTIONED

## glioma__cube_patient_llm_rx_chemo

| column                      | type    | LLM Prompt                                                |
|-----------------------------|---------|-----------------------------------------------------------| 
| `cnt`                       | int     | count ( distinct `subject_ref`)                           |
| `rx_class`                  | varchar | Glioma chemotherapy drug class                            | 
| `rx_regimen`                | varchar | Glioma chemotherapy regimen                               | 
| `rx_status`                 | varchar | Glioma chemotherapy status (active/completed/stopped/etc) |
| `rx_treatment_response`     | varchar | Response to therapy                                       |
| `rx_treatment_phase`        | varchar | Glioma chemotherapy treatment phase                       |
| `rx_toxicity_severity`      | varchar | What was the toxicity severity of glioma chemotherapy?    |
| `rx_treatment_discontinued` | varchar | Therapy discontinued reason                               |

### _rx_treatment_response_ 
    COMPLETE_RESPONSE
    PARTIAL_RESPONSE
    MINOR_RESPONSE
    STABLE_DISEASE
    PROGRESSIVE_DISEASE
    MIXED_RESPONSE
    PSEUDOPROGRESSION
    NOT_EVALUABLE
    NOT_MENTIONED

### _rx_class_ (chemo)
    ALKYLATING_AGENT    # e.g., temozolomide, lomustine (protocol-dependent)
    PLATINUM_AGENT      # e.g., carboplatin, cisplatin
    VINCA_ALKALOID      # e.g., vincristine, vinblastine
    TOP1_INHIBITOR      # e.g., irinotecan
    ANTIMETABOLITE      # e.g., methotrexate (less common, context-dependent)
    MULTI_AGENT_CHEMOTHERAPY # protocol bundle when class not decomposed
    OTHER
    NOT_MENTIONED

### _rx_regimen_ (chemo)
    TPCV # thioguanine/procarbazine/CCNU/vincristine (legacy)
    CARBOPLATIN
    CARBOPLATIN_VINCRISTINE
    VINBLASTINE 
    BEVACIZUMAB_IRINOTECAN
    BEVACIZUMAB
    OTHER
    NOT_MENTIONED

### _rx_status_
    ACTIVE = "Medication order is active (currently prescribed and intended for ongoing use)."
    INTENDED = "Medication is planned/ordered/prescribed but therapy has not yet started."
    COMPLETED = "Medication course is finished (all doses given or intended duration completed)."
    STOPPED = "Medication was stopped or permanently discontinued before completion."
    CANCELED = "Medication order was canceled/withdrawn before any doses were administered."
    ON_HOLD = "Medication is temporarily paused (on-hold, suspended, or interrupted)."
    NONE = "None of the above"
    NOT_MENTIONED = "Medication status was not mentioned."

###  _rx_toxicity_severity_
    MILD
    MODERATE
    SEVERE
    DOSE_LIMITING
    OTHER
    NOT_MENTIONED


### _rx_treatment_discontinued_    
    PROGRESSION
    TOXICITY
    LACK_OF_RESPONSE
    COMPLETED_PLANNED_THERAPY
    PATIENT_PREFERENCE
    TRANSITION_TO_TRIAL
    OTHER
    NOT_MENTIONED

### _rx_treatment_phase_ 
    INDUCTION
    MAINTENANCE
    RESCUE
    NONE
    NOT_MENTIONED

## glioma__cube_patient_llm_rx_target

| column                      | type    | LLM Prompt                                                    |
|-----------------------------|---------|---------------------------------------------------------------| 
| `cnt`                       | int     | count ( distinct `subject_ref`)                               |
| `rx_class`                  | varchar | Glioma targeted therapy                                       |
| `rx_status`                 | varchar | Glioma targeted therapy status (active/completed/stopped/etc) |
| `rx_treatment_response`     | varchar | What was the glioma targeted therapy treatment response?      |
| `rx_treatment_phase`        | varchar | Glioma targeted therapy treatment phase                       |
| `rx_toxicity_severity`      | varchar | What was the toxicity severity of glioma targeted therapy?    |
| `rx_treatment_discontinued` | varchar | Was glioma targeted therapy discontinued, and why             |

### _rx_class (targeted therapy)_
    MEK_INHIBITOR
    BRAF_INHIBITOR
    BRAF_MEK_COMBINATION
    PAN_RAF_INHIBITOR
    FGFR_INHIBITOR
    NTRK_INHIBITOR
    ALK_INHIBITOR
    ROS1_INHIBITOR
    RET_INHIBITOR
    MTOR_INHIBITOR
    IDH_INHIBITOR
    OTHER
    NOT_MENTIONED

