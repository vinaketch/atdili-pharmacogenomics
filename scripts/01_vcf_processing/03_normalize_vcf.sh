#!/usr/bin/env bash

# ============================================================
# ATDILI Pharmacogenomics
# Step 3: Normalize merged VCF
# ============================================================

set -e

bcftools norm \
    dili-merged-286.vcf.gz \
    --rm-dup all \
    | bcftools norm -m - \
    | bgzip -c > dili-merged-286-norm.vcf.gz

tabix -p vcf dili-merged-286-norm.vcf.gz

echo "VCF normalization completed."
