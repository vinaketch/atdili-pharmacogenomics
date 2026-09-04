#!/usr/bin/env bash

# ============================================================
# ATDILI Pharmacogenomics
# Step: Filter VEP output to the study gene panel
#
# Usage:
#   bash 02_filter_vep_panel.sh vep_analysis.txt
# ============================================================

set -e

VEP_FILE="$1"
GENE_LIST="config/gene_panel.txt"
OUTPUT="vep_analysis_panel.txt"

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <vep_analysis.txt>"
    exit 1
fi

echo "Converting gene list to Unix format..."

dos2unix "$GENE_LIST"

echo "Filtering VEP output..."

head -n 1 "$VEP_FILE" > "$OUTPUT"

tail -n +2 "$VEP_FILE" \
    | grep -Fwf "$GENE_LIST" \
    >> "$OUTPUT"

echo "VEP panel-filtered file:"
echo "$OUTPUT"

echo "Number of lines:"
wc -l "$OUTPUT"

echo "Number of genes in panel:"
sort -u "$GENE_LIST" | wc -l
