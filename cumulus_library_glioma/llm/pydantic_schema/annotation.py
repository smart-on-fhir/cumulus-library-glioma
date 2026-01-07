from pydantic import BaseModel, Field
from .diagnosis import GliomaDiagnosisMention
from .genes import MolecularDriverMention, GeneticVariantMention
from .drug_glioma import GliomaDrugMention
from .surgery import SurgeryMention

class GliomaCaseAnnotation(BaseModel):
    """
    SCHEMA root of Glioma Case Annotation
    """
    glioma_diagnosis: GliomaDiagnosisMention = Field(
        default_factory=list,
        description="Glioma diagnosis (Age at diagnosis, tumor, location, size, morphology, etc)"
    )

    molecular_driver: list[MolecularDriverMention] = Field(
        default_factory=list,
        description="All mentions of molecular drivers of glioma."
    )

    variant: list[GeneticVariantMention] = Field(
        default_factory=list,
        description="All mentions of genetic variants."
    )

    glioma_drug: list[GliomaDrugMention] = Field(
        default_factory=list,
        description="All mentions of cancer drugs."
    )

    surgery: list[SurgeryMention] = Field(
        default_factory=list,
        description="All mentions of cancer related surgeries."
    )

