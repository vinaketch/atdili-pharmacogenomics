# =========================================================
# Consensus Functional Prediction for VEP Annotations
# Vincent Nyangwara
# =========================================================

# Load packages
library(readxl)
library(dplyr)
library(writexl)

# ---------------------------------------------------------
# Read Excel file
# ---------------------------------------------------------

df <- read_excel("vep_with_frequencies.xlsx")

# ---------------------------------------------------------
# Standardize text columns
# ---------------------------------------------------------

df <- df %>%
  mutate(
    SIFT = tolower(trimws(SIFT)),
    PolyPhen = tolower(trimws(PolyPhen)),
    CLIN_SIG = tolower(trimws(CLIN_SIG)),
    AlphaMissense = tolower(trimws(AlphaMissense)),
    MetaLR_pred = toupper(trimws(MetaLR_pred)),
    PROVEAN_pred = toupper(trimws(PROVEAN_pred))
  )

# ---------------------------------------------------------
# Count deleterious votes
# ---------------------------------------------------------

df <- df %>%
  mutate(
    
    D_count =
      
      # SIFT
      ifelse(grepl("deleterious", SIFT), 1, 0) +
      
      # PolyPhen
      ifelse(grepl("probably", PolyPhen), 1, 0) +
      
      # ClinVar clinical significance
      ifelse(CLIN_SIG %in% c("pathogenic", "likely_pathogenic"), 1, 0) +
      
      # AlphaMissense
      ifelse(AlphaMissense == "likely_pathogenic", 1, 0) +
      
      # CADD (deleterious if PHRED ≥10)
      ifelse(!is.na(CADD_PHRED) & CADD_PHRED >= 10, 1, 0) +
      
      # REVEL (deleterious if score ≥0.50)
      ifelse(!is.na(REVEL) & REVEL >= 0.50, 1, 0) +
      
      # MetaLR
      ifelse(MetaLR_pred == "D", 1, 0) +
      
      # PROVEAN
      ifelse(PROVEAN_pred == "D", 1, 0)
  )

# ---------------------------------------------------------
# Assign consensus
# ---------------------------------------------------------

df <- df %>%
  mutate(
    Consensus = ifelse(D_count >= 3, "D", "N")
  )

# ---------------------------------------------------------
# Remove helper column if desired
# ---------------------------------------------------------

df <- df %>%
  select(-D_count)

# ---------------------------------------------------------
# Save output
# ---------------------------------------------------------

write_xlsx(df, "vep_annotation_with_consensus.xlsx")

# ---------------------------------------------------------
# Summary
# ---------------------------------------------------------

table(df$Consensus)

cat("\nConsensus annotation complete!\n")

# Clean rsIDs
df$rsID <- sub(",.*", "", df$rsID)

# Save cleaned file
write_xlsx(df, "vep_annotation_with_consensus.xlsx")

