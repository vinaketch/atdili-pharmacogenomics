#!/usr/bin/env bash

# ============================================================
# ATDILI Pharmacogenomics
# Extract pharmacogene allele-defining variants
#
# Usage:
#   bash 02_extract_allele_variants.sh \
#       <phased_vcf> \
#       <allele_definition_vcf> \
#       <output_directory>
#
# Example:
#   bash 02_extract_allele_variants.sh \
#       chr19_phased.vcf.gz \
#       CYP2A6_allele_def_var.vcf.gz \
#       CYP2A6_isec
# ============================================================

set -e

PHASED_VCF="$1"
ALLELE_DEF="$2"
OUTPUT_DIR="$3"

if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <phased_vcf> <allele_definition_vcf> <output_directory>"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

bcftools isec \
    "$PHASED_VCF" \
    "$ALLELE_DEF" \
    -p "$OUTPUT_DIR"

echo "Allele-defining variant extraction completed."
