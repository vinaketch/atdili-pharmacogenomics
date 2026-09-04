#!/usr/bin/env bash

# ============================================================
# ATDILI Pharmacogenomics
# Step: Check representation of study genes in VEP output
# ============================================================

set -e

VEP_FILE="vep_analysis_panel.txt"
GENE_LIST="config/gene_panel.txt"
GENES_PRESENT="genes_in_vep.txt"
MISSING_GENES="missing_genes.txt"

echo "Extracting genes present in VEP output..."

cut -f5 "$VEP_FILE" \
    | tail -n +2 \
    | sort -u \
    > "$GENES_PRESENT"

echo "Genes present in VEP output:"
cat "$GENES_PRESENT"

echo
echo "Number of genes present:"
wc -l "$GENES_PRESENT"

echo
echo "Finding missing genes..."

comm -23 \
    <(sort -u "$GENE_LIST") \
    "$GENES_PRESENT" \
    > "$MISSING_GENES"

echo "Missing genes:"
cat "$MISSING_GENES"
