from enum import StrEnum
from pydantic import BaseModel, Field, Optional
from .mention import SpanAugmentedMention

###############################################################################
# Negative Responses
###############################################################################
class RxDiscontinued(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    PROGRESSION = "PROGRESSION"
    TOXICITY = "TOXICITY"
    LACK_OF_RESPONSE = "LACK_OF_RESPONSE"
    COMPLETED_PLANNED_THERAPY = "COMPLETED_PLANNED_THERAPY"
    PATIENT_PREFERENCE = "PATIENT_PREFERENCE"
    TRANSITION_TO_TRIAL = "TRANSITION_TO_TRIAL"
    OTHER = "OTHER"

class RxToxicitySeverity(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    MILD = "MILD"
    MODERATE = "MODERATE"
    SEVERE = "SEVERE"
    DOSE_LIMITING = "DOSE_LIMITING"
    OTHER = "OTHER"

class RxToxicitySeverityMention(SpanAugmentedMention):
    severity: RxToxicitySeverity = Field(
        RxToxicitySeverity.NOT_MENTIONED,
        description="Overall toxicity severity as described."
    )
    toxicity_text: Optional[str] = Field(
        None,
        description="Free-text toxicity details (e.g., 'grade 3 rash', 'vincristine neuropathy')."
    )

###############################################################################
# Drug Response
###############################################################################
class RxResponse(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    COMPLETE_RESPONSE = "COMPLETE_RESPONSE"
    PARTIAL_RESPONSE = "PARTIAL_RESPONSE"
    MINOR_RESPONSE = "MINOR_RESPONSE"        # commonly used in LGG trials
    STABLE_DISEASE = "STABLE_DISEASE"
    PROGRESSIVE_DISEASE = "PROGRESSIVE_DISEASE"
    MIXED_RESPONSE = "MIXED_RESPONSE"
    PSEUDOPROGRESSION = "PSEUDOPROGRESSION"
    NOT_EVALUABLE = "NOT_EVALUABLE"

class RxResponseMention(BaseModel):
    response: RxResponse = Field(
        RxResponse.NOT_MENTIONED,
        description="Best documented response on therapy."
    )

    response_confidence: Optional[float] = Field(
        None,
        description="LLM confidence score (0–1) if used."
    )

    response_days: Optional[int] = Field(
        None,
        description="Days from therapy start to first response."
    )

    duration_on_therapy_days: Optional[int] = Field(
        None,
        description="Total duration of exposure in days."
    )

    duration_of_response_days: Optional[int] = Field(
        None,
        description="Duration response was maintained."
    )

    discontinued: bool = Field(
        False,
        description="Whether therapy was stopped."
    )

    discontinued_reason: RxDiscontinued = Field(
        RxDiscontinued.NOT_MENTIONED,
        description="Reason therapy was stopped."
    )

