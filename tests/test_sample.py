import unittest
from cumulus_library_glioma.tools import filetool

class TestSample(unittest.TestCase):
    def test_file_exists(self):
        self.assertTrue(filetool.path_resources('llm_document_types.csv'))
