from enum import Enum, StrEnum
from pathlib import Path
from fhirclient.models.coding import Coding
from cumulus_library import StudyManifest
from cumulus_library.apis import umls
from cumulus_library_glioma.tools import filetool, manifest

###############################################################################
# DEPRECATED NOTICE
#
# This VSAC helper tool will be replaced in future cumulus-library version
# https://github.com/smart-on-fhir/cumulus-library/issues/440
#
###############################################################################

UMLS_VOCAB = {
    "SNOMEDCT_US": "http://snomed.info/sct",
    "ICD10CM": "http://hl7.org/fhir/sid/icd-10-cm",
    "ICD9CM":  "http://hl7.org/fhir/sid/icd-9-cm",
    "RXNORM": "http://www.nlm.nih.gov/research/umls/rxnorm",
    "ObservationInterpretation": "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation"
}

class DxValueset(StrEnum):
    dx_brain_tumor = "2.16.840.1.113883.17.4077.3.1011"
    dx_cancer = "2.16.840.1.113883.3.526.3.1010"
    dx_focal_deficit = "2.16.840.1.113883.17.4077.3.1033"
    dx_neuro = "2.16.840.1.113762.1.4.1182.309"
    dx_neuropathy = "2.16.840.1.113762.1.4.1222.1518"
    dx_endo_diabetes = "2.16.840.1.113883.3.464.1003.103.12.1001"
    diag_brain_mri="2.16.840.1.113762.1.4.1222.922"
    diag_head_neck="2.16.840.1.113762.1.4.1222.921"
    diag_radiology='2.16.840.1.113762.1.4.1267.18'
    proc_neurosurgery="2.16.840.1.113883.3.117.1.7.1.260"
    # lab_gene_test="2.16.840.1.113883.3.1434.1000.1060"
    # lab_gene_braf="2.16.840.1.113883.3.1444.3.288"
    # lab_gene_ntrk="2.16.840.1.113883.3.1444.3.287"
    # lab_gene_alk="2.16.840.1.113762.1.4.1260.258"
    # lab_gene_ros1="2.16.840.1.113883.3.1444.3.286"
    # lab_gene_ret="2.16.840.1.113883.3.1444.3.290"
    # obs_abnormal="2.16.840.1.113762.1.4.1146.295"
    # obs_low="2.16.840.1.113762.1.4.1146.2019"
    # obs_high="2.16.840.1.113762.1.4.1146.2018"

def list_coding(valueset_json: dict) -> list[Coding]:
    """
    Obtain a list of Coding "concepts" from a ValueSet.
    This method currently supports only "include" of "concept" defined fields.
    Not supported: recursive fetching of contained ValueSets, which requires UMLS API Key and Wget, etc.

    examples
    https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1146.1629/expansion/Latest
    https://cts.nlm.nih.gov/fhir/res/ValueSet/2.16.840.1.113762.1.4.1146.1629?_format=json

    :param valueset_json: ValueSet file, expecially those provided by NLM/ONC/VSAC
    :return: list of codeable concepts (system, code, display) to include
    """
    compose = list()
    for include in valueset_json['compose']['include']:
        if 'concept' in include.keys():
            for concept in include['concept']:
                concept['system'] = include['system']
                compose.append(Coding(concept))
    return compose

def list_coding_expansion(valueset_json: dict) -> list[Coding]:
    contains = valueset_json.get('expansion').get('contains')
    return [Coding(c) for c in contains]

def escape_string(value: str) -> str:
    """
    :return: str special chars removed like tic('), quote("), semi(;), and tab(\t)
    """
    for token in ['"', "'", ";", "\t"]:
        value = value.replace(token, "")
    return value

def coding_to_tsv(codelist: list[Coding]) -> str:
    _system = codelist[0].system
    header = '\n'.join([f"system\tcode\tdisplay",
                        f"{_system}\tcode\tdisplay"])
    row = list()
    for concept in codelist:
        safe_display = escape_string(concept.display)
        row.append(f'{concept.system}\t{concept.code}\t{safe_display}')
    row = '\n'.join(row)
    return header + '\n' + row + '\n'

def json_to_tsv(valueset_json: Path) -> Path:
    file_tsv = str(valueset_json.stem) + '.tsv'
    print('json_to_tsv' , '-->', file_tsv)
    valueset_json = filetool.load_valueset(valueset_json)
    coding_list = list()
    if isinstance(valueset_json, list):
        for entry in valueset_json:
            coding_list+= list_coding_expansion(entry)
    else:
        coding_list = list_coding(valueset_json)
    return Path(filetool.write_text(coding_to_tsv(coding_list), filetool.path_resources(file_tsv)))

def download() -> list[Path]:
    api = umls.UmlsApi()
    targets = list()
    for valueset in DxValueset:
        print(valueset.name, '=', valueset.value)
        json_file = filetool.path_valueset(f"{valueset.name}.json")
        if not filetool.path_valueset(json_file).exists():
            json_res = api.get_vsac_valuesets(url= None, oid=valueset.value)
            filetool.write_json(json_res, json_file)
        targets.append(json_file)
    return targets

#-----------------------------------------------------------------------------
# Make
#-----------------------------------------------------------------------------
def make() -> list[Path]:
    return [json_to_tsv(valueset_json) for valueset_json in download()]

if __name__ == '__main__':
    target_files = make()
    print(manifest.as_toml_valuesets(target_files))
