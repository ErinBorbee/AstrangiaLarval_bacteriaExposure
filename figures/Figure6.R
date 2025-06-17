#load packages
library(ggplot2)

#set working directory
setwd("~/Desktop/TXST/AstrangiaLarval_transcriptomics/WGCNA/")

#import data
summary_data <- read.csv("enrichment_summary.csv")
head(summary_data)

#add cluster column and sort to the correct plotting order
summary_data <- summary_data %>% mutate(cluster = case_when(module == "salmon" ~ "cluster1",
                                                            module == "sienna3" ~ "cluster1",
                                                            module == "turquoise" ~ "cluster1",
                                                            module == "darkred" ~ "cluster2",
                                                            module == "darkmagenta" ~ "cluster2",
                                                            module == "white" ~ "cluster3",
                                                            module == "green" ~ "cluster3",
                                                            module == "violet" ~ "cluster3",
                                                            module == "steelblue" ~ "cluster3",
                                                            module == "royalblue" ~ "cluster3",
                                                            module == "pink" ~ "cluster3",
                                                            module == "skyblue" ~ "cluster4"))

summary_data$cluster <- factor(summary_data$cluster, levels = c("cluster4","cluster2",
                                                                "cluster3","cluster1"))

#remove zeroes from the dataframe
summary_data_filtered <- subset(summary_data, value != 0)

#plot summary plot and export using ggsave()
summary_plot <- ggplot(summary_data_filtered, aes(group, module, fill = category)) + 
  geom_point(pch = 22, size = 5) +
  facet_grid(cluster~category, space = "free", scale = "free") +
  theme_bw() + theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(strip.background.y = element_blank(), strip.text.y = element_blank()) +
  theme(strip.background.x = element_rect(fill = "black"), 
        strip.text.x = element_text(color = "white", face = "bold"))
summary_plot

ggsave("~/Desktop/enrichment_summary_fig.pdf",summary_plot, height = 6, width = 10)
