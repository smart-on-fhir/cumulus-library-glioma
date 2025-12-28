import unittest
import pandas as pd
from pathlib import Path
from cumulus_library_glioma.tools import filetool
from cumulus_library_glioma.tools.valueset import UMLS_VOCAB

def make_valueset_morphology()-> Path:
    file_in = filetool.path_resources('umls_morphology.bsv')
    file_out = filetool.path_resources('valueset_morphology.csv')
    return umls_to_fhir(file_in, file_out, UMLS_VOCAB)

def make_valueset_topography()-> Path:
    file_in = filetool.path_resources('umls_topography.bsv')
    file_out = filetool.path_resources('valueset_topography.csv')
    return umls_to_fhir(file_in, file_out, UMLS_VOCAB)

def umls_to_fhir(file_in:Path, file_out:Path, umls_vocab:dict)-> Path:
    df = pd.read_csv(file_in, sep="|", dtype=str)
    df = df[df["SAB"].isin(umls_vocab.keys())]
    df["SAB"] = df["SAB"].replace(UMLS_VOCAB)
    df_out = df[["SAB", "CODE", "PREF"]]
    df_out = df_out.drop_duplicates()
    df_out = df_out.sort_values(["SAB", "CODE"], ascending=[True, True])
    df_out.to_csv(file_out, header=False, index=False)
    return file_out

class TestUMLS(unittest.TestCase):
    def test(self):
        make_valueset_topography()
        make_valueset_morphology()
