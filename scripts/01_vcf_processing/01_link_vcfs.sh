#!/usr/bin/env bash

# ============================================================
# ATDILI Pharmacogenomics
# Step 1: Link cohort VCF files
#
# Purpose:
#   Create symbolic links to the 286 DRAGEN hard-filtered VCF
#   files and their tabix indexes.
#
# Input:
#   /dataA/dili/2026-04-30-sctask0442981-o/dragen/
#
# Output:
#   Symbolic links to VCF and TBI files in the working directory
#   samples_286.txt
# ============================================================

ls /dataA/dili/2026-04-30-sctask0442981-o/dragen/ | grep DIL > samples_286.txt

for i in $(cat samples_286.txt); do

    ln -s /dataA/dili/2026-04-30-sctask0442981-o/dragen/${i}/${i}*.hard-filtered.vcf.gz

    ln -s /dataA/dili/2026-04-30-sctask0442981-o/dragen/${i}/${i}*.hard-filtered.vcf.gz.tbi

done
