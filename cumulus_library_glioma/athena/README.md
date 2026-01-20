# Glioma CUBE

CUBE(s) are simply the CUBE keyword in a group by "**CUBE**" clause resulting in a mathematical PowerSet 
* https://prestodb.io/docs/current/sql/select.html#group-by-clause
* https://en.wikipedia.org/wiki/Power_set

## SQL Tables as CSV

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

### glioma__cube_encounter_casedef

Count distinct **FHIR encounter** in cohort matching LGG case definition.    
Stratified by FHIR Encounter class, type, and serviceType.   

| column                     | type     | description                                   |
|----------------------------|----------|-----------------------------------------------|
| `cnt`                      | bigint   | count(distinct `encounter`)                   |
| `enc_class_code`           | varchar  | FHIR Encounter.class [AMB, EMER, OBSENC, IMP] |
| `enc_period_ordinal`       | varchar  | Calculated FHIR Encounter sequence number     |
| `enc_servicetype_display`  | varchar  | FHIR Encounter.serviceType display            |
| `enc_type_display`         | varchar  | FHIR Encounter.type display                   |

### glioma__cube_patient_casedef

Count distinct **FHIR Patient** in cohort matching LGG case definition.    
Stratified by demographics (age at diagnosis, gender, race) and diagnosis (code, display, system). 

| column             | type    | description                                                                    |
|--------------------|---------|--------------------------------------------------------------------------------|
| `cnt`              | int     | count(distinct `subject`)                                                      |
| `age_at_dx_min`    | int     | patient age at the time of visit. Each patient can have multiple age_at_visit  |
| `dx_category_code` | varchar | FHIR Condition.category [`encounter-diagnosis`, `problem-list-item`]           |
| `dx_code`          | varchar | FHIR Condition.code code                                                       |
| `dx_display`       | varchar | FHIR Condition.code display                                                    |
| `dx_system`        | varchar | FHIR Condition.code system                                                     |
| `gender`           | varchar | HL7 Administrative Sex                                                         |
| `race_display`     | varchar | Patient Reported Race                                                          |


### glioma__cube_patient_dx
Diagnoses other than pLGG within patient cases. Essentially, "comorbidities" (co-occuring diagnosis).  

| column             | type    | description                                                                    |
|--------------------|---------|--------------------------------------------------------------------------------|
| `cnt`              | int     | count(distinct `subject`)                                                      |
| `age_at_dx_min`    | int     | patient age at the time of visit. Each patient can have multiple age_at_visit  |
| `dx_category_code` | varchar | FHIR Condition.category [`encounter-diagnosis`, `problem-list-item`]           |
| `dx_code`          | varchar | FHIR Condition.code code                                                       |
| `dx_display`       | varchar | FHIR Condition.code display                                                    |
| `dx_system`        | varchar | FHIR Condition.code system                                                     |
| `gender`           | varchar | HL7 Administrative Sex                                                         |
| `race_display`     | varchar | Patient Reported Race                                                          |

### glioma__cube_patient_rx

Medication requests -- prescriptions with potential administration -- within patient cases.

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

### glioma__cube_note_sample_casedef_peri_post
Count distinct note_ref ( **FHIR DocumentReference** or **FHIR DiagnosticReport)** in cohort matching LGG case definition.    
Stratified by FHIR Encounter.class and "type" (FHIR DocumentReference.type or FHIR DiagnosticReport.code) .   

| column          | type    | description                                   |
|-----------------|---------|-----------------------------------------------|
| `cnt`           | int  | count(distinct `subject_ref`)                 |
| `note_code`     | varchar | FHIR DocumentReference.type code              |
| `note_display`  | varchar | FHIR DocumentReference.type display           |
| `note_system`   | varchar | FHIR DocumentReference.type system            |
| `class_display` | varchar | FHIR Encounter.class [AMB, EMER, OBSENC, IMP] |


### glioma__cube_patient_dx

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







