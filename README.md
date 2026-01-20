## Getting Started 

| README                  | FILE                                                          |
|-------------------------|---------------------------------------------------------------|
| Clinical case definition | [case_case_definition.md](clinical_case_definition.md)        |
| Coded case definition   | [glioma_casedef_dx.csv](resources/glioma_casedef_dx.csv)      |
| Custom valuesets        | resources / [README.md](resources/README.md)                  |
| Athena SQL              | athena / [README.md](cumulus_library_glioma/athena/README.md) |

## Clinical pathway variable descriptions 
| variables            | file                                             |
|----------------------|--------------------------------------------------|
| CDS Clinical Pathway | [variables_cds.tsv](resources/variables_cds.csv) |
| FHIR Resources       | [variables_fhir.tsv](resources/variables_fhir.csv)         |


## Makefiles

| Study Builder                         | FILE                                                                  |
|---------------------------------------|-----------------------------------------------------------------------|
| Manifest                              | [manifest.toml](cumulus_library_glioma/manifest.toml)                 |
| File uploads (curated)                | [file_upload.toml](cumulus_library_glioma/file_upload.toml)           |


## Glioma Drug Therapy

| Class,Mechanism, or Pathway                             |
|---------------------------------------------------------|
| [ALK Inhibitors](rx_class_alk.toml)                     |
| [Alkylating agents](rx_class_alkylating.toml)           |
| [Antimetabolites](rx_class_antimetabolite.toml)         | 
| [BRAF inhibitors](rx_class_braf.toml)                   | 
| [Topoisomerase Inhibitors](rx_class_topoisomerase.toml) | 
| [FGFR Inhibitors](rx_class_fgfr.toml)                   | 
| [IDH1/IDH2 Inhibitors](rx_class_idh.toml)               | 
| [Monoclonal Antibodies](rx_class_mab.toml)              | 
| [MAPK Pathway (general)](rx_class_mapk.toml)            | 
| [MEK1/MEK2 inhibitors](rx_class_mek.toml)               | 
| [MTOR inhibitors](rx_class_mtor.toml)                   | 
| [NTRK Inhibitors](rx_class_ntrk.toml)                   | 
| [Pan-RAF kinase Inhibitors](rx_class_pan_raf.toml)      | 
| [Platinum Compounds](rx_class_platinum.toml)            | 
| [RET inhibitors](rx_class_ret.toml)                     | 
| [ROS1 Inhibitors](rx_class_ros1)                        | 
| [Vinca Alkaloids](rx_class_vinca.toml)                  |
| [Cancer drugs (general)](rx_ta_cancer.toml)             |


####  Drug Ingredients
"Monoclonal Ab IN: Bevacizumab"     = ["rx_in_bevacizumab.toml"]
"Platinum IN: Carboplatin"          = ["rx_in_carboplatin.toml"]
"Platinum IN: Cisplatin"            = ["rx_in_cisplatin.toml"]
"Topoisomerase IN: Etoposide"       = ["rx_in_etoposide.toml"]
"Topoisomerase IN: Irinotecan"      = ["rx_in_irinotecan.toml"]
"Alkylating IN: Lomustine"          = ["rx_in_lomustine.toml"]
"Alkylating IN: Procarbazine"       = ["rx_in_procarbazine.toml"]
"Alkylating IN: Temozolomide"       = ["rx_in_temozolomide.toml"]
"Antimetabolite IN: Thioguanine"    = ["rx_in_thioguanine.toml"]
"MEK inhibitor IN: Trametinib"      = ["rx_in_trametinib.toml"]
"Vinca Alkaloid IN: Vinblastine"    = ["rx_in_vinblastine.toml"]
"Vinca Alkaloid IN: Vincristine"    = ["rx_in_vincristine.toml"]


## LLM chart review

| Chart Review                 | LLM                                                                         | FILE                                                                             |
|------------------------------|-----------------------------------------------------------------------------|----------------------------------------------------------------------------------|
| Example patient cases (DEID) | [examples](cumulus_library_glioma/llm/examples)                             | None                                                                             |
| Pydantic Schema              | [pydantic_schema](cumulus_library_glioma/llm/pydantic_schema)               | None                                                                             |
| diagnosis                    | [diagnosis.py](cumulus_library_glioma/llm/pydantic_schema/diagnosis.py)     | [glioma__llm_dx.sql](cumulus_library_glioma/athena/glioma__llm_dx.sql)           |
| molecular drivers            | [genes.py](cumulus_library_glioma/llm/pydantic_schema/genes.py)             | [glioma__llm_gene.sql](cumulus_library_glioma/athena/glioma__llm_gene.sql)       |
| genetic tests                | [genes.py](cumulus_library_glioma/llm/pydantic_schema/genes.py)             | [glioma__llm_variant.sql](cumulus_library_glioma/athena/glioma__llm_variant.sql) |
| medication                   | [drug_glioma.py](cumulus_library_glioma/llm/pydantic_schema/drug_glioma.py) | [glioma__llm_drug.sql](cumulus_library_glioma/athena/glioma__llm_drug.sql)       |
| procedure                    | [surgery.py](cumulus_library_glioma/llm/pydantic_schema/surgery.py)         | [glioma__llm_surgery.sql](cumulus_library_glioma/athena/glioma__llm_surgery.sql) |
| progression (+outcomes)      | [progression.py](cumulus_library_glioma/llm/pydantic_schema/progression.py) | TODO                                                                             |
