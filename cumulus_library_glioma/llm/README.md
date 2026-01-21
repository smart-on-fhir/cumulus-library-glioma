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
