import unittest
from tests import casedef_rx_variables
from tests.casedef_rx_variables import (
    RX_MISSING_LIST,
    RX_DRUG_LIST,
    RX_BRAND_NAMES
)

class TestIssue26_CaseDefRxVariables(unittest.TestCase):
    """
    https://github.com/smart-on-fhir/cumulus-library-glioma/issues/26
    "crosscheck / validate" that the drug list creation process is not missing any drugs that we expect.
    HUMAN process assisted by this script.

    FINAL REVIEW:
        select * from glioma__issue26_missing_drugs
        where code not in (select code from glioma__valueset_casedef_rx)
        order by code
    """
    def test(self):
        merged = RX_MISSING_LIST + RX_DRUG_LIST + RX_BRAND_NAMES
        merged = set([drug.lower() for drug in merged])
        sql = casedef_rx_variables.select_drug_list(merged)

        print('##############################################################')
        print('glioma__issue26_missing_drugs')
        print(sql)
        print('##############################################################')


