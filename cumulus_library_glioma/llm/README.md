## LLM chart review

| Chart Review                 | LLM                                              | FILE                                                                                                                            |
|------------------------------|--------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------|
| Example patient cases (DEID) | [examples](examples) (DEID + consented)          | [case_C114759_with_BRAF_fusion.txt](examples/case_C114759_with_BRAF_fusion.txt);  [case_C136530.txt](examples/case_C136530.txt) |
| Pydantic Schema              | [pydantic_schema](pydantic_schema)               | SQL result:                                                                                                                     |
| diagnosis                    | [diagnosis.py](pydantic_schema/diagnosis.py)     | [glioma__llm_dx.sql](../athena/glioma__llm_dx.sql)                                                                              |
| molecular drivers            | [genes.py](pydantic_schema/genes.py)             | [glioma__llm_gene.sql](../athena/deprecated/glioma__llm_gene_deprecated.sql)                                                                          |
| genetic tests                | [genes.py](pydantic_schema/genes.py)             | [glioma__llm_variant.sql](../athena/glioma__llm_variant.sql)                                                                    |
| medication                   | [drug_glioma.py](pydantic_schema/drug_glioma.py) | [glioma__llm_rx_chemo.sql](../athena/glioma__llm_rx_chemo.sql); [glioma__llm_rx_target.sql](../athena/glioma__llm_rx_target.sql)                                                                |
| procedure                    | [surgery.py](pydantic_schema/surgery.py)         | [glioma__llm_surgery.sql](../athena/glioma__llm_surgery.sql)                                                                    |
| progression (+outcomes)      | [progression.py](pydantic_schema/progression.py) | TODO                                                                                                                            |
