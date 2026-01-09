import unittest
from cumulus_library_glioma.tools import filetool

class TestFiletool(unittest.TestCase):

    def test_paths_exist(self):
        self.assertTrue(filetool.path_project().exists())
        self.assertTrue(filetool.path_resources('valueset_casedef.csv').exists())
        self.assertTrue(filetool.path_valueset('dx_neuro.json').exists())
        self.assertTrue(filetool.path_athena('glioma__cohort_casedef.sql').exists())
        self.assertTrue(filetool.path_template('cohort_study_period.sql').exists())

