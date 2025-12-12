import csv
import unittest
import pandas as pd
from pathlib import Path
from cumulus_library_glioma.tools import filetool

UMLS_VOCAB = {"SNOMEDCT_US": "http://snomed.info/sct",
              "ICD10CM": "http://hl7.org/fhir/sid/icd-10-cm",
              "ICD9CM":  "http://hl7.org/fhir/sid/icd-9-cm"}

def make_valueset(file_in:Path, file_out:Path, umls_vocab:dict):
    df = pd.read_csv(file_in, sep="|", dtype=str)
    df = df[df["SAB"].isin(umls_vocab.keys())]
    df["SAB"] = df["SAB"].replace(UMLS_VOCAB)
    df_out = df[["SAB", "CODE", "PREF"]]
    df_out = df_out.drop_duplicates()
    df_out = df_out.sort_values(["SAB", "CODE"], ascending=[True, True])
    df_out.to_csv(file_out, header=False, index=False, quoting=csv.QUOTE_ALL)

def make_valueset_morphology():
    file_in = filetool.path_resources('umls_morphology.bsv')
    file_out = filetool.path_resources('valueset_morphology.csv')
    make_valueset(file_in, file_out, UMLS_VOCAB)

def make_valueset_topography():
    file_in = filetool.path_resources('umls_topography.bsv')
    file_out = filetool.path_resources('valueset_topography.csv')
    make_valueset(file_in, file_out, UMLS_VOCAB)

    # df = pd.read_csv(file_in, sep="|", dtype=str)
    # df = df[df["SAB"].isin(["SNOMEDCT_US", "ICD10CM", "ICD9CM"])]
    # df["SAB"] = df["SAB"].replace(UMLS_VOCAB)
    # df_out = df[["SAB", "CODE", "PREF"]]
    # df_out = df_out.sort_values(["SAB", "CODE"], ascending=[True, True])
    # df_out.to_csv(file_out, header=False, index=False, quoting=csv.QUOTE_ALL)

class TestMorphology(unittest.TestCase):
    def test(self):
        make_valueset_topography()
        make_valueset_morphology()


