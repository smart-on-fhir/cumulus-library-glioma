# Running the Glioma study

This guide will help you run the glioma study. At a high level, the
study and related NLP breaks down into three steps: 
1. Building the initial Glioma study tables
2. Ensuring you have access to the relevant DocumentReferences
3. Running NLP detecting document types  
4. Re-building the study to populate LLM-derived tables
5. Running variable-specific Glioma NLP

For the sake of this walkthrough, we will be targeting a small sample of data 
found in `glioma__sample_casedef_peri_post_limit_patient_10`. To run these instructions 
against the full population of patients defined in our casedef, replace all instances
of that table name with `glioma__sample_casedef_peri_post`

## Prerequisites

- An existing Cumulus stack, with an already-built `core` study.
  - See the general [Cumulus documentation](https://docs.smarthealthit.org/cumulus/)
    for setting that up.
- Familiarity with [creating new cumulus library studies](https://docs.smarthealthit.org/cumulus/library/creating-studies.html#creating-library-studies)
- Familiarity with [running NLP workflows using cumulus etl](https://docs.smarthealthit.org/cumulus/etl/nlp/example.html)
- This module should be installed in the same python environment as the cumulus stack. This can 
  be done by running `pip install cumulus-library-glioma`, which will add an `glioma` target 
  to `cumulus-library`. 
- **Lastly, make sure that your cloud environment has been updated to use the [latest set of DeltaTables](https://github.com/smart-on-fhir/cumulus-etl/blob/main/docs/setup/cumulus-aws-template.yaml). To support these numerous new tasks, new tables have been introduced.**

## 1. Run the ETL & Library study

First we want to build our cohort of interest with this glioma 
study and [cumulus-library](https://docs.smarthealthit.org/cumulus/library/) 
like so: 
```sh
cumulus-library build \
  --database <relevant_cumulus_library_database> \
  --workgroup <relevant_cumulus_library_workgroup> \
  --profile <relevant_cumulus_library_profile> \
  -t glioma 
```

After this (and re-running glue crawlers if this is your first time building the study) 
you should now have the glioma casedef and samples tables in Athena; this is excepting 
`glioma__llm_*` tables. We will build these after running our first doctype NLP, but that 
requires first building our study and defining our patient cohort.

## 2. Preparing our DocumentReferences 

Our NLP tasks will examine the notes associated with the cohort defined 
in `glioma__sample_casedef_peri_post_limit_patient_10`.

You can save off the information your data unarchive process will need from these 
tables. To sanity-check the number of patients, notes, and encounters we have, run the following: 
```sql
select 
       count(distinct subject_ref)   as cnt_pat, 
       count(distinct encounter_ref) as cnt_enc,
       count(distinct note_ref) as cnt_note
from glioma__sample_casedef_peri_post_limit_patient_10
```

This study operates on DocumentReference resources
(it runs NLP on the referenced clinical notes).
So we need to gather the original documents 

Gather the DocumentReference ndjson from your EHR.
You can either re-export the documents of interest,
or use ndjson from a previous export. Ideally these notes
are pre-inlined with clinical note content, as this will 
save time/hassle re-downloading the notes every time we run 
NLP. If you're gathering notes using our `smart-fetch` tool 
the notes should be [inlined automatically when exporting](https://docs.smarthealthit.org/cumulus/fetch/hydration.html#inlining-clinical-notes).

Place the ndjson in a folder, and take note of the path for later steps. 
Note that this set of DocumentReferences **can contain more** than the data in 
`glioma__sample_casedef_peri_post_limit_patient_10`, as future steps will filter
down to the notes described in this table.


## 3. Run NLP for Document_type stratification 

Using the `cumulus-etl` tool, we will now run our first NLP tasks. These instructions  
are for an [on-prem](https://docs.smarthealthit.org/cumulus/etl/nlp/example.html#local-on-prem-options) `gpt-oss-120b` instance, 
but support for other models is detailed in the [example-nlp setup docs](https://docs.smarthealthit.org/cumulus/nlp/models.html).
Note that using other models will require updating the `gpt-oss-120b` specific arguments below. 

First you want to set up the GPT-OSS instance to run locally:
```sh
docker compose up --wait gpt-oss-120b
```

Once the LLM instance is up and running via docker, we will run an NLP task 
aimed at identifying which glioma-variables notes are related to. This 
will reduce the amount of notes we process for each task. 

Note that the `--task` argument specifies which model configuration is being used. 
As sites change their LLM models to support their available infrastructure, 
this task will need to reference the appropriate model.

### 3.a. Doctype identification against peri-/post-operative notes
```sh
docker compose run --rm -it\
  cumulus-etl nlp \
  --task glioma__nlp_document_type_gpt_oss_120b \
  <input folder with ndjson files from step 2 above> \
  <your typical ETL PHI folder> \
  <your typical ETL OUTPUT folder> \
  --athena-database <relevant_cumulus_library_database> \
  --athena-workgroup <relevant_cumulus_library_workgroup> \
  --select-by-athena-table glioma__sample_casedef_peri_post_limit_patient_10
```

Note: by running with `-it` we can trigger an interactive run of docker compose, which 
allows us to take advantage of the `cumulus-etl nlp`'s support for verifying the number of notes 
that will be processed with NLP before starting a run. This can be useful in ensuring that you 
don't spend a lot of money/time running NLP on an unintentionally large selection of notes.

Importantly: re-run your [Cumulus AWS Glue crawler](https://docs.smarthealthit.org/cumulus/etl/setup/#create-tables-with-glue) 
at this point in order to pick up the newly created NLP tables and their schemas. 

Note that as you run these tasks against _new models_, you will need to run this 
crawler again (though only for the first time)

## 4. Building task-specific tables of note samples.

This next step is incredibly manual at the moment, but in future iterations will 
be better integrated into separate runs of the `glioma` library study. 

TODO: Figure out these instructions for sites 