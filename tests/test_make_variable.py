import unittest
from cumulus_library_glioma.tools import study_variable

class TestMakeVariable(unittest.TestCase):

    def test(self):
        print(make_variable.list_valueset_vsac())
        print(make_variable.list_valueset_uploads())

    def test_make_union(self):
        _str = make_variable.make_union()
        print(_str)