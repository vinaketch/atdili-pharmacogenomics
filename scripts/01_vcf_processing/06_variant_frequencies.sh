#!/usr/bin/env bash

# ============================================================
# ATDILI Pharmacogenomics
# Step 6: Calculate variant allele frequencies
# ============================================================

set -e

/opt/exp_soft/bioinf/vcftools/bin/vcftools \
    --gzvcf dili-merged-286-pass.vcf.gz \
    --freq \
    --out dili-286

echo "Allele-frequency analysis completed."

echo "Frequency output:"
ls -lh dili-286.frq
