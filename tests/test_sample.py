import unittest
from pathlib import Path
import pandas as pd
from cumulus_library_glioma.tools import filetool, tablespace, manifest
from cumulus_library_glioma.llm.pydantic_schema.document_type import (
    DocumentType
)

class TestSample(unittest.TestCase):
    def test_file_exists(self):
        self.assertTrue(filetool.path_resources('llm_document_types.csv'))
