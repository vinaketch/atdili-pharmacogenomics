#!/usr/bin/env bash

# ============================================================
# ATDILI Pharmacogenomics
# Step 4: Apply variant and genotype filters
#
# Filters:
#   QUAL >= 30
#   AD[*:1] >= 15
#   -g 8
#   -G 10
# ============================================================

set -e

bcftools filter \
    -s LowQual \
    '-i QUAL>=30 && AD[*:1]>=15' \
    -g 8 \
    -G 10 \
    -Oz \
    dili-merged-286-norm.vcf.gz \
    -o dili-merged-286-filtered.vcf.gz

tabix -p vcf dili-merged-286-filtered.vcf.gz

echo "Variant filtering completed."
