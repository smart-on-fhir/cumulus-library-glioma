import unittest
from cumulus_library.builders.counts import CountsBuilder
from cumulus_library_glioma.tools import manifest, filetool

class TestManifest(unittest.TestCase):
    def test_manifest_exists(self):
        self.assertTrue(filetool.path_project('manifest.toml').exists())

    def test_manifest_loads_with_study_prefix(self):
        self.assertEqual('glioma', manifest.get_manifest().get_study_prefix())

    def test_counts_builder(self):
        builder = CountsBuilder(manifest=manifest.get_manifest())
        self.assertEqual('glioma', builder.study_prefix)

