#!/usr/bin/env bash

# ============================================================
# ATDILI Pharmacogenomics
# Step 5: Extract PASS variants
# ============================================================

set -e

bcftools view \
    -f PASS \
    -Oz \
    dili-merged-286-filtered.vcf.gz \
    -o dili-merged-286-pass.vcf.gz

tabix -p vcf dili-merged-286-pass.vcf.gz

echo "PASS variants extracted."

echo "Number of PASS variants:"
bcftools view -H dili-merged-286-pass.vcf.gz | wc -l
