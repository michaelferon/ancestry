rm(list=ls())

setwd('/Users/michaelferon/Projects/ancestry/')
source('./src/R/functions.R')
library(RColorBrewer) # Color schemes.
library(colorspace)   # More color schemes.
library(viridis)      # More color schemes.
library(corrplot)     # Correlation plots.
library(dendextend)   # Dendrograms.
library(ape)          # Phylogenetic dendrograms.
library(ggplot2)      # Plotting.
library(patchwork)    # Side-by-side ggplots.
library(ggfortify)    # ggplot PCA.
library(readr)        # File input.
library(stringr)      # String manipulation.
library(tidyr)        # Data cleaning, tidyr::separate().
library(dplyr)        # Data manipulation.


# Get familial data.
df <- get.data('./data/family.csv')
X <- matrix(as.matrix(df[-1]), ncol=ncol(df[-1]),
            dimnames=list(df$name, colnames(df[-1])))

# Ethnicity pie chart for each individual.
save.pie.chart(df, './figs/pie.pdf')
save.pie.chart(df, './docs/figs/pie.png', png=TRUE)

# Plot ethnic similarity matrix.
plot.ethnic.similarity(df, './figs/ethnic-similarity.pdf')
plot.ethnic.similarity(df, './docs/figs/ethnic-similarity.png', png=TRUE)

# PCA.
feron.biplots(X, './figs/pca-biplots.pdf')
feron.biplots(X, './docs/figs/pca-biplots.png', png=TRUE)

# Hierarchical clustering.
feron.clust(X, 3, './figs/clust-k3.pdf')
feron.clust(X, 4, './figs/clust-k4.pdf')
feron.clust(X, 4, './docs/figs/clust-k4.png', png=TRUE)

## TEST
source('./src/R/functions.R')
feron.phylo(X, type='unrooted', file='./docs/figs/phylo.png')




