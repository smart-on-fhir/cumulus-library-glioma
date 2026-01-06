from enum import StrEnum
from pydantic import BaseModel, Field, Optional
from .mention import SpanAugmentedMention

###############################################################################
# Glioma Drug RxClass
###############################################################################
class GliomaTargetedTherapy(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    MEK_INHIBITOR = "MEK_INHIBITOR"
    BRAF_INHIBITOR = "BRAF_INHIBITOR"
    BRAF_MEK_COMBINATION = "BRAF_MEK_COMBINATION"
    PAN_RAF_INHIBITOR = "PAN_RAF_INHIBITOR"
    FGFR_INHIBITOR = "FGFR_INHIBITOR"
    NTRK_INHIBITOR = "NTRK_INHIBITOR"
    ALK_INHIBITOR = "ALK_INHIBITOR"
    ROS1_INHIBITOR = "ROS1_INHIBITOR"
    RET_INHIBITOR = "RET_INHIBITOR"
    MTOR_INHIBITOR = "MTOR_INHIBITOR"
    IDH_INHIBITOR = "IDH_INHIBITOR"
    OTHER = "OTHER"

class GliomaTargetedTherapyMention(SpanAugmentedMention):
    targeted_therapy: GliomaTargetedTherapy = Field(
        default=GliomaTargetedTherapy.NOT_MENTIONED,
        description='Glioma targeted therapy class'
    )

class RxClassChemotherapy(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    ALKYLATING_AGENT = "ALKYLATING_AGENT"          # e.g., temozolomide, lomustine (protocol-dependent)
    PLATINUM_AGENT = "PLATINUM_AGENT"              # e.g., carboplatin, cisplatin
    VINCA_ALKALOID = "VINCA_ALKALOID"              # e.g., vincristine, vinblastine
    TOP1_INHIBITOR = "TOP1_INHIBITOR"              # e.g., irinotecan
    ANTIMETABOLITE = "ANTIMETABOLITE"              # e.g., methotrexate (less common, context-dependent)
    MULTI_AGENT_CHEMOTHERAPY = "MULTI_AGENT_CHEMOTHERAPY"  # protocol bundle when class not decomposed
    OTHER = "OTHER"

###############################################################################
# Glioma Drug Chemo Regimen
###############################################################################
class RxRegimenChemotherapy(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    CARBOPLATIN_VINCRISTINE = "CARBOPLATIN_VINCRISTINE"
    VINBLASTINE = "VINBLASTINE"
    TPCV = "TPCV"  # thioguanine/procarbazine/CCNU/vincristine (legacy)
    OTHER = "OTHER"

###############################################################################
# Glioma Drug Class Mention
###############################################################################
class GliomaDrugMention(MedicationMention):

    rx_class_targeted: GliomaTargetedTherapy = Field(
        default=GliomaTargetedTherapy.NOT_MENTIONED,
        description='Glioma targeted therapy class'
    )

    rx_class_chemotherapy: RxClassChemotherapy = Field(
        default=RxClassChemotherapy.NOT_MENTIONED,
        description='Glioma chemotherapy class'
    )

    rx_regimen_chemotherapy: RxRegimenChemotherapy = Field(
        default=RxRegimenChemotherapy.NOT_MENTIONED,
        description='Glioma chemotherapy regimen'
    )

    rx_toxicity: ToxicitySeverity = Field(
        default=ToxicitySeverity.NOT_MENTIONED,
        description='Glioma therapeutic drug Toxicity severity'
    )

