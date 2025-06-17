#load packages
library(ggplot2)

#set working directory
setwd("~/Desktop/TXST/AstrangiaLarval_transcriptomics/finalTranscriptome/DESeq/")

#import data
data_RE22 <- read.csv("DESeq_RE22vControl.csv")
data_S4 <- read.csv("DESeq_S4vControl.csv")
data_RE22S4 <- read.csv("DESeq_RE22vS4.csv")

#Add comparison column to dataframes and format column headers
names(data_RE22)[1] <- "transcript"
names(data_S4)[1] <- "transcript"
names(data_RE22S4)[1] <- "transcript"

data_RE22$comparison <- "RE22vControl"
data_S4$comparison <- "S4vControl"
data_RE22S4$comparison <- "RE22vS4"

#filter to only significant transcripts
data_RE22_sig <- subset(data_RE22, padj < 0.1 & abs(log2FoldChange) > 2)
data_S4_sig <- subset(data_S4, padj < 0.1 & abs(log2FoldChange) > 2)
data_RE22S4_sig <- subset(data_RE22S4, padj < 0.1 & abs(log2FoldChange) > 2)

#merge dataframes into one for all data and one for significant data
merged_data <- rbind(data_RE22, data_S4, data_RE22S4)
merged_sig_data <- rbind(data_RE22_sig, data_S4_sig, data_RE22S4_sig)

#filter to only transcripts significant in at least one comparison
filtered_data <- subset(merged_data, transcript %in% merged_sig_data$transcript)

#add two columns to the dataframe, one indicating significance and one indicating sign (positive/negative)
filtered_data <- transform(filtered_data, sig = ifelse(padj < 0.1, ifelse(abs(log2FoldChange) > 2,"yes", "no"),"no"))
filtered_data <- transform(filtered_data, sign = ifelse(log2FoldChange < 0, "negative", "positive"))

#import annotations
annotations <- read.table("../astrangia_annos_clean.txt", sep= "\t", header = TRUE, fill = TRUE, quote = "")

#merge annotations with filtered differential expression data and replace blank entries with "unannotated"
merged_annotation <- merge(filtered_data, annotations, all.x = TRUE)
merged_annotation$GO_names[is.na(merged_annotation$GO_names)] <- "unannotated"

#add a significance column
merged_annotation <- merged_annotation %>% mutate(sig = case_when(padj > 0.1 | abs(log2FoldChange) < 2 ~ "no",
                                                                  padj < 0.1 | abs(log2FoldChange) > 2 ~ "yes"))

#plot bubble plot where size of bubble represents abs(LFC) color indicates comparison, direction (positive/negative), and significance
bubble_plot <- ggplot(merged_annotation, aes(comparison, transcript, 
                                             size = abs(log2FoldChange), 
                                             color = sig, 
                                             fill = interaction(sign, sig, comparison))) + 
  geom_point(pch = 21) + 
  theme(axis.text.x = element_text(angle = 90)) + 
  scale_size_continuous(range = c(0,7.5))  + 
  scale_color_manual(values = c('yes' = "black",
                                'no' = "white"), 
                     na.value = "black") +
  theme(axis.title = element_blank()) + 
  theme(legend.position = "bottom") + 
  scale_fill_manual(values = c('positive.yes.RE22vControl' = "#E84649",
                               'positive.yes.S4vControl' = "#42ACBD",
                               'positive.yes.RE22vS4' = "#A86DA0",
                               'negative.yes.RE22vControl' = "#960011",
                               'negative.yes.S4vControl' = "#006474",
                               'negative.yes.RE22vS4' = "#6e3768",
                               'positive.no.RE22vControl' = "grey",
                               'positive.no.S4vControl' = "grey",
                               'positive.no.RE22vS4' = "grey",
                               'negative.no.RE22vControl' = "grey",
                               'negative.no.S4vControl' = "grey",
                               'negative.no.RE22vS4' = "grey"))
bubble_plot

#filter the merged dataframe to only significantly differentially expressed transcripts
merged_annotation_sig <- subset(merged_annotation, padj < 0.1)

#again make sure that NAs in the annotation columns are replaced with "unannotated"
merged_annotation_sig$GO_names[is.na(merged_annotation_sig$GO_names)] <- "unannotated"
merged_annotation_sig$GO_names[ merged_annotation_sig$GO_names == ""] <- "unannotated"
merged_annotation_sig$geneID[merged_annotation_sig$geneID == ""] <- NA

#add a pseudocount column where every value is one, this will be used for the barplot
merged_annotation_sig$count <- 1

#plot barplot where the x axis is the comparison and the y axis is the count of significantly differentially expressed transcripts
barplot <- ggplot(merged_annotation_sig, aes(comparison, count, fill = geneID)) + 
  geom_bar(stat = "identity", width = 0.5, position = position_stack(reverse = TRUE)) +
  theme(legend.position = "none") +
  theme(axis.title.x = element_blank(), axis.text.x = element_blank()) + 
  scale_fill_manual(values = c("#a9c2d0",
                               "grey60")) 
barplot 

#merge bubble plot and barplot to form one two panel plot then export using ggasve
annotation_plot <- ggarrange(barplot, bubble_plot, nrow = 2, ncol = 1, align = "v", heights = c(0.33,1))
annotation_plot

ggsave("~/Desktop/annotation_plot.pdf", annotation_plot, height = 8, width = 4)






