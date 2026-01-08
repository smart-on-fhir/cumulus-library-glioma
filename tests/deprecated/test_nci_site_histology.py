import unittest
import pandas as pd
from cumulus_library_glioma.tools import filetool

def titlecase_cell(x):
    if isinstance(x, str):
        return x.title()
    return x

class TestCancerSiteHistology(unittest.TestCase):

    def ignore_test_title(self):
        df = pd.read_csv(filetool.path_resources('nci_site_histology.csv'))
        df = df.applymap(titlecase_cell)
        df.to_csv('nci_site_histology.csv', index=False)

    def test(self):
        source = filetool.path_resources('nci_site_histology.csv')
        target = filetool.path_resources('nci_site_histology_with_split.csv')

        df = pd.read_csv(source)

        # Split morphology into histology and behavior
        df[["histology_code", "behavior_code"]] = df["morphology_code"].str.split("/", expand=True)

        # Optional: enforce string dtype (useful for leading zeros)
        df["histology_code"] = df["histology_code"].astype("string")
        df["behavior_code"] = df["behavior_code"].astype("string")

        ordered_cols = [
            "site",
            "histology_cat",
            "histology_cat_display",
            "histology_code",
            "behavior_code",
            "morphology_code",
            "morphology_display",
        ]
        df = df[ordered_cols]
        df.to_csv(target, index=False)



