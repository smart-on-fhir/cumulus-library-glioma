import unittest
from cumulus_library import StudyManifest

class TestStudyPrefix(unittest.TestCase):
    def test(self):
        self.assertEqual('glioma', StudyManifest().get_study_prefix())
