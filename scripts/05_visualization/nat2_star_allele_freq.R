# ==========================================================
# NAT2 Diplotype Frequency Comparison
# South African cohort vs global populations
# ==========================================================

library(readxl)
library(tidyverse)
library(janitor)

# ==========================================================
# Read data
# ==========================================================

df <- read_excel(
  "Clinically_Actionable_PGx_Star_Alleles.xlsx",
  sheet = 2
) %>%
  clean_names()

# ==========================================================
# Clean data
# ==========================================================

df[df == "nr"] <- NA

freq_cols <- c(
  "south_african_cohort",
  "african",
  "european",
  "south_asian",
  "east_asian"
)

df <- df %>%
  mutate(
    across(all_of(freq_cols), as.numeric)
  )

# ==========================================================
# Order diplotypes by SA cohort frequency
# ==========================================================

genotype_order <- df %>%
  arrange(desc(south_african_cohort)) %>%
  pull(genotypes)

# ==========================================================
# Long format
# ==========================================================

df_long <- df %>%
  pivot_longer(
    cols = all_of(freq_cols),
    names_to = "population",
    values_to = "frequency"
  ) %>%
  filter(!is.na(frequency)) %>%
  mutate(
    
    frequency = frequency * 100,
    
    genotypes = factor(
      genotypes,
      levels = genotype_order
    ),
    
    population = factor(
      population,
      levels = c(
        "south_african_cohort",
        "african",
        "european",
        "south_asian",
        "east_asian"
      ),
      labels = c(
        "SA Cohort",
        "SSA",
        "EUR",
        "SAS",
        "EAS"
      )
    )
  )

# ==========================================================
# Plot
# ==========================================================

p <- ggplot(
  df_long,
  aes(
    x = genotypes,
    y = frequency,
    fill = population
  )
) +
  
  geom_col(
    position = position_dodge(width = 0.8),
    width = 0.70,
    colour = "white",
    linewidth = 0.25
  ) +
  
  scale_fill_brewer(
    palette = "Set2"
  ) +
  
  labs(
    x = "NAT2 diplotype",
    y = "Frequency (%)",
    fill = "Population"
  ) +
  
  theme_classic(base_size = 12) +
  
  theme(
    
    axis.text.x = element_text(
      angle = 45,
      hjust = 1,
      face = "bold"
    ),
    
    axis.text.y = element_text(
      face = "bold"
    ),
    
    axis.title = element_text(
      face = "bold"
    ),
    
    legend.position = "bottom",
    
    legend.title = element_text(
      face = "bold"
    )
  )

print(p)

# ==========================================================
# Save
# ==========================================================

ggsave(
  "NAT2_Diplotype_Frequency_Comparison.png",
  p,
  width = 11,
  height = 6,
  dpi = 600,
  bg = "white"
)

ggsave(
  "NAT2_Diplotype_Frequency_Comparison.pdf",
  p,
  width = 11,
  height = 6,
  bg = "white"
)

ggsave(
  "NAT2_Diplotype_Frequency_Comparison.tiff",
  p,
  width = 11,
  height = 6,
  dpi = 600,
  compression = "lzw",
  bg = "white"
)