# =========================================================
# Create Publication-Ready Table 3
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
  sheet = 5
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
# Create Final Table 3
# ----------------------------

table3 <- df %>%
  
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
# Arrange Genes in Custom Order
# ----------------------------

gene_order <- c(
  "NAT2",
  "CYP2E1",
  "CYP3A4",
  "CYP3A5",
  "GSTM1",
  "GSTP1",
  "GSTT1",
  "CYP2B6",
  "ABCB1",
  "SLCO1B1",
  "UGT2B7",
  "CES2",
  "HLA-B",
  "NR1I2",
  "NR1I3"
)

table3 <- table3 %>%
  
  mutate(
    Gene = factor(Gene, levels = gene_order)
  ) %>%
  
  arrange(Gene)

# Convert Gene back to character
table3$Gene <- as.character(table3$Gene)

# ----------------------------
# Save Excel File
# ----------------------------

write_xlsx(
  table3,
  "Table3_Pharmacogenomic_Variants.xlsx"
)

# ----------------------------
# Create Publication-Ready Word Table
# ----------------------------

ft <- flextable(table3)

# Apply clean table theme
ft <- theme_booktabs(ft)

# Auto adjust column widths
ft <- autofit(ft)

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

# Set font size
ft <- fontsize(
  ft,
  size = 9,
  part = "all"
)

# Add caption
ft <- set_caption(
  ft,
  caption = "Table 3. Frequency of protein-altering variants identified in genes associated with response to anti-tuberculosis drugs"
)

# ----------------------------
# Export Word Document
# ----------------------------

doc <- read_docx()

doc <- body_add_par(
  doc,
  "Table 3. Frequency of protein-altering variants identified in genes associated with response to anti-tuberculosis drugs",
  style = "heading 1"
)

doc <- body_add_flextable(
  doc,
  value = ft
)

print(
  doc,
  target = "Table3_Pharmacogenomic_Variants.docx"
)

# ----------------------------
# Completion Message
# ----------------------------

cat(
  "Table 3 exported successfully as Excel and Word document!\n"
)