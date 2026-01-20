## Getting Started 

| README           | FILE                                                          |
|------------------|---------------------------------------------------------------|
| Low Grade Glioma | [case_definition.md](case_definition.md)                      |
| Custom valuesets | resources / [README.md](resources/README.md)                  |
| Athena SQL       | athena / [README.md](cumulus_library_glioma/athena/README.md) |

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
