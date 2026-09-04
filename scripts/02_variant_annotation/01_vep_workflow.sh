#!/usr/bin/env bash

# ============================================================
# ATDILI Pharmacogenomics
# VEP annotation workflow
#
# VEP annotation was performed using Ensembl Variant Effect
# Predictor (VEP).
#
# Following annotation:
#   1. Variants annotated as MANE Select were retained.
#   2. The filtered VEP output was downloaded.
#   3. Variants were subsequently restricted to genes included
#      in the study gene panel.
#
# The downloaded VEP output is not included in this repository
# because it is derived from study genomic data.
# ============================================================

echo "VEP annotation was performed using Ensembl VEP."
echo "See docs/pipeline.md for the complete procedure."
