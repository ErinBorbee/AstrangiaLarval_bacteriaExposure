#load packages
library(ggplot2)

#set working directory 
setwd("~/Desktop/TXST/AstrangiaLarval_transcriptomics/finalTranscriptome/DESeq")

#import data for each comparison and add a column to indicate the comparison to each
RE22vControl <- read.csv("DESeq_RE22vControl.csv")
names(RE22vControl)[1] <- "transcript"
RE22vControl$comparison <- "RE22vControl"

S4vControl <- read.csv("DESeq_S4vControl.csv")
names(S4vControl)[1] <- "transcript"
S4vControl$comparison <- "S4vControl"

RE22vS4 <- read.csv("DESeq_RE22vS4.csv")
names(RE22vS4)[1] <- "transcript"
RE22vS4$comparison <- "RE22vS4"

#merge the three dataframes into one
DESeq_merged <- rbind(RE22vControl, S4vControl, RE22vS4)

#add a column to the merged dataframe to indicate significance
DESeq_merged <- DESeq_merged %>% mutate(sig = case_when(padj > 0.1 | abs(log2FoldChange) < 2 ~ "no",
                                                        padj < 0.1 | abs(log2FoldChange) > 2 ~ "yes"))


#set plotting theme
theme_set(theme_bw() + 
            theme(panel.grid = element_blank()) + 
            theme(strip.background = element_rect(fill = "black"), 
                  strip.text = element_text(face = "bold", color = "white")))

#plot volcano plots
volcano_plot <- ggplot(DESeq_merged, aes(log2FoldChange, -log(padj), 
                                         fill = interaction(sig, comparison), 
                                         color = interaction(sig, comparison))) +
                geom_point(size = 3, pch = 21) + 
                facet_grid(~comparison) + 
                geom_hline(yintercept = 1, lty = 2) +
                geom_vline(xintercept = -2, lty = 2) + 
                geom_vline(xintercept = 2, lty = 2) +
                xlim(-9,9) + 
                scale_fill_manual(values = c('no.RE22vControl' = "grey",
                                             'yes.RE22vControl' = "#E84649",
                                             'no.S4vControl' = "grey",
                                             'yes.S4vControl' = "#42ACBD",
                                             'no.RE22vS4' = "grey",
                                             'yes.RE22vS4' = "#A86DA0")) +
                scale_color_manual(values = c('no.RE22vControl' = "grey",
                                              'yes.RE22vControl' = "black",
                                              'no.S4vControl' = "grey",
                                              'yes.S4vControl' = "black",
                                              'no.RE22vS4' = "grey",
                                              'yes.RE22vS4' = "black")) + 
                xlab("log2 Fold Change")
volcano_plot

#export using ggsave
ggsave("Figure1.pdf", volcano_plot, width = 10, height = 5)