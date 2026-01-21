# Getting Started 

## Technical documentation
This study is built on [Cumulus](https://docs.smarthealthit.org/cumulus/).

| Documentation                                                                                    | Task                                                     |  
|--------------------------------------------------------------------------------------------------|----------------------------------------------------------|
| Cumulus [first-time-setup](https://docs.smarthealthit.org/cumulus/library/first-time-setup.html) | build `core` dependacies required by this `glioma` study |
| [README.md](cumulus_library_glioma/README.md)                             | build `glioma` (this study)                              |     
| `athena`/[README.md](cumulus_library_glioma/athena/README.md)             | glioma schema in `athena` (SQL)                            |
| `llm`/[README.md](cumulus_library_glioma/llm/README.md)                   | glioma `LLM` prompts, instructions, and outputs            |

## Goals of this study  
For pediatric low-grade glioma (`pLGG`) patients, the "best" treatment is not always obvious. 
Should the child and their parents "wait and observe" or treat aggressively? Which treatments have the best outcomes in similar patients?

Our objectives are to 
1. Measure treatment outcomes in patient populations with pLGG
2. Match pLGG patients to compare treatment outcomes in patient sub-populations
3. Provide clinical decision support (`CDS`) to clinicians in the form of "real world" measures of pLGG treatment outcomes for patients with similar characteristics.   

_Disclaimer_: This study is in progress and _should not yet_ be used at the point of care.   

## What is a low-grade glioma? 
"_Glioma_" is a malignant tumor in the brain. "_Low grade_" is a measure of cancer severity.     
The glioma [clinical case definition](clinical_case_definition.md) was curated into a set of [glioma diagnosis codes](resources/glioma_casedef_dx.csv).    

## pLGG clinical pathway variables 
`Variables` include diagnostics, treatments, lines of therapy, responses to treatment and cancer progression. The long term goal is to aid CDS (clinical decision support) using patient data in standard FHIR format.         

| variables            | file                                             |
|----------------------|--------------------------------------------------|
| CDS Clinical Pathway | [variables_cds.tsv](resources/variables_cds.csv) |
| FHIR Resources       | [variables_fhir.tsv](resources/variables_fhir.csv)         |


## Glioma Drug Therapy
Pre-compiled list of glioma drugs is included in [glioma_casedef_rx.csv](resources/glioma_casedef_rx.csv), including all RXNORM drugs that match each of the following drug "class/pathwawy" or "ingredient" valuesets.  



| Chemotherapy OR targeted molecular | Drug class/pathway valueset                                                    | Ingredient valuesets(s)                                                                                                                                                                  |    
|------------------------------------|--------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------| 
| Chemotherapy + molecular           | [Cancer drugs (any)](cumulus_library_glioma/rx_ta_cancer.toml)                 |                                                                                                                                                                                          |
| Chemotherapy                       | [Alkylating agents](cumulus_library_glioma/rx_class_alkylating.toml)           | [Lomustine](cumulus_library_glioma/rx_in_lomustine.toml); [Procarbazine](cumulus_library_glioma/rx_in_procarbazine.toml); [Temozolomide](cumulus_library_glioma/rx_in_temozolomide.toml) |
| Chemotherapy                       | [Antimetabolites](cumulus_library_glioma/rx_class_antimetabolite.toml)         | [Thioguanine](cumulus_library_glioma/rx_in_thioguanine.toml)                                                                                                                             |
| Chemotherapy                       | [Platinum Compounds](cumulus_library_glioma/rx_class_platinum.toml)            | [Carboplatin](cumulus_library_glioma/rx_in_carboplatin.toml); [Cisplatin](cumulus_library_glioma/rx_in_cisplatin.toml)                                                                   |
| Chemotherapy                       | [Topoisomerase Inhibitors](cumulus_library_glioma/rx_class_topoisomerase.toml) | [Etoposide](cumulus_library_glioma/rx_in_etoposide.toml); [Irinotecan](cumulus_library_glioma/rx_in_irinotecan.toml)                                                                     |
| Chemotherapy                       | [Vinca Alkaloids](cumulus_library_glioma/rx_class_vinca.toml)                  | [Vinblastine](cumulus_library_glioma/rx_in_vinblastine.toml); [Vincristine](cumulus_library_glioma/rx_in_vincristine.toml);                                                              |
| Molecular                          | [BRAF inhibitors](cumulus_library_glioma/rx_class_braf.toml)                   |                                                                                                                                                                                          |
| Molecular                          | [ALK Inhibitors](cumulus_library_glioma/rx_class_alk.toml)                     |                                                                                                                                                                                          |
| Molecular                          | [FGFR Inhibitors](cumulus_library_glioma/rx_class_fgfr.toml)                   |                                                                                                                                                                                          |
| Molecular                          | [IDH1/IDH2 Inhibitors](cumulus_library_glioma/rx_class_idh.toml)               |                                                                                                                                                                                          |
| Molecular                          | [Monoclonal Antibodies](cumulus_library_glioma/rx_class_mab.toml)              | [Bevacizumab](cumulus_library_glioma/rx_in_bevacizumab.toml)                                                                                                                             |
| Molecular                          | [MAPK Pathway (general)](cumulus_library_glioma/rx_class_mapk.toml)            | (See also: BRAF, Pan-RAF, and MEK)                                                                                                                                                       |
| Molecular                          | [MEK1/MEK2 inhibitors](cumulus_library_glioma/rx_class_mek.toml)               | [Trametinib](cumulus_library_glioma/rx_in_trametinib.toml)                                                                                                                               |
| Molecular                          | [MTOR inhibitors](cumulus_library_glioma/rx_class_mtor.toml)                   |                                                                                                                                                                                          |
| Molecular                          | [NTRK Inhibitors](cumulus_library_glioma/rx_class_ntrk.toml)                   |                                                                                                                                                                                          |
| Molecular                          | [Pan-RAF kinase Inhibitors](cumulus_library_glioma/rx_class_pan_raf.toml)      |                                                                                                                                                                                          |
| Molecular                          | [RET inhibitors](cumulus_library_glioma/rx_class_ret.toml)                     |                                                                                                                                                                                          |
| Molecular                          | [ROS1 Inhibitors](cumulus_library_glioma/rx_class_ros1.toml)                   |                                                                                                                                                                                          |