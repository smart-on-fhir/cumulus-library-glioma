from enum import StrEnum
from pydantic import BaseModel, Field

###############################################################################
# Yes/No/Unknown (or NOT_MENTIONED)
###############################################################################
class YesNoUnknown(StrEnum):
    NOT_MENTIONED = "NOT_MENTIONED"
    YES = "YES"
    NO = "NO"
    UNKNOWN = "UNKNOWN"

###############################################################################
# Evidence citation
###############################################################################
class SpanAugmentedMention(BaseModel):
    has_mention: bool = Field(
        False,
        description="Whether there is any mention of this variable in the text."
    )
    spans: list[str] = Field(
        default_factory=list,
        description="The text spans where this variable is mentioned."
    )

