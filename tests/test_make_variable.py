import unittest
from cumulus_library_glioma.tools import make_variable

class TestMakeVariable(unittest.TestCase):

    def test(self):
        print(make_variable.list_valueset_vsac())
        print(make_variable.list_valueset_uploads())

