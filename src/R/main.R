rm(list=ls())

setwd('/Users/michaelferon/Projects/ancestry/')
source('./src/R/functions.R')
library(RColorBrewer) # Color schemes.
library(viridis)      # More color schemes.
library(colorspace)   # More color schemes.
library(corrplot)     # Correlation plots.
library(dendextend)   # Dendrograms.
library(readr)        # File input.
library(tidyr)        # Data cleaning (separate).
library(dplyr)        # Data manipulation.


# Get family data.
df <- get.data('./data/family.csv')

# Ethnicity pie chart for each individual.
save.pie.chart(df, './figs/pie.pdf')
save.pie.chart(df, './docs/figs/pie.png', png=TRUE)

# Plot ethnic similarity matrix.
plot.ethnic.similarity(df, './figs/ethnic-similarity.pdf')
plot.ethnic.similarity(df, './docs/figs/ethnic-similarity.png', png=TRUE)

# PCA.
feron.biplots(df, './figs/pca-biplots.pdf')

# Hierarchical clustering.
feron.clust(df, 3, './figs/clust-k3.pdf')
feron.clust(df, 4, './figs/clust-k4.pdf')
