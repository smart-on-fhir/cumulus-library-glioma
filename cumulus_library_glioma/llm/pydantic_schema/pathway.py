from enum import StrEnum
from typing import Optional, List
from pydantic import BaseModel, Field
from .mention import SpanAugmentedMention

class TumorLocation(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    CEREBELLUM = "CEREBELLUM"
    OPTIC_PATHWAY = "OPTIC_PATHWAY"
    HYPOTHALAMUS = "HYPOTHALAMUS"
    OPTIC_PATHWAY_HYPOTHALAMIC = "OPTIC_PATHWAY_HYPOTHALAMIC"
    THALAMUS = "THALAMUS"
    BRAINSTEM = "BRAINSTEM"
    CEREBRAL_HEMISPHERE = "CEREBRAL_HEMISPHERE"
    SPINAL = "SPINAL"
    OTHER = "OTHER"

class ExtentOfResection(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    GROSS_TOTAL = "GROSS_TOTAL"
    SUBTOTAL = "SUBTOTAL"
    PARTIAL = "PARTIAL"
    BIOPSY_ONLY = "BIOPSY_ONLY"
    UNRESECTABLE = "UNRESECTABLE"
    OTHER = "OTHER"


class Histology(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    PILOCYTIC_ASTROCYTOMA = "PILOCYTIC_ASTROCYTOMA"
    PILOMYXOID_ASTROCYTOMA = "PILOMYXOID_ASTROCYTOMA"
    DIFFUSE_ASTROCYTOMA = "DIFFUSE_ASTROCYTOMA"
    GANGLIOGLIOMA = "GANGLIOGLIOMA"
    DNET = "DNET"  # Dysembryoplastic neuroepithelial tumor (often in DDx)
    OTHER_LGG = "OTHER_LGG"
    UNKNOWN = "UNKNOWN"


class MolecularDriver(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    BRAF_V600E = "BRAF_V600E"
    BRAF_FUSION = "BRAF_FUSION"  # e.g., KIAA1549-BRAF
    NF1_MAPK_ACTIVATION = "NF1_MAPK_ACTIVATION"
    OTHER_RAF_ALTERATION = "OTHER_RAF_ALTERATION"
    FGFR_ALTERATION = "FGFR_ALTERATION"
    NTRK_FUSION = "NTRK_FUSION"
    ALK_FUSION = "ALK_FUSION"
    ROS1_FUSION = "ROS1_FUSION"
    UNKNOWN = "UNKNOWN"

class RadiotherapyExposureHistoryStatus(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    YES = "YES"
    NO = "NO"

class ProgressionType(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    NONE = "NONE"
    BOTH = "BOTH FUNCTIONAL AND RADIOGRAPHIC"
    RADIOGRAPHIC = "RADIOGRAPHIC"
    FUNCTIONAL = "FUNCTIONAL"
    SUSPECTED = "SUSPECTED"

class VisualStatus(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    STABLE = "STABLE"
    DECLINING = "DECLINING"
    IMPROVING = "IMPROVING"
    SEVERE_LOSS = "SEVERE_LOSS"
    OTHER = "OTHER"

class EndocrineStatus(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    NORMAL = "NORMAL"
    DYSFUNCTION_PRESENT = "DYSFUNCTION_PRESENT"
    DIABETES_INSIPIDUS = "DIABETES_INSIPIDUS"
    PITUITARY_DEFICIENCY = "PITUITARY_DEFICIENCY"
    HYPOTHALAMIC_DYSFUNCTION = "HYPOTHALAMIC_DYSFUNCTION"
    OTHER = "OTHER"

class SymptomBurden(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    SEIZURES = "SEIZURES"
    HEADACHE = "HEADACHE"
    FOCAL_NEURO_DEFICIT = "FOCAL_NEURO_DEFICIT"
    VISUAL_SYMPTOMS = "VISUAL_SYMPTOMS"
    ENDOCRINE_SYMPTOMS = "ENDOCRINE_SYMPTOMS"
    INCREASED_ICP = "INCREASED_ICP"
    OTHER = "OTHER"

class NF1Status(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    POSITIVE = "POSITIVE"
    SUSPECTED = "SUSPECTED"
    NEGATIVE = "NEGATIVE"
    MENTIONED_BUT_UNKNOWN = "UNKNOWN"

class MassEffect(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    NONE = "NONE"
    MASS_EFFECT_PRESENT = "MASS_EFFECT_PRESENT"
    HYDROCEPHALUS = "HYDROCEPHALUS"
    MIDLINE_SHIFT = "MIDLINE_SHIFT"
    IMPENDING_HERNIATION = "IMPENDING_HERNIATION"
    OTHER = "OTHER"

class TherapyLine(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    OBSERVATION = "OBSERVATION"
    SURGERY = "SURGERY"
    CHEMOTHERAPY = "CHEMOTHERAPY"
    TARGETED_THERAPY = "TARGETED_THERAPY"
    RADIOTHERAPY = "RADIOTHERAPY"
    CLINICAL_TRIAL = "CLINICAL_TRIAL"

class ChemoRegimen(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    CARBOPLATIN_VINCRISTINE = "CARBOPLATIN_VINCRISTINE"
    VINBLASTINE = "VINBLASTINE"
    TPCV = "TPCV"  # thioguanine/procarbazine/CCNU/vincristine (legacy)
    OTHER = "OTHER"

class TargetedRegimen(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    BRAF_MEK_COMBO = "BRAF_MEK_COMBO"      # e.g., dabrafenib + trametinib
    MEK_INHIBITOR = "MEK_INHIBITOR"        # e.g., selumetinib
    PAN_RAF_INHIBITOR = "PAN_RAF_INHIBITOR"  # e.g., tovorafenib (context-dependent)
    MTOR_INHIBITOR = "MTOR_INHIBITOR"      # e.g., everolimus
    OTHER = "OTHER"

class ToxicitySeverity(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    MILD = "MILD"
    MODERATE = "MODERATE"
    SEVERE = "SEVERE"
    DOSE_LIMITING = "DOSE_LIMITING"
    OTHER = "OTHER"

class RegrowthPattern(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    PROGRESSION = "PROGRESSION"
    REBOUND_AFTER_STOPPING_TARGETED = "REBOUND_AFTER_STOPPING_TARGETED"
    RESISTANCE_ON_TARGETED = "RESISTANCE_ON_TARGETED"
    PSEUDOPROGRESSION_SUSPECTED = "PSEUDOPROGRESSION_SUSPECTED"
    OTHER = "OTHER"

class NeurocognitiveRisk(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    LOW = "LOW"
    MODERATE = "MODERATE"
    HIGH = "HIGH"
    IMPAIRED_BASELINE = "IMPAIRED_BASELINE"
    OTHER = "OTHER"


class ClinicalTrialAvailability(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    AVAILABLE_AND_ELIGIBLE = "AVAILABLE_AND_ELIGIBLE"
    AVAILABLE_NOT_ELIGIBLE = "AVAILABLE_NOT_ELIGIBLE"
    NOT_AVAILABLE = "NOT_AVAILABLE"
    OTHER = "OTHER"

# ----------------------------
# Mention models (each extends SpanAugmentedMention)
# ----------------------------
class AgeAtDiagnosisMention(SpanAugmentedMention):
    age_years: Optional[float] = Field(
        None,
        description="Age at diagnosis in years, if explicitly stated."
    )


class TumorLocationMention(SpanAugmentedMention):
    location: TumorLocation = Field(
        TumorLocation.NOT_MENTIONED,
        description="Primary tumor anatomic location."
    )


class TumorSizeMassEffectMention(SpanAugmentedMention):
    mass_effect: MassEffect = Field(
        MassEffect.NOT_MENTIONED,
        description="Whether MRI/CT describes mass effect or hydrocephalus."
    )
    size_text: Optional[str] = Field(
        None,
        description="Free-text size description (e.g., '3.2 x 2.1 x 2.4 cm') if present."
    )


class SymptomBurdenMention(SpanAugmentedMention):
    symptom_burden: list[SymptomBurden] = Field(
        default_factory=list,
        description="Symptoms attributed to the tumor; may include multiple."
    )

class NF1StatusMention(SpanAugmentedMention):
    nf1_status: NF1Status = Field(
        NF1Status.NOT_MENTIONED,
        description="Whether NF1 is present."
    )


class ExtentOfResectionMention(SpanAugmentedMention):
    extent: ExtentOfResection = Field(
        ExtentOfResection.NOT_MENTIONED,
        description="Extent of resection or biopsy status."
    )


class HistologyMention(SpanAugmentedMention):
    histology: Histology = Field(
        Histology.NOT_MENTIONED,
        description="Histologic subtype if stated."
    )


class MolecularDriverMention(SpanAugmentedMention):
    driver: MolecularDriver = Field(
        MolecularDriver.NOT_MENTIONED,
        description="Key actionable molecular driver."
    )
    gene_or_fusion_text: Optional[str] = Field(
        None,
        description="Free-text molecular result (e.g., 'KIAA1549-BRAF fusion')."
    )


class RadiographicProgressionMention(SpanAugmentedMention):
    progression: ProgressionType = Field(
        ProgressionType.NOT_MENTIONED,
        description="Radiographic/functional progression status as stated."
    )


class FunctionalProgressionMention(SpanAugmentedMention):
    progression: ProgressionType = Field(
        ProgressionType.NOT_MENTIONED,
        description="Functional progression status; often vision/neuro/endocrine."
    )


class VisualAcuityMention(SpanAugmentedMention):
    visual_status: VisualStatus = Field(
        VisualStatus.NOT_MENTIONED,
        description="Directionality of visual function over time."
    )
    visual_acuity_text: Optional[str] = Field(
        None,
        description="Free-text VA values (e.g., '20/40 OS') if present."
    )


class EndocrineFunctionMention(SpanAugmentedMention):
    endocrine_status: EndocrineStatus = Field(
        EndocrineStatus.NOT_MENTIONED,
        description="Endocrine function/dysfunction signals."
    )


class PriorTherapyExposureMention(SpanAugmentedMention):
    prior_modalities: list[TherapyLine] = Field(
        default_factory=list,
        description="Previously received modalities (surgery/chemo/targeted/RT/trial)."
    )
    prior_chemo: list[ChemoRegimen] = Field(
        default_factory=list,
        description="Named prior chemotherapy regimens if stated."
    )
    prior_targeted: list[TargetedRegimen] = Field(
        default_factory=list,
        description="Named prior targeted regimens if stated."
    )


class TreatmentToxicityMention(SpanAugmentedMention):
    severity: ToxicitySeverity = Field(
        ToxicitySeverity.NOT_MENTIONED,
        description="Overall toxicity severity as described."
    )
    toxicity_text: Optional[str] = Field(
        None,
        description="Free-text toxicity details (e.g., 'grade 3 rash', 'vincristine neuropathy')."
    )


class ResponseToTherapyMention(SpanAugmentedMention):
    response_text: Optional[str] = Field(
        None,
        description="Free-text response assessment (e.g., partial response, stable disease)."
    )


class RegrowthPatternMention(SpanAugmentedMention):
    pattern: RegrowthPattern = Field(
        RegrowthPattern.NOT_MENTIONED,
        description="Pattern of regrowth on/off therapy (progression vs rebound vs resistance)."
    )


class AgeAtProgressionMention(SpanAugmentedMention):
    age_years: Optional[float] = Field(
        None,
        description="Age at progression in years, if explicitly stated."
    )


class RadiotherapyExposureHistoryMention(SpanAugmentedMention):
    has_prior_radiotherapy: RadiotherapyExposureHistoryStatus = Field(
        RadiotherapyExposureHistoryStatus.NOT_MENTIONED,
        description="Whether patient has prior radiotherapy exposure."
    )
    rt_type_text: Optional[str] = Field(
        None,
        description="Free-text RT type (e.g., proton, photon) and/or dose/fractionation if stated."
    )


class NeurocognitiveRiskMention(SpanAugmentedMention):
    risk: NeurocognitiveRisk = Field(
        NeurocognitiveRisk.NOT_MENTIONED,
        description="Neurocognitive risk/impairment cues (baseline or treatment-related)."
    )


class ClinicalTrialAvailabilityMention(SpanAugmentedMention):
    trial_status: ClinicalTrialAvailability = Field(
        ClinicalTrialAvailability.NOT_MENTIONED,
        description="Whether a clinical trial is available/considered."
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

    extent_of_resection: ExtentOfResectionMention = Field(default_factory=ExtentOfResectionMention)
    histology: HistologyMention = Field(default_factory=HistologyMention)
    molecular_driver: MolecularDriverMention = Field(default_factory=MolecularDriverMention)

    radiographic_progression: RadiographicProgressionMention = Field(default_factory=RadiographicProgressionMention)
    functional_progression: FunctionalProgressionMention = Field(default_factory=FunctionalProgressionMention)

    visual_acuity: VisualAcuityMention = Field(default_factory=VisualAcuityMention)
    endocrine_function: EndocrineFunctionMention = Field(default_factory=EndocrineFunctionMention)

    prior_therapy_exposure: PriorTherapyExposureMention = Field(default_factory=PriorTherapyExposureMention)
    treatment_toxicity: TreatmentToxicityMention = Field(default_factory=TreatmentToxicityMention)
    response_to_therapy: ResponseToTherapyMention = Field(default_factory=ResponseToTherapyMention)

    regrowth_pattern: RegrowthPatternMention = Field(default_factory=RegrowthPatternMention)

    age_at_progression: AgeAtProgressionMention = Field(default_factory=AgeAtProgressionMention)
    radiotherapy_exposure_history: RadiotherapyExposureHistoryMention = Field(default_factory=RadiotherapyExposureHistoryMention)

    neurocognitive_risk: NeurocognitiveRiskMention = Field(default_factory=NeurocognitiveRiskMention)
    clinical_trial_availability: ClinicalTrialAvailabilityMention = Field(default_factory=ClinicalTrialAvailabilityMention)
