from enum import StrEnum
from typing import Optional, List
from pydantic import BaseModel, Field
from .mention import SpanAugmentedMention
from .diagnosis import (
    AgeAtDiagnosisMention,
    TumorLocationMention,
    TumorSizeMassEffectMention,
    HistologyMention,
    NF1StatusMention
)
from .genes import MolecularDriverMention
from .surgery import (SurgicalExtentOfResection)
from .drug_request import TreatmentToxicityMention
from .progression import (
    AgeAtProgressionMention,
    ProgressionTypeMention,
    VisualAcuityMention,
    NeurocognitiveRiskMention,
    EndocrineFunctionMention,
    SymptomBurdenMention,
    PriorTherapyExposureMention,
    RadiotherapyExposureHistoryMention,
    RegrowthPatternMention,
    ClinicalTrialAvailabilityMention
)


# ----------------------------
# Top-level extraction object
# ----------------------------
class PLGGClinicalDecisionVariables(BaseModel):
    """
    Extraction container for pLGG clinical decision variables from a note/document.
    Each field is SpanAugmentedMention-derived and captures both structured value(s)
    and supporting text spans.
    """
    age_at_diagnosis: AgeAtDiagnosisMention = Field(default_factory=AgeAtDiagnosisMention)

    tumor_location: TumorLocationMention = Field(default_factory=TumorLocationMention)
    tumor_size_mass_effect: TumorSizeMassEffectMention = Field(default_factory=TumorSizeMassEffectMention)

    symptom_burden: SymptomBurdenMention = Field(default_factory=SymptomBurdenMention)
    nf1_status: NF1StatusMention = Field(default_factory=NF1StatusMention)

    extent_of_resection: SurgicalExtentOfResection = Field(default_factory=SurgicalExtentOfResection)
    histology: HistologyMention = Field(default_factory=HistologyMention)
    molecular_driver: MolecularDriverMention = Field(default_factory=MolecularDriverMention)

    progression_type: ProgressionTypeMention = Field(default_factory=ProgressionTypeMention)

    visual_acuity: VisualAcuityMention = Field(default_factory=VisualAcuityMention)
    endocrine_function: EndocrineFunctionMention = Field(default_factory=EndocrineFunctionMention)

    prior_therapy_exposure: PriorTherapyExposureMention = Field(default_factory=PriorTherapyExposureMention)
    treatment_toxicity: TreatmentToxicityMention = Field(default_factory=TreatmentToxicityMention)

    regrowth_pattern: RegrowthPatternMention = Field(default_factory=RegrowthPatternMention)

    age_at_progression: AgeAtProgressionMention = Field(default_factory=AgeAtProgressionMention)
    radiotherapy_exposure_history: RadiotherapyExposureHistoryMention = Field(default_factory=RadiotherapyExposureHistoryMention)

    neurocognitive_risk: NeurocognitiveRiskMention = Field(default_factory=NeurocognitiveRiskMention)
    clinical_trial_availability: ClinicalTrialAvailabilityMention = Field(default_factory=ClinicalTrialAvailabilityMention)
