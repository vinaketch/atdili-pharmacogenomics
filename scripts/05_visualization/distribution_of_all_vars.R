library(ggplot2)
library(readxl)

data <- read_excel("vep_annotation_with_consensus.xlsx")

# Extract the variant consequence (column 8)
consequence <- data[[8]]

# Count frequency of each consequence
consequence_tbl <- table(consequence)

# Convert to a data frame
consequence_df <- as.data.frame(consequence_tbl)
colnames(consequence_df) <- c("Consequence", "Count")

# Calculate percentage
consequence_df$Percent <- (consequence_df$Count / sum(consequence_df$Count)) * 100

# Round for labels
consequence_df$PercentLabel <- ifelse(
  consequence_df$Percent < 0.1,
  "<0.1%",
  sprintf("%.1f%%", consequence_df$Percent)
)

# Create plot
p <- ggplot(consequence_df, aes(x = reorder(Consequence, Percent), y = Percent)) +
  geom_bar(stat = "identity", fill = "#1F77B4") +
  geom_text(aes(label = PercentLabel), hjust = -0.1, size = 7, fontface = "plain") +
  coord_flip() +
  labs(x = "Variant consequence", y = "Percentage of variants") +
  theme_minimal(base_size = 22) +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.y = element_text(size = 20, face = "plain"),
    axis.text.x = element_text(size = 20, face = "plain"),
    axis.title.x = element_text(size = 22, face = "plain"),
    axis.title.y = element_text(size = 22, face = "plain"),
    axis.line.x = element_line(color = "black"),
    axis.ticks.x = element_line(color = "black")
  ) +
  expand_limits(y = max(consequence_df$Percent) * 1.2)

# Display plot
print(p)

# Save as high-resolution PNG
ggsave(
  filename = "Variant_Consequence_Percentages.png",
  plot = p,
  width = 10,
  height = 8,
  dpi = 600
)

# Save as PDF (recommended for publications)
ggsave(
  filename = "Variant_Consequence_Percentages.pdf",
  plot = p,
  width = 10,
  height = 8
)














