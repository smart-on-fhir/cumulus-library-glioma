from enum import StrEnum
from typing import Optional

from diff_cover import DESCRIPTION
from pydantic import Field
from .mention import SpanAugmentedMention

###############################################################################
# Clinical recommendations:
#   https://www.nice.org.uk/guidance/ng99/chapter/Recommendations
#
# NCBI Genetic Testing Registry
#   https://www.ncbi.nlm.nih.gov/gtr/conditions/C0017638/
###############################################################################

###############################################################################
# Molecular Driver
###############################################################################
class MolecularDriverMention(SpanAugmentedMention):
    """
    Minimal set of clinically actionable genetic alterations for glioma.
    """
    # --- Core actionable alteration ---
    braf_altered: Optional[bool] = Field(
        None,
        description="BRAF alteration is present (any type)."
    )

    braf_v600e: Optional[bool] = Field(
        None,
        description="BRAF V600E mutation is present."
    )

    braf_fusion: Optional[bool] = Field(
        None,
        description=" BRAF fusion (e.g., KIAA1549-BRAF) is present."
    )

    idh_mutant: Optional[bool] = Field(
        None,
        description="IDH1 or IDH2 mutation is present."
    )

    h3k27m_mutant: Optional[bool] = Field(
        None,
        description="Histone H3 K27M (H3-3A or H3C2) mutation is present."
    )

    tp53_altered: Optional[bool] = Field(
        None,
        description="TP53 mutation or loss is present."
    )

    # --- Copy number / pathway surrogates ---
    cdkn2a_deleted: Optional[bool] = Field(
        None,
        description="CDKN2A deletion is present."
    )

    nf1_mapk_activation: Optional[bool] = Field(
        None,
        description="NF1 MAPK activation is present."
    )

    other_raf_alteration: Optional[bool] = Field(
        None,
        description="Other RAF alteration is present."
    )

    fgfr_alteration: Optional[bool] = Field(
        None,
        description="FGFR alteration is present."
    )

    ntrk_fusion: Optional[bool] = Field(
        None,
        description="NTRK fusion is present."
    )

    alk_fusion: Optional[bool] = Field(
        None,
        description="ALK fusion is present."
    )

    ros1_fusion: Optional[bool] = Field(
        None,
        description="ROS1 fusion is present."
    )

###############################################################################
# Genetic Variants
###############################################################################
class VariantInterpretation(StrEnum):
    B = 'BENIGN'
    LB = 'LIKELY BENIGN'
    VUS = 'VARIANT OF UNKNOWN SIGNIFICANCE'
    P = 'PATHOGENIC'
    LP = 'LIKELY PATHOGENIC'
    NOT_MENTIONED = 'NOT MENTIONED'

class VariantMention(SpanAugmentedMention):
    """
    Clinical interpretation of genetic variant
    """
    hgnc_name: str = Field(
        default=None,
        description="HGNC hugo gene naming convention"
    )

    interpretation: VariantInterpretation = Field(
        VariantInterpretation.NOT_MENTIONED,
        description='Clinical interpretation of genetic variant or genetic test result'
    )

    hgvs_variant:str = Field(
        str,
        description="Human Genome Variation Society (HGVS) variant"
    )
