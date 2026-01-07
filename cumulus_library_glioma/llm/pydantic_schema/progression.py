from enum import StrEnum
from pydantic import BaseModel, Field, Optional
from .mention import SpanAugmentedMention, YesNoUnknown
from .drug_response import RxResponseMention

###############################################################################
# Age at Progression
###############################################################################
class AgeAtProgressionMention(SpanAugmentedMention):
    age_years: Optional[float] = Field(
        None,
        description="Age at glioma disease progression in years, if explicitly stated."
    )

###############################################################################
# Progression Type
###############################################################################
class ProgressionType(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    BOTH = "BOTH FUNCTIONAL AND RADIOGRAPHIC"
    RADIOGRAPHIC = "RADIOGRAPHIC"
    FUNCTIONAL = "FUNCTIONAL"
    SUSPECTED = "SUSPECTED"
    NONE = "NONE"

class ProgressionTypeMention(SpanAugmentedMention):
    progression: ProgressionType = Field(
        ProgressionType.NOT_MENTIONED,
        description="Radiographic/functional progression status as stated."
    )

###############################################################################
# Regrowth of Tumor
###############################################################################
class RegrowthPattern(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    PROGRESSION = "PROGRESSION"
    REBOUND_AFTER_STOPPING_TARGETED = "REBOUND_AFTER_STOPPING_TARGETED"
    RESISTANCE_ON_TARGETED = "RESISTANCE_ON_TARGETED"
    PSEUDOPROGRESSION_SUSPECTED = "PSEUDOPROGRESSION_SUSPECTED"
    OTHER = "OTHER"

class RegrowthPatternMention(SpanAugmentedMention):
    regrowth_pattern: RegrowthPattern = Field(
        RegrowthPattern.NOT_MENTIONED,
        description="Pattern of regrowth on/off therapy (progression vs rebound vs resistance)."
    )

###############################################################################
# Symptom Burden
###############################################################################
class SymptomBurden(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    SEIZURES = "SEIZURES"
    HEADACHE = "HEADACHE"
    FOCAL_NEURO_DEFICIT = "FOCAL_NEURO_DEFICIT"
    VISUAL_SYMPTOMS = "VISUAL_SYMPTOMS"
    ENDOCRINE_SYMPTOMS = "ENDOCRINE_SYMPTOMS"
    INCREASED_ICP = "INCREASED_ICP"
    OTHER = "OTHER"

class SymptomBurdenMention(SpanAugmentedMention):
    symptom_burden: list[SymptomBurden] = Field(
        default_factory=list,
        description="Symptoms attributed to the tumor; may include multiple."
    )

###############################################################################
# Visual
###############################################################################
class VisualStatus(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    STABLE = "STABLE"
    DECLINING = "DECLINING"
    IMPROVING = "IMPROVING"
    SEVERE_LOSS = "SEVERE_LOSS"
    OTHER = "OTHER"

class VisualAcuityMention(SpanAugmentedMention):
    visual_status: VisualStatus = Field(
        VisualStatus.NOT_MENTIONED,
        description="Directionality of visual function over time."
    )

###############################################################################
# Cognitive Risk
###############################################################################
class NeurocognitiveRisk(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    LOW = "LOW"
    MODERATE = "MODERATE"
    HIGH = "HIGH"
    IMPAIRED_BASELINE = "IMPAIRED_BASELINE"
    OTHER = "OTHER"

class NeurocognitiveRiskMention(SpanAugmentedMention):
    risk: NeurocognitiveRisk = Field(
        NeurocognitiveRisk.NOT_MENTIONED,
        description="Neurocognitive risk/impairment cues (baseline or treatment-related)."
    )

###############################################################################
# Endocrine
###############################################################################
class EndocrineStatus(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    NORMAL = "NORMAL"
    DYSFUNCTION_PRESENT = "DYSFUNCTION_PRESENT"
    DIABETES_INSIPIDUS = "DIABETES_INSIPIDUS"
    PITUITARY_DEFICIENCY = "PITUITARY_DEFICIENCY"
    HYPOTHALAMIC_DYSFUNCTION = "HYPOTHALAMIC_DYSFUNCTION"
    OTHER = "OTHER"

class EndocrineFunctionMention(SpanAugmentedMention):
    endocrine_status: EndocrineStatus = Field(
        EndocrineStatus.NOT_MENTIONED,
        description="Endocrine function/dysfunction signals."
    )

###############################################################################
# Line of Therapy
###############################################################################
class TherapyLine(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    OBSERVATION = "OBSERVATION"
    SURGERY = "SURGERY"
    CHEMOTHERAPY = "CHEMOTHERAPY"
    TARGETED_THERAPY = "TARGETED_THERAPY"
    RADIOTHERAPY = "RADIOTHERAPY"
    CLINICAL_TRIAL = "CLINICAL_TRIAL"

class TherapyLineMention(SpanAugmentedMention):
    therapy_line: TherapyLine = Field(
        TherapyLine.NOT_MENTIONED,
        description="Line of therapy."
    )

###############################################################################
# Prior Therapy
###############################################################################
class PriorTherapyExposureMention(SpanAugmentedMention):
    prior_modalities: list[TherapyLine] = Field(
        default_factory=list,
        description="Previously received modalities (surgery/chemo/targeted/RT/trial)."
    )
    prior_chemo: list[RxRegimenChemotherapy] = Field(
        default_factory=list,
        description="Named prior chemotherapy regimens if stated."
    )
    prior_targeted: list[TargetedRegimen] = Field(
        default_factory=list,
        description="Named prior targeted regimens if stated."
    )

###############################################################################
# Clinical Trial Available
###############################################################################
class ClinicalTrialAvailability(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    AVAILABLE_AND_ELIGIBLE = "AVAILABLE_AND_ELIGIBLE"
    AVAILABLE_NOT_ELIGIBLE = "AVAILABLE_NOT_ELIGIBLE"
    NOT_AVAILABLE = "NOT_AVAILABLE"
    OTHER = "OTHER"

class ClinicalTrialAvailabilityMention(SpanAugmentedMention):
    trial_status: ClinicalTrialAvailability = Field(
        ClinicalTrialAvailability.NOT_MENTIONED,
        description="Whether a clinical trial is available/considered."
    )

class RadiotherapyExposureHistoryMention(SpanAugmentedMention):
    has_prior_radiotherapy: YesNoUnknown = Field(
        YesNoUnknown.NOT_MENTIONED,
        description="Whether patient has prior radiotherapy exposure."
    )
    rt_type_text: Optional[str] = Field(
        None,
        description="Free-text RT type (e.g., proton, photon) and/or dose/fractionation if stated."
    )

###############################################################################
# Clinical Trial Available
###############################################################################
class GliomaProgressionAnnotation(BaseModel):
    age_at_progression: AgeAtProgressionMention = Field(default_factory=AgeAtProgressionMention)
    progression_type: ProgressionTypeMention = Field(default_factory=ProgressionTypeMention)
    regrowth_pattern: RegrowthPatternMention = Field(default_factory=RegrowthPatternMention)
    symptom_burden: SymptomBurdenMention = Field(default_factory=SymptomBurdenMention)
    visual_status: VisualAcuityMention = Field(default_factory=VisualAcuityMention)
    neurocognitive_risk: NeurocognitiveRiskMention = Field(default_factory=NeurocognitiveRiskMention)
    endocrine_function: EndocrineFunctionMention = Field(default_factory=EndocrineFunctionMention)
    therapy_line: TherapyLine = Field(default_factory=TherapyLine)


