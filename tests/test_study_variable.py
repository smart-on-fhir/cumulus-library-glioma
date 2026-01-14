import unittest
from cumulus_library_glioma.tools import study_variable, filetool

class TestMakeVariable(unittest.TestCase):

    def test_valueset_variables(self):

        variable_names = study_variable.list_valueset_variable_names()
        self.assertTrue('dx_neuropathy' in variable_names)
        self.assertFalse('casedef' in variable_names)
        self.assertFalse('valueset_casedef' in variable_names)

    def test_resources(self):
        resource_files = study_variable.list_valueset_resources()
        resource_names = [filetool.file_to_variable(f) for f in resource_files]
        print(resource_names)
        self.assertFalse('dx_neuropathy' in resource_names)
        self.assertTrue('casedef' in resource_names)
