#!/usr/bin/env bash

# ============================================================
# ATDILI Pharmacogenomics
# Generate VCF quality-control summary
# ============================================================

set -e

VCF="dili-merged-286-pass.vcf.gz"

mkdir -p results logs

echo "Generating VCF statistics..."

bcftools stats \
    "$VCF" \
    > results/dili-merged-286-pass.stats.txt

echo "Number of variants:"
bcftools view -H "$VCF" | wc -l \
    | tee results/variant_count.txt

echo "Number of samples:"
bcftools query -l "$VCF" | wc -l \
    | tee results/sample_count.txt

echo "QC completed."
