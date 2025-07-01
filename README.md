# Transcriptomic effects of bacterial exposure on *Astrangia poculata* larvae
This repository contains code and data files for a project looking at the effects of bacterial exposure on *Astrangia poculata* larvae using transcriptomics. In this experiment, *A. poculata* larvae were exposed to a control, a pathogen (*Vibrio corallilyticus* - RE22), or a probiotic (*Phaeobacter inhibens* - S4). We then used TagSeq methods to sequence RNA and characterize gene expression from larvae in each treatment. We used DESeq2 to evaluate differential expression of transcripts across treatments and also used gene ontology enrichment analysis to identify broad biological processes enriched or depleted in each of our treatments. The last analysis included in this repository is a weighted gene correlation network analysis (WGCNA) which allowed us to look at transcripts with similar expression profiles and correlate them with our treatments to identify associations between transcript expression and treatment. 

## Citation
Borbee, E.M., Changsut, I.C., Bernabe, K., Schickle, A., Nelson, D., Sharp, K.H., and Fuess, L.E. (2025) Coral larvae have unique transcriptomic responses to pathogenic and probiotic bacteria. *In submission*


## Contents
#### 1. data

This directory contains the input data and metadata files sorted by analysis (i.e. DESeq for differential expression, GO MWU for gene ontology, and WGCNA).

#### 2. figures

This directory contains PNG files of each figure in the manuscript along with separate R code for generating the figures. The one exception is the code for Figure 5 and all the supplemental figures which are contained in the WGCNA jupyter notebook due to the figures involving multiple programs and analysis steps in order to make them.

#### 3. Larval_TagSeq_Processing.ipynb

   Jupyter notebook containing the code used for processing TagSeq reads in preparation for statistical analyses. Read processing was done based on Dr. Mikhail Matz's protocol found on his GitHub page (https://github.com/z0on/tag-based_RNAseq). 
   
#### 4. Differential_Expression_Analysis.ipynb

   Jupyter notebook containing R code and output for the differential expression analysis using DESeq2. This notebook contains code used for generating Figures 1-3.
   
#### 5. Gene_ontology_enrichment_analysis.ipynb

   Jupyter notebook containing the R code and output for gene ontology Mann-Whitney U (GO MWU) enrichment analysis. This code uses the functions from Dr. Mikhail Matz's GitHub (https://github.com/z0on/GO_MWU). This notebook contains code use to generate Figure 4.
   
#### 6. WGCNA_analysis.ipynb

   Jupyter notebook containing code and output for the WGCNA analysis. The first portion of the code focuses on network construction and the second part of the code uses stringDB to calculate functional enrichment in the modules generated in the network. This notebook contains the code used to generate Figures 5-6 and S1-S6.
