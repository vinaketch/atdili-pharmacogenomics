#!/usr/bin/env bash

# ============================================================
# ATDILI Pharmacogenomics
# Step 2: Merge cohort VCF files
#
# Input:
#   Hard-filtered DRAGEN VCF files
#
# Output:
#   dili-merged-286.vcf.gz
# ============================================================

set -e

bcftools merge \
    -m none \
    -0 \
    *.hard-filtered.vcf.gz \
    | bgzip -c > dili-merged-286.vcf.gz

tabix -p vcf dili-merged-286.vcf.gz

echo "VCF merging completed."
