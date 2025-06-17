#load packages
library(ggplot2)

#set working directory
setwd("~/Desktop/TXST/AstrangiaLarval_transcriptomics/finalTranscriptome/GO_MWU/")

#import data
RE22vControl <- read.table("MWU_MF_DEseq_RE22vControl_LFC.csv", sep = " ", header = TRUE)
RE22vS4 <- read.table("MWU_MF_DEseq_RE22vS4_LFC.csv", sep = " ", header = TRUE)
S4vControl <- read.table("MWU_MF_DEseq_S4vControl_LFC.csv", sep = " ", header = TRUE)

RE22vControl$comparison <- "RE22 vs Control"
RE22vS4$comparison <- "RE22 vs S4"
S4vControl$comparison <- "S4 vs Control"

merged_data <- rbind(RE22vControl, RE22vS4, S4vControl)

sig_data <- subset(merged_data, p.adj < 0.1)
filtered_data <- subset(merged_data, name %in% sig_data$name)
filtered_data$comparison <- factor(filtered_data$comparison, levels = c("S4 vs Control","RE22 vs S4","RE22 vs Control"))
filtered_data <- filtered_data %>% mutate(sig = case_when(p.adj > 0.1 ~ "not sig",
                                                          p.adj > 0.05 ~ "sig",
                                                          p.adj < 0.05 ~ "very sig",
                                                          ))
sig_data <- transform(sig_data, sig = ifelse(p.adj > 0.05, "no","yes"))
                    
plot <- ggplot(sig_data, aes(delta.rank, name, fill = interaction(comparison, sig))) + geom_bar(stat = "identity", position = position_dodge2(width = 1, preserve = "single")) +
  theme_bw() + theme(panel.grid = element_line(color = "grey90")) + theme(axis.title.y = element_blank()) + 
  scale_x_continuous(expand = c(0,0), limits = c(-300,650)) + scale_fill_manual(values = c('S4 vs Control.no' = "#7bcedc",
                                                                                'S4 vs Control.yes' = "#0096ad",
                                                                                'RE22 vs Control.no' = "#ff9290",
                                                                                'RE22 vs Control.yes' = "#ee5559",
                                                                                'RE22 vs S4.no' = "#dca6da",
                                                                                'RE22 vs S4.yes' = "#a566a4"), labels = c('S4 vs Control.no' = "Probiotic v Control\n(0.05 < p < 0.1)",
                                                                                                                          'S4 vs Control.yes' = "Probiotic v Control\n(p < 0.05)",
                                                                                                                          'RE22 vs Control.no' = "Pathogen v Control\n(0.05 < p < 0.1)",
                                                                                                                          'RE22 vs Control.yes' = "Pathogen v Control\n(p < 0.05)",
                                                                                                                          'RE22 vs S4.no' = "Pathogen v Probiotic\n(0.05 < p < 0.1)",
                                                                                                                          'RE22 vs S4.yes' = "Pathogen v Probiotic\n(p < 0.05)")) +
  xlab("delta rank") + theme(legend.position = "bottom") + theme(axis.text.y = element_text(face = "bold")) + guides(fill = guide_legend(title = "Comparison\n(p-value)", ncol = 3, nrow = 2)) + 
  theme(legend.title = element_text(hjust = 0.5)) + geom_vline(xintercept = 0, lwd = 0.35) + facet_grid(~comparison, labeller = labeller(comparison = c("RE22 vs Control" = "Pathogen vs Control",
                                                                                                                                                        "RE22 vs S4" = "Pathogen vs Probiotic",
                                                                                                                                                        "S4 vs Control" = "Probiotic vs Control"))) + 
  theme(strip.background = element_rect(fill = "black"), strip.text = element_text(face = "bold", color = "white"))
plot
ggsave("~/Desktop/GO_MWU_plot.pdf", plot, height = 5, width = 9)
