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
| `grade_code`             | varchar | ICD-0 grade reflects how closely the tumor cells resemble normal tissue.   |
| `histology`              | varchar | Glioma histology, if stated                                                |
| `behavior_code`          | varchar | IC2D-O behavior code (e.g., /3 = malignant primary site)                   |
| `tumor_location`         | varchar | Primary tumor anatomic location                                            |
| `tumor_region`           | varchar | Tumor region or anatomic compartment (e.g., posterior fossa, diencephalic) |
| `tumor_size_mass_effect` | varchar | Whether MRI/CT describes mass effect or hydrocephalus                      |


### _grade_code_
```
1 = Well differentiated;
2 = Moderately differentiated
3 = Poorly differentiated
4 = Undifferentiated / Anaplastic
9 = Grade cannot be assessed
```

### _histology_
```    
PILOCYTIC_ASTROCYTOMA
PILOMYXOID_ASTROCYTOMA
DIFFUSE_ASTROCYTOMA
GANGLIOGLIOMA
DNET # (Dysembryoplastic neuroepithelial tumor)
OTHER_LGG = "OTHER_LGG"
UNKNOWN = "UNKNOWN"
NOT_MENTIONED
```

### _tumor_location_
```    
CEREBELLUM
BRAINSTEM
OPTIC_PATHWAY
HYPOTHALAMUS 
OPTIC_PATHWAY_HYPOTHALAMIC
THALAMUS
OTHER
NOT_MENTIONED
```

### _tumor_region_
```    
POSTERIOR_FOSSA
DIENCEPHALIC
CEREBRAL_HEMISPHERE
SPINAL
OTHER
NOT_MENTIONED
```

### _tumor_size_mass_effect_
```    
MASS_EFFECT_PRESENT
HYDROCEPHALUS
MIDLINE_SHIFT
IMPENDING_HERNIATION
OTHER
NONE
NOT_MENTIONED
```

### _behavior_code_
```
BENIGN = "/0"
UNCERTAIN = "/1"
IN_SITU = "/2"
MALIGNANT_PRIMARY = "/3"
MALIGNANT_METASTATIC = "/6"
MALIGNANT_RECURRENT = "/9"
```



### _nf1_status_



## LLM enabled computable phenotypes
    "glioma__cube_patient_llm_dx",
    "glioma__cube_patient_llm_dx_progression",
    "glioma__cube_patient_llm_dx_progression_bin",
    "glioma__cube_patient_llm_rx_chemo",
    "glioma__cube_patient_llm_rx_target",
    "glioma__cube_patient_llm_gene",
    "glioma__cube_patient_llm_gene_progression",
    "glioma__cube_patient_llm_gene_progression_bin",
    "glioma__cube_patient_llm_surgery",
    "glioma__cube_patient_llm_progression",
    "glioma__cube_patient_llm_tx",
    "glioma__cube_patient_llm_tx_response_30_days",
    "glioma__cube_patient_llm_tx_response_30_days_bin",
    "glioma__cube_patient_llm_tx_response_30_days_nadine",
    "glioma__cube_patient_llm_tx_response_30_days_nadine_bin",


