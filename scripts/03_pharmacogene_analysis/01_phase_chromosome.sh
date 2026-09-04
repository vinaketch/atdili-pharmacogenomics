#!/usr/bin/env bash

# ============================================================
# ATDILI Pharmacogenomics
# Chromosome-level phasing using Beagle
#
# Usage:
#   bash 01_phase_chromosome.sh <chromosome>
#
# Example:
#   bash 01_phase_chromosome.sh chr19
# ============================================================

set -e

CHROM="$1"
INPUT_VCF="dili-merged-286-pass.vcf.gz"
BEAGLE_JAR="beagle.27Feb25.75f.jar"

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <chromosome>"
    exit 1
fi

echo "Extracting $CHROM..."

bcftools view \
    -r "$CHROM" \
    "$INPUT_VCF" \
    | bgzip -c > "dili-${CHROM}.vcf.gz"

tabix -p vcf "dili-${CHROM}.vcf.gz"

echo "Phasing $CHROM..."

java -jar "$BEAGLE_JAR" \
    gt="dili-${CHROM}.vcf.gz" \
    out="${CHROM}_phased" \
    chrom="$CHROM"

echo "Phasing completed for $CHROM."
