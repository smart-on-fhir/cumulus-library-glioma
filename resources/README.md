# resources

Custom curated definitions from Cumulus

## Case Definition for pLGG (Pediatric low grade glioma)
| valueset                      | file                                         |
|-----------------------------------|----------------------------------------------|
| Case Definition  | [valueset_casedef.csv](valueset_casedef.csv) |
| Clinical Pathway | [variables_cds.csv](variables_cds.csv)       |
| FHIR Resources | [variables_fhir.csv](variables_fhir.csv)     | 

## clinical pathway variables as tabular descriptions 
| variables      | file                                               |
|----------------|----------------------------------------------------|
| CDS Clinical Pathway | [variables_cds.tsv](variables_cds.csv)                                                |
| FHIR Resources | [variables_fhir.tsv](variables_fhir.csv)                                                |

## experimental work in progress

Dependancy: cumulus-library drug relationships. This is experimental work and not yet ready for primetime.   

### keywords (drug)
pLGG drug therapies

| keywords         | file                                                         |
|------------------|--------------------------------------------------------------|
| drug classes     | [keywords_drug_class.tsv](keywords_drug_class.tsv)           |
| drug ingredients | [keywords_drug_ingredient.tsv](keywords_drug_ingredient.tsv) |
| drug brands      | [keywords_drug_brand.tsv](keywords_drug_brand.tsv)           |

### relationships (drug)
pLGG drug relationships 

| relationships          | file                                                 |
|------------------------|------------------------------------------------------|
| pharmacologic class    | [rel_drug_class.tsv](rel_drug_class.tsv) | 
| ingredient <--> class  | [rel_drug_ingredient.tsv](rel_drug_ingredient.tsv) |
| brands <--> ingredient | [rel_drug_brand.tsv](rel_drug_brand.tsv)|


