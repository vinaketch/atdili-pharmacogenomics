# ============================================================
# Script: merge_vep_plink_frequencies.R
# Purpose: Merge VEP annotations with PLINK allele frequencies
# Author: Vincent Aketch Nyangwara
# Date: 14 July 2026
# ============================================================

# Load required packages
library(readr)
library(dplyr)
library(tidyr)

# ------------------------------------------------------------
# 1. Read input files
# ------------------------------------------------------------

# PLINK allele frequency file
freq <- read_tsv("dili-286.frq", show_col_types = FALSE)

# VEP annotation file
vep <- read_tsv("vep_analysis_panel_clean.txt", show_col_types = FALSE)

# ------------------------------------------------------------
# 2. Convert VEP genomic position to CHROM and POS
# ------------------------------------------------------------

vep <- vep %>%
  separate(
    POS,
    into = c("CHROM", "START_END"),
    sep = ":"
  ) %>%
  separate(
    START_END,
    into = c("POS", "END"),
    sep = "-"
  ) %>%
  mutate(
    CHROM = paste0("chr", CHROM),
    POS = as.numeric(POS)
  )

# ------------------------------------------------------------
# 3. Merge VEP annotations with PLINK frequencies
# ------------------------------------------------------------

merged <- left_join(
  vep,
  freq,
  by = c("CHROM", "POS")
)

# ------------------------------------------------------------
# 4. Write merged output
# ------------------------------------------------------------

# ------------------------------------------------------------
# 4. Remove allele labels (e.g., C:, T:) from frequency columns
# ------------------------------------------------------------

merged <- merged %>%
  mutate(
    REF_ALLELE.y = sub(".*:", "", REF_ALLELE.y),
    ALT_ALLELE.y = sub(".*:", "", ALT_ALLELE.y)
  )

write_tsv(
  merged,
  "vep_with_frequencies.txt"
)

cat("Merge completed successfully!\n")
cat("Output file: vep_with_frequencies.txt\n")