# =========================================================
# Create Publication-Ready Table:
# Clinically Actionable Pharmacogenomic Variants
# Export to Excel and Word
# =========================================================

# ----------------------------
# Load Required Packages
# ----------------------------

library(readxl)
library(writexl)
library(dplyr)
library(stringr)
library(tidyr)
library(flextable)
library(officer)

# ----------------------------
# Read Dataset
# ----------------------------

df <- read_excel(
  "C:/School work/PhD project/ATDILI_PGX/Objective 2_Genomics/vep_results/vep_2/matching_AFs/Merged_VEP_AF_annotations.xlsx",
  sheet = 6
)

# ----------------------------
# Keep Protein-Altering Variants
# ----------------------------

protein_altering <- c(
  "Missense",
  "Stop gained",
  "Frameshift",
  "Splice defect"
)

df <- df %>%
  filter(Consequence %in% protein_altering)

# ----------------------------
# Clinically Actionable Genes
# ----------------------------

clinical_genes <- c(
  "CYP2A6",
  "CYP2C19",
  "CYP2C9",
  "CYP2D6",
  "CYP4F2",
  "DPYD",
  "ABCG2",
  "ACE",
  "ADD1",
  "ADRB2",
  "ALDH2",
  "APOE",
  "ATIC",
  "CACNA1S",
  "CES1",
  "CFTR",
  "EGFR",
  "FCGR3A",
  "G6PD",
  "IFNL3",
  "ITPA",
  "MTHFR",
  "NUDT15",
  "RYR1",
  "SCN1A",
  "SLC19A1",
  "SLC28A3",
  "TNF",
  "TPMT",
  "UGT1A1",
  "VKORC1",
  "XRCC1"
)

# ----------------------------
# Keep Only Clinically Actionable Genes
# ----------------------------

df <- df %>%
  filter(Gene %in% clinical_genes)

# ----------------------------
# Optional Check:
# See Which Genes Were Found
# ----------------------------

cat("Genes identified in dataset:\n")

print(
  sort(unique(df$Gene))
)

# ----------------------------
# Create Protein Change Column
# Example:
# R/K + 268 = R268K
# ----------------------------

df <- df %>%
  
  mutate(
    
    Protein_Change = case_when(
      
      Consequence == "Stop gained" ~ "Stop gained",
      
      Consequence == "Frameshift" ~ "Frameshift",
      
      Consequence == "Splice defect" ~ "Splice defect",
      
      grepl("/", Amino_acids) ~ paste0(
        word(Amino_acids, 1, sep = "/"),
        Protein_position,
        word(Amino_acids, 2, sep = "/")
      ),
      
      TRUE ~ Amino_acids
    )
    
  )

# ----------------------------
# Convert Frequencies to Percentages
# ----------------------------

freq_cols <- c(
  "SA_AF",
  "AFR_AF",
  "EUR_AF",
  "AMR_AF",
  "SAS_AF",
  "EAS_AF"
)

for(col in freq_cols){
  
  df[[col]] <- round(
    as.numeric(df[[col]]) * 100,
    1
  )
}

# ----------------------------
# Replace Missing Values with "-"
# ----------------------------

df <- df %>%
  
  mutate(
    
    across(
      everything(),
      ~replace_na(as.character(.), "-")
    )
    
  )

# ----------------------------
# Create Final Table
# ----------------------------

table_clinical <- df %>%
  
  select(
    rsID,
    Protein_Change,
    Gene,
    Consensus,
    SA_AF,
    AFR_AF,
    EUR_AF,
    AMR_AF,
    SAS_AF,
    EAS_AF
  ) %>%
  
  rename(
    Consequence = Protein_Change
  )

# ----------------------------
# Arrange Genes in Desired Order
# ----------------------------

gene_order <- c(
  "CYP2A6",
  "CYP2C19",
  "CYP2C9",
  "CYP2D6",
  "CYP4F2",
  "DPYD",
  "TPMT",
  "NUDT15",
  "ABCG2",
  "ACE",
  "ADD1",
  "ADRB2",
  "ALDH2",
  "APOE",
  "ATIC",
  "CACNA1S",
  "CES1",
  "CFTR",
  "EGFR",
  "FCGR3A",
  "G6PD",
  "IFNL3",
  "ITPA",
  "MTHFR",
  "RYR1",
  "SCN1A",
  "SLC19A1",
  "SLC28A3",
  "TNF",
  "UGT1A1",
  "VKORC1",
  "XRCC1"
)

table_clinical <- table_clinical %>%
  
  mutate(
    Gene = factor(Gene, levels = gene_order)
  ) %>%
  
  arrange(Gene)

# Convert Gene back to character
table_clinical$Gene <- as.character(table_clinical$Gene)

# ----------------------------
# Save Excel File
# ----------------------------

write_xlsx(
  table_clinical,
  "Clinically_Actionable_PGx_Variants.xlsx"
)

# ----------------------------
# Create Publication-Ready Word Table
# ----------------------------

ft <- flextable(table_clinical)

# Apply clean table theme
ft <- theme_booktabs(ft)

# Center align all columns
ft <- align(
  ft,
  align = "center",
  part = "all"
)

# Bold header
ft <- bold(
  ft,
  part = "header"
)

# Font size
ft <- fontsize(
  ft,
  size = 9,
  part = "all"
)

# Autofit columns
ft <- autofit(ft)

# Reduce excessive width
ft <- width(ft, j = "Consensus", width = 0.7)

# Set column widths
ft <- width(ft, j = "rsID", width = 1.4)
ft <- width(ft, j = "Consequence", width = 1.0)
ft <- width(ft, j = "Gene", width = 0.8)

# Frequency column widths
freq_columns <- c(
  "SA_AF",
  "AFR_AF",
  "EUR_AF",
  "AMR_AF",
  "SAS_AF",
  "EAS_AF"
)

for(col in freq_columns){
  
  ft <- width(
    ft,
    j = col,
    width = 0.7
  )
}

# Add caption
ft <- set_caption(
  ft,
  caption = "Clinically actionable pharmacogenomic variants identified in the South African cohort and comparison populations"
)

# ----------------------------
# Export Word Document
# ----------------------------

doc <- read_docx()

doc <- body_add_par(
  doc,
  "Table. Clinically actionable pharmacogenomic variants identified in the South African cohort and comparison populations",
  style = "heading 1"
)

doc <- body_add_flextable(
  doc,
  value = ft
)

print(
  doc,
  target = "Clinically_Actionable_PGx_Variants.docx"
)

# ----------------------------
# Completion Message
# ----------------------------

cat(
  "\nClinically actionable variants table exported successfully!\n"
)