from typing import List
from pathlib import Path
from fhirclient.models.coding import Coding
from cumulus_library_glioma.tools import filetool

UMLS_VOCAB = {
    "SNOMEDCT_US": "http://snomed.info/sct",
    "ICD10CM": "http://hl7.org/fhir/sid/icd-10-cm",
    "ICD9CM":  "http://hl7.org/fhir/sid/icd-9-cm",
    "RXNORM": "http://www.nlm.nih.gov/research/umls/rxnorm"
}

def list_coding(valueset_json: dict) -> List[Coding]:
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

def list_coding_expansion(valueset_json: dict) -> List[Coding]:
    contains = valueset_json.get('expansion').get('contains')
    return [Coding(c) for c in contains]

def escape_string(value: str) -> str:
    """
    :return: str special chars removed like tic('), quote("), semi(;), and tab(\t)
    """
    for token in ['"', "'", ";", "\t"]:
        value = value.replace(token, "")
    return value

def coding_to_tsv(codelist: List[Coding]) -> str:
    header = f"system\tcode\tdisplay"
    row = list()
    for concept in codelist:
        safe_display = escape_string(concept.display)
        row.append(f'{concept.system}\t{concept.code}\t{safe_display}')
    row = '\n'.join(row)
    return header + '\n' + row + '\n'

def json_to_tsv(valueset_json: Path) -> Path:
    file_tsv = valueset_json.with_name(valueset_json.name + '.valueset.tsv')
    valueset_json = filetool.load_valueset(valueset_json)
    coding_list = list()
    if isinstance(valueset_json, list):
        for entry in valueset_json:
            coding_list+= list_coding_expansion(entry)
    else:
        coding_list = list_coding(valueset_json)
    return Path(filetool.write_text(coding_to_tsv(coding_list), file_tsv))

###############################################################################
# Make
###############################################################################
def make() -> list[Path]:
    return [json_to_tsv(valueset_json) for valueset_json in filetool.list_valueset('*.json')]

if __name__ == '__main__':
    target_files = make()
    print(target_files)
