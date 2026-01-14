import unittest
from cumulus_library_glioma.tools import filetool

class TestFiletool(unittest.TestCase):

    def test_paths_exist(self):
        self.assertTrue(filetool.path_project().exists())
        self.assertTrue(filetool.path_resources('valueset_casedef.csv').exists())
        self.assertTrue(filetool.path_valueset('dx_neuro.json').exists())
        self.assertTrue(filetool.path_athena('glioma__cohort_casedef.sql').exists())
        self.assertTrue(filetool.path_template('cohort_study_period.sql').exists())

    def test_template_prefix(self):
        text = filetool.load_template('sample_casedef_temporality.sql')
        self.assertFalse('$prefix' in text)
        self.assertTrue('$temporality' in text)

    def test_template_optional_replacement(self):
        text = filetool.load_template('sample_casedef_temporality.sql', replacements={'$temporality': 'pre'})
        self.assertFalse('$temporality' in text)
        self.assertFalse('$prefix' in text)
        self.assertTrue('glioma__sample_casedef_pre' in text)
