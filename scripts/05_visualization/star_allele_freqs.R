# =====================================================
# Publication-ready Star Allele Frequency Plot
# =====================================================
library(readxl)
library(tidyverse)
library(janitor)
library(tidytext)

df <- read_excel("Clinically_Actionable_PGx_Star_Alleles.xlsx") %>%
  clean_names()

df[df=="nr"] <- NA
df[df==""] <- NA

df <- df %>%
  mutate(across(c(sa_cohort,ssa,eur,sas,eas),
                ~as.numeric(trimws(as.character(.)))))

df_long <- df %>%
  pivot_longer(c(sa_cohort,ssa,eur,sas,eas),
               names_to="population",
               values_to="frequency") %>%
  filter(!is.na(frequency)) %>%
  mutate(
    population=factor(toupper(population),
                      levels=c("SA_COHORT","SSA","EUR","SAS","EAS"),
                      labels=c("SA Cohort","SSA","EUR","SAS","EAS")),
    frequency=frequency*100,
    gene=factor(
      gene,
      levels=c("NAT2","CYP2A6","CYP2D6","CYP2B6","CYP3A4", "CYP3A5","CYP2C19","CYP2C9","CYP2C8","CYP4F2", "TPMT","SLCO1B1"),
      labels=c("(a) NAT2","(b) CYP2A6", "(c) CYP2D6","(d) CYP2B6","(e) CYP3A4","(f) CYP3A5","(g) CYP2C19","(h) CYP2C9","(i) CYP2C8","(j) CYP4F2", "(k) TPMT","(m) SLCO1B1")
    ),
    allele_num=as.numeric(stringr::str_extract(allele,"\\d+")),
    allele=reorder_within(allele,allele_num,gene)
  )

p <- ggplot(df_long,aes(allele,frequency,fill=population))+
  geom_col(position=position_dodge(.8),width=.7,colour="white",linewidth=.25)+
  facet_wrap(~gene,ncol=3,scales="free_x")+
  scale_x_reordered()+
  scale_fill_brewer(palette="Set2")+
  labs(x="Star allele",y="Allele frequency (%)",fill="Population")+
  theme_classic(base_size=12)+
  theme(
    strip.text=element_text(face="bold",size=11),
    axis.text.x=element_text(angle=45,hjust=1,size=8),
    axis.text.y=element_text(face="bold"),
    axis.title=element_text(face="bold"),
    legend.position="bottom",
    legend.title=element_text(face="bold"),
    panel.spacing=grid::unit(1,"lines")
  )

print(p)

ggsave("haplotype_frequency_plot.png",p,width=14,height=8,dpi=600,bg="white")
ggsave("haplotype_frequency_plot.pdf",p,width=14,height=8,bg="white")
ggsave("haplotype_frequency_plot.tiff",p,width=14,height=8,dpi=600,compression="lzw",bg="white")
