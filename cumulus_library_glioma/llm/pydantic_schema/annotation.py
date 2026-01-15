import json
import os

from pydantic import BaseModel, Field
from cumulus_library_glioma.llm.pydantic_schema.pathology import (
    TopographyMention,
    MorphologyMention,
    GradeMention,
    BehaviorMention,
)
from cumulus_library_glioma.llm.pydantic_schema.genes import (
    TargetGeneticTestMention,
    VariantMention,
)
from cumulus_library_glioma.llm.pydantic_schema.drugs import CancerMedicationMention
from cumulus_library_glioma.llm.pydantic_schema.surgery import SurgeryMention


class GliomaCaseAnnotation(BaseModel):
    """
    SCHEMA root of Glioma Case Annotation
    """

    topography_mention: TopographyMention
    morphology_mention: MorphologyMention
    behavior_mention: BehaviorMention
    grade_mention: GradeMention
    target_genetic_test_mention: list[TargetGeneticTestMention] = Field(
        default_factory=list, description="All mentions of Target Genetic Tests."
    )
    variant_mention: list[VariantMention] = Field(
        default_factory=list, description="All mentions of Genetic Variants."
    )
    cancer_medication_mention: list[CancerMedicationMention] = Field(
        default_factory=list, description="All mentions of Cancer Medications."
    )
    surgery_mention: list[SurgeryMention] = Field(
        default_factory=list, description="All mentions of Cancer related surgeries."
    )


if __name__ == "__main__":
    basedir = os.path.dirname(__file__)

    with open(f"{basedir}/case.json", "w", encoding="utf8") as f:
        json.dump(GliomaCaseAnnotation.model_json_schema(), f, indent=2)
