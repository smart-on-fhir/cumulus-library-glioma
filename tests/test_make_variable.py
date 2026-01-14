import unittest
from cumulus_library_glioma.tools import study_variable

class TestMakeVariable(unittest.TestCase):

    def test(self):
        print(study_variable.list_valueset_vsac())
        print(study_variable.list_valueset_uploads())

    def test_make_union(self):
        _str = study_variable.make_union()
        print(_str)