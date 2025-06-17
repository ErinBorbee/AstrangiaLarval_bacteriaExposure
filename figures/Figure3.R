#load packages
library(ggplot2)
library(ggvenn)
library(ggpubr)

#set working directory
setwd("~/Desktop/TXST/AstrangiaLarval_transcriptomics/finalTranscriptome/DESeq/")

#import data
RE22 <- read.csv("DESeq_RE22vControl.csv")
S4 <- read.csv("DESeq_S4vControl.csv")

#filter to only the significant transcripts
RE22_filtered <- subset(RE22, padj < 0.1 & abs(log2FoldChange) > 2)
S4_filtered <- subset(S4, padj < 0.1 & abs(log2FoldChange) > 2)

#add comparison column
RE22_filtered$comparison <- "RE22vControl"
S4_filtered$comparison <- "S4vControl"

#create venn object
venn <- list('RE22vControl' = RE22_filtered$X,
             'S4vControl' = S4_filtered$X)

#construct venn diagram
venn_diagram <- ggvenn(venn, c("RE22vControl","S4vControl"), fill_color = c("#E84649","#42ACBD"), fill_alpha = 0.75)
venn_diagram

#merge two data frames together for plotting a boxplot
merged_data <- rbind(RE22_filtered, S4_filtered)
merged_data

#add a color column to the dataframe
merged_data$color <- c("RE22","shared","shared","RE22","shared","S4","S4","S4","S4","S4","S4","shared","S4")

boxplot <- ggplot(merged_data, aes(comparison, log2FoldChange)) + 
  geom_violin(alpha = 0.75, aes(fill = comparison)) +
  geom_boxplot(width = 0.1, color = "black", aes(fill = comparison)) + 
  geom_point(shape = 21, aes(fill = color)) + 
  scale_fill_manual(values = c('RE22vControl' = "#E84649",
                               'S4vControl' = "#42ACBD",
                               'S4' = "#42ACBD",
                               'shared' = "black")) +
  ylab("Log2 Fold Change") +
  theme(legend.position = "bottom") + 
  theme(panel.grid = element_blank())
boxplot

#filter to only transcripts shared between comparisons
merged_data_filtered <- subset(merged_data, X %in% RE22_filtered$X)
merged_data_filtered <- subset(merged_data_filtered, merged_data_filtered$X %in% S4_filtered$X)

RE22_merged_data_filtered <- subset(merged_data_filtered, comparison == "RE22vControl")
S4_merged_data_filtered <- subset(merged_data_filtered, comparison == "S4vControl")

#make sure rows are in the same order between dataframes
RE22_merged_data_filtered <- RE22_merged_data_filtered[order(RE22_merged_data_filtered$X),]
S4_merged_data_filtered <- S4_merged_data_filtered[order(S4_merged_data_filtered$X),]

RE22_merged_data_filtered$X
S4_merged_data_filtered$X

#build new dataframe with separate columns for LFC in each comparison
LFC_data <- as.data.frame(RE22_merged_data_filtered$X)
LFC_data$LFC_RE22 <- RE22_merged_data_filtered$log2FoldChange
LFC_data$LFC_S4 <- S4_merged_data_filtered$log2FoldChange

LFC_data

#add a color column to indicate which comparison that transcript has stronger log fold change in
LFC_data$color <- c("S4","RE22","RE22")

#plot log fold change comparison
LFC_plot <- ggplot(LFC_data, aes(LFC_S4, LFC_RE22, fill = color)) + 
  geom_point(pch = 21, size = 4) + 
  geom_abline(slope = 1, intercept = 0, lty = 2) + 
  xlim(0,4.5) + 
  ylim(0,4.5) + 
  scale_fill_manual(values = c("#E84649","#42ACBD")) + 
  xlab("Log2 Fold Change in Probiotic") + 
  ylab("Log2 Fold Change in Pathogen") +
  theme(legend.position = "bottom")
LFC_plot

#arrange all plots into one multipanel plot
merged_plot <- ggarrange(venn_diagram, ggarrange(boxplot, LFC_plot, align = "hv", labels = c("b.","c.")), 
                         align = "hv", nrow = 2, ncol = 1, labels = c("a.",""), heights = c(1,2))
merged_plot
