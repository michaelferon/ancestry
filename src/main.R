rm(list=ls())

source('./functions.R')
library(RColorBrewer) # Color schemes.
library(viridis)      # More color schemes.
library(corrplot)     # Correlation plots.
library(dendextend)   # Dendrograms.
library(readr)        # File input.
library(tidyr)        # Data cleaning (separate).
library(dplyr)        # Data manipulation.


# Get family data.
df <- get_data()

# Ethnicity pie chart for each individual.
plot_pie_chart(df)

# Plot ethnic similarity matrix.
plot_ethnic_similarity(df)

# PCA.
feron_biplots(df)

# Hierarchical clustering.
feron_clust(df)
