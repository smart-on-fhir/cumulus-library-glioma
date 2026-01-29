## Table of Contents

- [Recommended: use default pre-compiled sources](#recommended-use-default-pre-compiled-sources)
  - [Pre-requirement:](#pre-requirement)
  - [Quick setup for local use](#quick-setup-for-local-use)
    - [1. Download this repository](#1-download-this-repository)
    - [2. create virtual env](#2-create-virtual-env)
    - [3. build **glioma** study](#3-build-glioma-study)
  - [(optional) Upload patient counts to Cumulus network](#optional-upload-patient-counts-to-cumulus-network)

- [Experimental: build from original sources](#experimental-build-from-original-sources)
  - [Pre-requirements:](#pre-requirements)
    - [1. build glioma drug valueset](#1-build-glioma-drug-valueset)
    - [2. save table to CSV file](#2-save-table-to-csv-file)
    - [3. copy CSV to resources dir](#3-copy-csv-to-resources-dir)
- [Development: LLM work in progress](#development-llm-work-in-progress)

- [Directory contents](#directory-contents)

# Recommended: use default pre-compiled sources

## Pre-requirement:
* Cumulus [first-time-setup](https://docs.smarthealthit.org/cumulus/library/first-time-setup.html) build `core` dependancy 

## Quick setup for local use 
### 1. Download this repository
```
git clone git@github.com:smart-on-fhir/cumulus-library-glioma.git
```
### 2. create virtual env
```
python3 -m venv ve; source ve/bin/activate`
```
### 3. build **glioma** study
```
cumulus-library build  -s . -t glioma
cumulus-library export -s . -t glioma
```
## (optional) Upload patient counts to Cumulus network
```
cumulus-library upload -s . -t glioma
```

---
# Experimental: build from original sources

## Pre-requirements:
* Cumulus [first-time-setup](https://docs.smarthealthit.org/cumulus/library/first-time-setup.html) build `core` dependancy
* Cumulus [RXNORM](https://github.com/smart-on-fhir/cumulus-library-rxnorm) 
* Cumulus [UMLS](https://github.com/smart-on-fhir/cumulus-library-umls)

### 1. build glioma drug valueset 
```commandline
rm manifest.toml
ln -s manifest_prereq_rx.toml
cumulus-library build  -s . -t glioma
```

### 2. save table to CSV file  
`select * from glioma__valueset_casedef_rx order by valueset, code`

### 3. copy CSV to resources dir

---
# Development: LLM work in progress

See `llm`/[README.md](llm/README.md)

Collaborators may find value in the LLM prompts and pydantic schema.  
Currently this works only at BCH and is not "out of the box" ready for use at other hospitals.

---
# Directory contents 

| File                                               | Description                                                 |
|----------------------------------------------------|-------------------------------------------------------------|
| [file_upload.toml](file_upload.toml)               | default= precompiled valuesets to upload to Athena          |
| [manifest.toml](manifest.toml)                     | default = [manifest_casedef.toml](manifest_casedef.toml)    |
| [manifest_casedef.toml](manifest_casedef.toml)     | builds glioma case definitions with fhir CUBE outputs.      |
| [manifest_variables.toml](manifest_variables_deprecated.toml) | builds glioma variables other than drug lists (in progress) |
| [manifest_llm.toml](manifest_llm.toml)             | builds LLM tables in Athena SQL with llm CUBE ouputs.       |
| [manifest_prereq_rx.toml](manifest_prereq_rx.toml) | build glioma RXNORM drug lists from sources.                |
| rx_____.toml files                                 | see [README.md](../README.md) "Glioma drug therapy"         |

 
    


