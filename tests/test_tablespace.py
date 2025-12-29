import unittest
from cumulus_library_glioma.tools import tablespace
from cumulus_library_glioma.tools.tablespace import (
    Reference,
    get_reference,
    name_trim
)

class TestTablespace(unittest.TestCase):

    def test_reference(self):
        self.assertEqual(Reference.dx, get_reference('dx_brain_tumor'))
        self.assertEqual(Reference.lab, get_reference('lab_pathology'))
        self.assertEqual(Reference.obs, get_reference('obs_abnormal'))

        self.assertEqual(Reference.diag, get_reference('valueset_diag_pathology'))
        self.assertEqual(Reference.rx, get_reference('glioma__cohort_rx_chemo_platinum'))
        self.assertEqual(Reference.obs, get_reference('valueset_obs_abnormal'))
        self.assertEqual(Reference.lab, get_reference('valueset_lab_pathology'))
        self.assertEqual(Reference.diag, get_reference('valueset_diag_pathology'))

    def test_name_trim(self):
        self.assertEqual('diag_pathology', name_trim('glioma__valueset_diag_pathology'))
        self.assertEqual('diag_pathology', name_trim('valueset_diag_pathology'))
        self.assertEqual('diag_pathology', name_trim('diag_pathology'))



