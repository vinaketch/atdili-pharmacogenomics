# =========================================================
# Variant Consequence Analysis and Visualization
# Combined Script
# =========================================================

# ---------------------------
# 1. Load Required Packages
# ---------------------------
library(ggplot2)
library(readxl)
library(dplyr)

# ---------------------------
# 2. Load Data
# ---------------------------

data <- read_excel(
  "C:/School work/PhD project/ATDILI_PGX/Objective 2_Genomics/vep_results/vep_2/matching_AFs/Merged_VEP_AF_annotations.xlsx"
)

# ---------------------------
# 3. Extract Consequence Column
# ---------------------------

consequence_col <- data[[3]]

# ---------------------------
# 4. Count Frequencies
# ---------------------------

consequence_tbl <- table(consequence_col)

# Convert to dataframe
consequence_df <- as.data.frame(consequence_tbl)

colnames(consequence_df) <- c(
  "Consequence",
  "Count"
)

# ---------------------------
# 5. Calculate Percentages
# ---------------------------

consequence_df$Percentage <- (
  consequence_df$Count /
    sum(consequence_df$Count)
) * 100

# ---------------------------
# 6. Create Labels
# ---------------------------

consequence_df$PercentLabel <- ifelse(
  consequence_df$Percentage < 0.1,
  "<0.1%",
  sprintf(
    "%.1f%%",
    consequence_df$Percentage
  )
)

# =========================================================
# PART A:
# HORIZONTAL BAR PLOT
# =========================================================

barplot_data <- consequence_df

# Create bar plot
p_bar <- ggplot(
  barplot_data,
  aes(
    x = reorder(
      Consequence,
      Percentage
    ),
    y = Percentage
  )
) +
  
  geom_bar(
    stat = "identity",
    fill = "#1F77B4"
  ) +
  
  geom_text(
    aes(label = PercentLabel),
    hjust = -0.1,
    size = 14,
    color = "black"
  ) +
  
  coord_flip() +
  
  labs(
    x = "Variant consequence",
    y = "Percentage of variants"
  ) +
  
  scale_y_continuous(
    expand = c(0, 0)
  ) +
  
  theme_minimal(base_size = 40) +
  
  theme(
    
    # Remove gridlines
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    
    # Axis text
    axis.text.y = element_text(
      size = 36,
      color = "black"
    ),
    
    axis.text.x = element_text(
      size = 36,
      color = "black"
    ),
    
    # Axis titles
    axis.title.x = element_text(
      size = 40,
      color = "black"
    ),
    
    axis.title.y = element_text(
      size = 40,
      color = "black"
    ),
    
    # Axis lines
    axis.line.x = element_line(
      color = "black",
      linewidth = 1.5
    ),
    
    axis.line.y = element_line(
      color = "black",
      linewidth = 1.5
    ),
    
    # Axis ticks
    axis.ticks.x = element_line(
      color = "black",
      linewidth = 1.5
    ),
    
    axis.ticks.y = element_line(
      color = "black",
      linewidth = 1.5
    )
  ) +
  
  expand_limits(
    y = max(
      barplot_data$Percentage
    ) * 1.25
  )

# Display bar plot
print(p_bar)

# Save bar plot
ggsave(
  filename = "variant_consequence_percentages.png",
  plot = p_bar,
  width = 20,
  height = 16,
  dpi = 800
)

# =========================================================
# PART B:
# DONUT PLOT
# =========================================================

# Group small categories into Others
donut_data <- consequence_df %>%
  
  mutate(
    Consequence = ifelse(
      Percentage < 5.9,
      "Others",
      as.character(Consequence)
    )
  ) %>%
  
  group_by(Consequence) %>%
  
  summarise(
    Count = sum(Count),
    Percentage = sum(Percentage),
    .groups = "drop"
  ) %>%
  
  arrange(desc(Percentage))

# Keep legend order
donut_data$Consequence <- factor(
  donut_data$Consequence,
  levels = donut_data$Consequence
)

# Labels
donut_data$PercentLabel <- sprintf(
  "%.1f%%",
  donut_data$Percentage
)

# Donut positions
donut_data <- donut_data %>%
  
  mutate(
    ymax = cumsum(Percentage),
    ymin = c(
      0,
      head(ymax, n = -1)
    ),
    labelPosition = (
      ymax + ymin
    ) / 2
  )

# Create donut plot
p_donut <- ggplot(
  donut_data,
  aes(
    ymax = ymax,
    ymin = ymin,
    xmax = 4,
    xmin = 2,
    fill = Consequence
  )
) +
  
  geom_rect(
    color = "white",
    linewidth = 1.5
  ) +
  
  geom_text(
    aes(
      x = 3,
      y = labelPosition,
      label = PercentLabel
    ),
    color = "black",
    size = 9
  ) +
  
  coord_polar(theta = "y") +
  
  xlim(c(0, 5)) +
  
  labs(
    title = "Distribution of Novel Variant Consequences",
    fill = "Variant Consequence"
  ) +
  
  theme_void(base_size = 28) +
  
  theme(
    plot.title = element_text(
      size = 34,
      hjust = 0.5
    ),
    
    legend.position = "right",
    
    legend.title = element_text(
      size = 26
    ),
    
    legend.text = element_text(
      size = 24
    ),
    
    panel.background = element_rect(
      fill = "white",
      color = "white"
    ),
    
    plot.background = element_rect(
      fill = "white",
      color = "white"
    )
  )

# Display donut plot
print(p_donut)

# Save donut plot
ggsave(
  filename = "novel_variant_consequence_donut_plot.png",
  plot = p_donut,
  width = 16,
  height = 13,
  dpi = 600,
  bg = "white"
)

# =========================================================
# 7. Show Working Directory
# =========================================================

getwd()