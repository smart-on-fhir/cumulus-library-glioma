from enum import StrEnum
from pydantic import BaseModel, Field
from .mention import SpanAugmentedMention
from .drug_attributes import (
    RxStatusMention,
    RxTreatmentPhaseMention
)
from .drug_response import (
    RxResponseMention,
    RxDiscontinuedMention,
    RxToxicitySeverityMention
)

###############################################################################
# Glioma Targeted Therapy
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
        GliomaTargetedTherapy.NOT_MENTIONED,
        description="Glioma targeted therapy"
    )

    status: RxStatusMention = Field(
        RxStatusMention.NOT_MENTIONED,
        description="Glioma targeted therapy status (active/completed/stopped/etc)"
    )
    treatment_phase: RxTreatmentPhaseMention = Field(
        RxTreatmentPhaseMention.NOT_MENTIONED,
        description="Glioma targeted therapy treatment phase"
    )

    treatment_response: RxResponseMention = Field(
        RxResponseMention.NOT_MENTIONED,
        description="What was the glioma targeted therapy treatment response?"
    )

    treatment_discontinued: RxDiscontinuedMention = Field(
        RxDiscontinuedMention.NOT_MENTIONED,
        description="Was glioma targeted therapy discontinued, and why?"
    )

    toxicity_severity: RxToxicitySeverityMention = Field(
        RxToxicitySeverityMention.NOT_MENTIONED,
        description="What was the toxicity severity of glioma targeted therapy?"
    )


###############################################################################
# Glioma Targeted Therapy --> Annotation BaseModel
###############################################################################
class GliomaTargetedTherapyAnnotation(BaseModel):
    targeted_therapy: list[GliomaTargetedTherapyMention] = Field(
        default_factory=list,
        description="All mentions of glioma targeted therapy"
    )

###############################################################################
# Glioma Traditional Chemotherapy
###############################################################################
class GliomaChemotherapyClass(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    ALKYLATING_AGENT = "ALKYLATING_AGENT"          # e.g., temozolomide, lomustine (protocol-dependent)
    PLATINUM_AGENT = "PLATINUM_AGENT"              # e.g., carboplatin, cisplatin
    VINCA_ALKALOID = "VINCA_ALKALOID"              # e.g., vincristine, vinblastine
    TOP1_INHIBITOR = "TOP1_INHIBITOR"              # e.g., irinotecan
    ANTIMETABOLITE = "ANTIMETABOLITE"              # e.g., methotrexate (less common, context-dependent)
    MULTI_AGENT_CHEMOTHERAPY = "MULTI_AGENT_CHEMOTHERAPY"  # protocol bundle when class not decomposed
    OTHER = "OTHER"

class GliomaChemotherapyRegimen(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    CARBOPLATIN = "CARBOPLATIN"
    CARBOPLATIN_VINCRISTINE = "CARBOPLATIN_VINCRISTINE"
    VINBLASTINE = "VINBLASTINE"
    TPCV = "TPCV"  # thioguanine/procarbazine/CCNU/vincristine (legacy)
    BEVACIZUMAB_IRINOTECAN = "BEVACIZUMAB_IRINOTECAN"
    BEVACIZUMAB = "BEVACIZUMAB"
    OTHER = "OTHER"

class GliomaChemotherapyMention(SpanAugmentedMention):
    chemotherapy_class: GliomaChemotherapyClass = Field(
        GliomaChemotherapyClass.NOT_MENTIONED,
        description="Glioma chemotherapy drug class"
    )

    chemotherapy_regimen: GliomaChemotherapyRegimen = Field(
        GliomaChemotherapyRegimen.NOT_MENTIONED,
        description="Glioma chemotherapy regimen"
    )

    status: RxStatusMention = Field(
        RxStatusMention.NOT_MENTIONED,
        description="Glioma chemotherapy status (active/completed/stopped/etc)"
    )

    treatment_phase: RxTreatmentPhaseMention = Field(
        RxTreatmentPhaseMention.NOT_MENTIONED,
        description="Glioma chemotherapy treatment phase"
    )

    treatment_response: RxResponseMention = Field(
        RxResponseMention.NOT_MENTIONED,
        description="What was the glioma chemotherapy response?"
    )

    toxicity_severity: RxToxicitySeverityMention = Field(
        RxToxicitySeverityMention.NOT_MENTIONED,
        description="What was the toxicity severity of glioma chemotherapy?"
    )

    treatment_discontinued: RxDiscontinuedMention = Field(
        RxDiscontinuedMention.NOT_MENTIONED,
        description="Was glioma chemotherapy discontinued?"
    )

###############################################################################
# Glioma Traditional Chemotherapy --> Annotation BaseModel
###############################################################################
class GliomaChemotherapyAnnotation(BaseModel):
    chemotherapy: list[GliomaChemotherapyMention] = Field(
        default_factory=list,
        description="All mentions of pLGG chemotherapy"
    )

