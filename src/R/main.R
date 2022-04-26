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
save.pie.chart(df, './img/pie.pdf')
save.pie.chart(df, './docs/img/pie.png', png=TRUE)

# Plot ethnic similarity matrix.
plot.ethnic.similarity(df, './img/ethnic-similarity.pdf')
plot.ethnic.similarity(df, './docs/img/ethnic-similarity.png', png=TRUE)

# PCA.
feron.biplots(X, './img/pca-biplots.pdf')
feron.biplots(X, './docs/img/pca-biplots.png', png=TRUE)

# Hierarchical clustering.
feron.clust(X, 3, './img/clust-k3.pdf')
feron.clust(X, 4, './img/clust-k4.pdf')
feron.clust(X, 4, './docs/img/clust-k4.png', png=TRUE)

# Phylogenetic style hierarchical clustering.
feron.phylo(X, type='unrooted', file='./docs/img/phylo.png')
