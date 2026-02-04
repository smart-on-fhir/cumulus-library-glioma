## Examples

`examples` folder contains 3 **DEID** (de-identified) real **consented** pLGG cases from [CHOP](https://www.chop.edu/).
1. [case_C114759_with_BRAF_fusion.txt](examples/case_C114759_with_BRAF_fusion.txt)
2. [case_C136530.txt](examples/case_C136530.txt)
2. [case_C77613.txt](examples/case_C77613.txt)

`examples` folder also contains [_txt_, _html_, _fhir_] clinical notes synthetic notes (medical transcription samples.)  
* [glioma-consult.txt](examples/glioma-consult.txt)

## LLM chart review

| Chart Review            | Data Elements                                    | SQL                                                                                                                              |
|-------------------------|--------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| Pydantic Schema         | [pydantic_schema](pydantic_schema)               |                                                                                                                                  |
| diagnosis               | [diagnosis.py](pydantic_schema/diagnosis.py)     | [glioma__llm_dx.sql](../athena/glioma__llm_dx.sql)                                                                               |
| molecular drivers       | [genes.py](pydantic_schema/genes.py)             | [glioma__llm_gene.sql](../athena/glioma__llm_gene_deprecated.sql)                                                                |
| genetic tests           | [genes.py](pydantic_schema/genes.py)             | [glioma__llm_variant.sql](../athena/glioma__llm_variant.sql)                                                                     |
| medication              | [drug_glioma.py](pydantic_schema/drug_glioma.py) | [glioma__llm_rx_chemo.sql](../athena/glioma__llm_rx_chemo.sql); [glioma__llm_rx_target.sql](../athena/glioma__llm_rx_target.sql) |
| procedure               | [surgery.py](pydantic_schema/surgery.py)         | [glioma__llm_surgery.sql](../athena/glioma__llm_surgery.sql)                                                                     |
| progression (+outcomes) | [progression.py](pydantic_schema/progression.py) | [glioma__llm_progression.sql](../athena/glioma__llm_progression.sql)                                                             |
