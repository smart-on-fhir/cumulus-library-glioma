## Getting Started 

| README                                | FILE                                                                |
|---------------------------------------|---------------------------------------------------------------------|
| Low Grade Glioma                      | [case_definition.md](case_definition.md)                            |
| Custom valuesets and drug keywords    | resources / [README.md](resources/README.md)                        |
| Athena SQL                            | athena / [README.md](cumulus_library_glioma/athena/README.md)       |

## clinical pathway variable descriptions 
| variables            | file                                     |
|----------------------|------------------------------------------|
| CDS Clinical Pathway | [variables_cds.tsv](variables_cds.csv)   |
| FHIR Resources       | [variables_fhir.tsv](variables_fhir.csv) |


## Makefiles for this study   

| Study Builder                         | FILE                                                                  |
|---------------------------------------|-----------------------------------------------------------------------|
| Manifest                              | [manifest.toml](cumulus_library_glioma/manifest.toml)                 |
| Valuesets (National Library Medicine) | [vsac.toml](cumulus_library_glioma/vsac.toml)                         |
| File uploads (vsac)                   | [file_upload_vsac.toml](cumulus_library_glioma/file_upload_vsac.toml) |
| File uploads (curated)                | [file_upload.toml](cumulus_library_glioma/file_upload.toml)           |


## LLM chart review files

| Chart Review                 | FILE                                                                                    |
|------------------------------|-----------------------------------------------------------------------------------------|
| Example patient cases (DEID) | llm / [examples](cumulus_library_glioma/llm/examples)                                   |
| Pydantic Schema              | llm / [pydantic_schema](cumulus_library_glioma/llm/pydantic_schema)                     |
| dx=diagnosis                 | llm /  [glioma__llm_dx.sql](cumulus_library_glioma/athena/glioma__llm_dx.sql)           |
| gene=molecular drivers       | llm /  [glioma__llm_gene.sql](cumulus_library_glioma/athena/glioma__llm_gene.sql)       |
| variant=genetic tests        | llm /  [glioma__llm_variant.sql](cumulus_library_glioma/athena/glioma__llm_variant.sql) |
| drug=medication              | llm /  [glioma__llm_drug.sql](cumulus_library_glioma/athena/glioma__llm_drug.sql)       |
| surgery=procedure            | llm /  [glioma__llm_surgery.sql](cumulus_library_glioma/athena/glioma__llm_surgery.sql) |
