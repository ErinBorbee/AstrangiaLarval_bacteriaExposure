# Transcriptomic effects of bacterial exposure on *Astrangia poculata* larvae
This repository contains code and data files for a project looking at the effects of bacterial exposure on *Astrangia poculata* larvae using transcriptomics. In this experiment, *A. poculata* larvae were exposed to a control, a pathogen (*Vibrio corallilyticus* - RE22), or a probiotic (*Phaeobacter inhibens* - S4). We then used TagSeq methods to sequence RNA and characterize gene expression from larvae in each treatment. We used DESeq2 to evaluate differential expression of transcripts across treatments and also used gene ontology enrichment analysis to identify broad biological processes enriched or depleted in each of our treatments. The last analysis included in this repository is a weighted gene correlation network analysis (WGCNA) which allowed us to look at transcripts with similar expression profiles and correlate them with our treatments to identify associations between transcript expression and treatment. 

## Citation
Borbee, E.M., Changsut, I.C., Bernabe, K., Schickle, A., Nelson, D., Sharp, K.H., and Fuess, L.E. (2025) Coral larvae have unique transcriptomic responses to pathogenic and probiotic bacteria. *In prep*


## Contents
1. Larval_TagSeq_Processing.ipynb

   Jupyter notebook containing the code used for processing TagSeq reads in preparation for statistical analyses. Read processing was done based on Dr. Mikhail Matz's protocol found on his GitHub page (https://github.com/z0on/tag-based_RNAseq). 
3. Differential_Expression_Analysis.ipynb

   Jupyter notebook containing R code and output for the differential expression analysis using DESeq2. This notebook contains code used for generating Figures 1-3.
5. Gene_ontology_enrichment_analysis.ipynb

   Jupyter notebook containing the R code and output for gene ontology Mann-Whitney U (GO MWU) enrichment analysis. This code uses the functions from Dr. Mikhail Matz's GitHub (https://github.com/z0on/GO_MWU). This notebook contains code use to generate Figure 4.
7. WGCNA_analysis.ipynb

   Jupyter notebook containing code and output for the WGCNA analysis. The first portion of the code focuses on network construction and the second part of the code uses stringDB to calculate functional enrichment in the modules generated in the network. This notebook contains the code used to generate Figures 5-6 and S1-S6.
