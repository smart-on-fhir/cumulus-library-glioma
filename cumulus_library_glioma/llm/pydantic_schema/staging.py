from enum import StrEnum
from pydantic import Field
from .mention import SpanAugmentedMention

###############################################################################
# TNM Stage (Pathological Stage)
###############################################################################
class StageT(StrEnum):
    TX = "TX"
    T0 = "T0"
    TIS = "Tis"
    T1 = "T1"
    T1A = "T1a"
    T1B = "T1b"
    T2 = "T2"
    T2A = "T2a"
    T2B = "T2b"
    T3 = "T3"
    T4 = "T4"

class StageN(StrEnum):
    NX = "NX"
    N0 = "N0"
    N1I = "N1i"
    N1 = "N1"
    N2 = "N2"
    N3 = "N3"


class StageM(StrEnum):
    M0 = "M0"
    M1 = "M1"
    M1A = "M1a"
    M1B = "M1b"

class TNMStageMention(SpanAugmentedMention):
    """
    TNM cancer staging using ICD-O / AJCC-style T, N, and M categories.

    T = Primary tumor size/extent
    N = Regional lymph node involvement
    M = Distant metastasis status
    """
    t: StageT = Field(None, description="T category (primary tumor).")
    n: StageN = Field(None, description="N category (regional lymph nodes).")
    m: StageM = Field(None, description="M category (distant metastasis).")


###############################################################################
# Clinical Stage
###############################################################################
class ClinicalStage(StrEnum):
    STAGE_0 = "0"
    STAGE_IA = "IA"
    STAGE_IB = "IB"
    STAGE_IIA = "IIA"
    STAGE_IIB = "IIB"
    STAGE_IIIA = "IIIA"
    STAGE_IIIB = "IIIB"
    STAGE_IV = "IV"

class ClinicalStageMention(SpanAugmentedMention):
    """
    Clinical stage grouping using ICD-O / AJCC-style global stage categories.
    These represent the overall clinical stage (not pathologic stage).

    Examples:
      - 0:     Carcinoma in situ
      - IA/IB: Early localized disease
      - II–III: Increasing local/regional extent
      - IV:     Metastatic disease
    """
    code: ClinicalStage = Field(
        None,
        description="ICD-O / AJCC clinical stage group (0, IA, IB, IIA, IIB, IIIA, IIIB, IV)."
    )
    display: str = Field(
        None,
        description="Human-readable description of the clinical stage."
    )

