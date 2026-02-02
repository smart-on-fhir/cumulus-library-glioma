#------------------------------------------------------------------------------
#
# NOTICE: this file is for human-expert-review of
# study builder medication outputs. It is used to verify/assist updating the
# glioma_casedef_rx.csv
#
#------------------------------------------------------------------------------
# Relates to Issue(s):
# https://github.com/smart-on-fhir/cumulus-library-glioma/issues/26
# "many Glioma cases have no known cancer therapy"
#------------------------------------------------------------------------------

RX_MISSING_LIST = [
    'avastin',
    'carboplatin',
    'cyclophosphamide',
    'dabrafenib',
    'dactinomycin',
    'doxorubicin',
    'etoposide',
    'everolimus',
    'lomustine',
    'procarbazine',
    'temozolomide',
    'thalidomide',
    'trametinib']

#-----------------------------------------------------------------------------
# Chemotherapy
Platinum = ['carboplatin',
            'carboplat',
            'paraplatin'
            'cisplatin']
Vinca = ['vinblastine','vincristine']
Alkylating = [
    "cyclophosphamide",
    "cytoxan",
    "ifosfamide",
    "lomustine",
    "carmustine",
    "temozolomide",
    'procarbazine']
Topoisomerase = [
    "irinotecan",
    "topotecan",
    "etoposide",
    "teniposide"]

RX_CHEMO = Platinum + Vinca + Alkylating + Topoisomerase

#-----------------------------------------------------------------------------
# Targeted molecular therapy
MEK = ["trametinib", 'selumetinib']
NTRK = ["larotrectinib","Vitrakvi","entrectinib"]
PanRAF = ["tovorafenib","DAY101"]
ROS1 = ["crizotinib", "entrectinib", "lorlatinib"]
FGFR = [
    "erdafitinib",
    "futibatinib",
    "infigratinib",
    "pemigatinib",
    "ponatinib"]
IDH = [
    "ivosidenib",
    "vorasidenib",
    "enasidenib"]
Everolimus = [
    'Everolimus',
    'Certican',
    'Zortress',
    'Afinitor',
    'Votubia',
    'RAD001',
    'Torpenz']
Sirolimus = [
    'Sirolimus',
    'Rapamune',
    'Rapamycin']

RX_TARGET_MOLECULAR = MEK + NTRK + PanRAF + IDH + Everolimus + Sirolimus

#-----------------------------------------------------------------------------
# Anti-Metabolites
Thioguanine = ['thioguanine', 'tioguanine', 'tabloid']

Mycophenolate = ['Mycophenolate',
                 'MMF',
                 'CellCept',
                 'Myfortic']

RX_ANTIMET = Thioguanine + Mycophenolate

#-----------------------------------------------------------------------------
# Monoclonal antibodies
RX_MAB = [
    "bevacizumab",
    "avastin",
    "nivolumab",
    "pembrolizumab",
    "alemtuzumab",
    "basiliximab"]

#
RX_BRAND_NAMES = [
    'afinitor',
    'alymsys',
    'avastin',
    'avzivi',
    'camptosar',
    'gleostine',
    'jobevne',
    'koselugo',
    'marqibo',
    'matulane',
    'mekinist',
    'mvasi',
    'ojemda',
    'oncovin',
    'paraplatin',
    'rapamune',
    'rozlytrek',
    'tafinlar',
    'temodar',
    'vegzelma',
    'velban',
    'vincasar',
    'vitrakvi',
    'xalkori',
    'zelboraf',
    'zirabev']

##############################################################################
# DRUG LIST
##############################################################################
RX_DRUG_LIST = RX_CHEMO + RX_TARGET_MOLECULAR + RX_ANTIMET + RX_MAB

###############################################################################
#
# helper functions
#
###############################################################################
def str_like(keywords) -> str:
    if isinstance(keywords, list):
        where = list()
        for token in keywords:
            where.append(f"lower(str) like lower('%{token}%')")
        return '\nOR '.join(where)
    else:
        return f"lower(str) like lower('%{keywords}%')"

def select_code_display(drug, sab='RXNORM') -> str:
    partition  = 'row_number() over (partition by code order by length(str), str) as rn'
    source = 'umls.MRCONSO_drugs'
    where = f" SAB='{sab}' and \n ( {str_like(drug)})"
    return f"{drug} AS ( select code, str as display, {partition} from {source} where {where})"

def select_drug_list(drug_list) -> str:
    """
    :param drug_list: list of drugs to lookup
    :return: sql to find the drugs in UMLS (rxnorm)
    """
    create = 'create or replace view glioma__issue26_missing_drugs'
    RXNORM = 'http://www.nlm.nih.gov/research/umls/rxnorm'
    select = [select_code_display(drug) for drug in drug_list]
    select = ',\n'.join(select)
    merged = [f"\tselect code, display FROM {drug} WHERE rn = 1" for drug in drug_list]
    merged = '\nUNION ALL'.join(merged)
    return (f"{create} AS WITH\n "
            f"{select}, "
            f"\nmerged as (\n{merged}\n) \n"
            f"select '{RXNORM}' as system,code,display "
            f"from merged order by code,display")

def human_expert_verify():
    merged = RX_MISSING_LIST + RX_DRUG_LIST + RX_BRAND_NAMES
    merged = set([drug.lower() for drug in merged])

    print('##############################################################')
    print('MERGED drug list')
    print()
    print(merged)
    print('##############################################################')

    sql = select_drug_list(merged)

    print('##############################################################')
    print('glioma__issue26_missing_drugs')
    print(sql)
    print('##############################################################')


if __name__ == '__main__':
    human_expert_verify()