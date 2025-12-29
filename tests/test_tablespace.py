import unittest
from cumulus_library_glioma.tools import tablespace
from cumulus_library_glioma.tools.tablespace import Reference, get_reference

class TestTablespace(unittest.TestCase):
    def test_naming(self):
        self.assertEqual(Reference.obs, get_reference('obs_abnormal'))
        self.assertEqual(Reference.dx, get_reference('dx_brain_tumor'))
        self.assertEqual(Reference.rx, get_reference('glioma__cohort_rx_chemo_platinum'))
        self.assertEqual(Reference.lab, get_reference('lab_pathology'))
        # self.assertEqual(Reference.lab, get_reference('valueset_lab_pathology'))
        # self.assertEqual(Reference.diag, get_reference('valueset_diag_pathology'))


