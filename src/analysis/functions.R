## functions.R

# Applies function, f, to nC2 combinations of matrix columns resulting in (n x n) matrix.
my.outer <- function(X, f) {
  n <- ncol(X)
  out <- sapply(1:n, function(i) sapply(1:n, function(j) f(X[, i], X[, j])))
  colnames(out) <- colnames(X)
  rownames(out) <- colnames(out)
  return(out)
}

# Hellinger distance function.
f.hellinger <- function(p, q) {
  return( 1 - (1/sqrt(2) * sqrt(sum((sqrt(p) - sqrt(q))^2))) )
}

# Adjusted correlation function.
adj.cor <- function(p, q) {
  inds <- p == 0 & q == 0
  p <- p[!inds]
  q <- q[!inds]
  return(cor(p, q))
}

# Loads familial data.
get.data <- function(file) {
  df <- read_csv(file) %>%
    mutate_if(is.numeric, function(x) x / 100) %>%
    rename(name = Name)
  
  # Check that relative frequencies sum to 1.
  test <- apply(df[-1], 1, sum)
  if (any(test != 1)) {
    message(paste('Data error:', paste(df$Name[which(test != 1)], collapse=', ')))
  }
  return(df)
}

# Generates ethnicity pie chart and saves to pdf.
save.pie.chart <- function(df, file, png=FALSE) {
  # Color scheme for n=14 different ethnicities.
  regions <- colnames(df)[-1]
  cols <- vector(mode='character', length=length(regions))
  cols[!(regions %in% c('Finland', 'Sardinia'))] <- RColorBrewer::brewer.pal(12, 'Set3')
  cols[regions %in% c('Finland', 'Sardinia')] <- c('#FFFFFF', '#000000')

  if (png) {
    png(file=file, height=5000, width=2500)
      cex=3.5
      par(mfrow=c(6, 2), mar=c(6, 0, 4, 10) + 0.1)
      for (n in 1:nrow(df)) {
        temp <- df %>%
          slice(n)
        inds <- which(temp[-1] != 0)
        pie(as.numeric(temp[-1][inds]), labels=names(temp)[-1][inds],
            col=cols[inds], radius=0.8, cex=cex, cex.main=cex)
        title(temp[1], cex.main=1.15*cex, line=-3.5)
      }
    dev.off()
  } else {
    pdf(file=file, height=25, width=10)
      par(mfrow=c(6, 2), mar=c(5, 0, 4, 4) + 0.1)
      for (n in 1:nrow(df)) {
        temp <- df %>%
          slice(n)
        inds <- which(temp[-1] != 0)
        pie(as.numeric(temp[-1][inds]), labels=names(temp)[-1][inds], main=temp[1],
            col=cols[inds], radius=0.9)
      }
    dev.off()
  }
}

# Plots ethnic similarity scores.
plot.ethnic.similarity <- function(df, file, png=FALSE) {
  X <- t(df[-1])
  colnames(X) <- df$name
  
  # Compute ethnic correlation, adj. correlation, and Hellinger distance.
  family.cor <- my.outer(X, cor)
  family.cor.adj <- my.outer(X, adj.cor)
  hellinger <- my.outer(X, f.hellinger)
  
  # Ethnic similarity matrices.
  if (png) {
    png(file=file, height=7, width=14, units='in', res=500)
      par(mfrow=c(1, 2), oma=c(0, 0, 0, 0))
      range <- range(c(family.cor.adj, hellinger))
      corrplot(family.cor.adj, method='color', type='lower', is.corr=TRUE, diag=FALSE,
               tl.col='black', tl.srt=45, mar=c(0, 0, 2, 0), col.lim=range,
               title='Correlation', cex.main=1.15)
      corrplot(hellinger, method='color', type='lower', is.corr=FALSE, diag=FALSE,
               tl.col='black', tl.srt=45, mar=c(0, 0, 2, 0),
               title='Hellinger Distance', cex.main=1.15)
    dev.off()
  } else {
    pdf(file=file, height=7, width=14)
      par(mfrow=c(1, 2), oma=c(0, 0, 2, 0))
      range <- range(c(family.cor.adj, hellinger))
      corrplot(family.cor.adj, method='color', type='lower', is.corr=TRUE, diag=FALSE,
               tl.col='black', tl.srt=45, mar=c(0, 0, 2, 0), col.lim=range,
               title='Correlation')
      corrplot(hellinger, method='color', type='lower', is.corr=FALSE, diag=FALSE,
               tl.col='black', tl.srt=45, mar=c(0, 0, 2, 0),
               title='Hellinger Distance')
      mtext('Ethnic Similarity Score', side=3, line=4, adj=-0.3, cex=1.5)
    dev.off()
  }

}

# PCA biplots.
get.pca.biplot <- function(X, do.scale=FALSE, title='Un-Standardized') {
  rownames(X) <- sapply(str_split(rownames(X), ' '), function(x) x[1])
  pc <- prcomp(X, scale=do.scale)
  pc$x[, 2] <- -pc$x[, 2]; pc$rotation[, 2] <- -pc$rotation[, 2]
  
  g <- autoplot(pc, data=X, label=TRUE, shape=FALSE, loadings=TRUE, loadings.label=TRUE) +
    theme_bw() +
    ggtitle(title)
  return(g)
}
feron.biplots <- function(X, file, png=FALSE) {
  g <- get.pca.biplot(X)
  q <- get.pca.biplot(X, do.scale=TRUE, 'Standardized')
  
  device=ifelse(png, 'png', 'pdf')
  ggsave(file, plot = g + q, height=7, width=14, device=device, units='in', scale=1.00)
}

# Hierarchical clustering dendrograms.
feron.clust <- function(X, k, file, png=FALSE) {
  family.cor.adj <- my.outer(t(X), adj.cor)
  
  if (png) {
    png(file=file, height=7, width=14, units='in', res=500)
      par(mfrow=c(1, 2), mar=c(6, 4, 3, 2) + 0.1)
      clust.dist <- as.dendrogram(hclust(dist(X), method='complete')) %>%
        color_branches(k = k) %>%
        set("branches_lty", c(1,2,1,2)) %>%
        color_labels(k = k)
      clust.corr <- as.dendrogram(hclust(as.dist(1 - family.cor.adj), method='complete')) %>%
        color_branches(k = k) %>%
        set("branches_lty", c(1,2,1,2)) %>%
        color_labels(k = k)
      plot(clust.dist, main='Euclidean Metric')
      plot(clust.corr, main='Correlation-based Metric')
    dev.off()
  } else {
    pdf(file=file, height=7, width=11)
      par(mfrow=c(1, 2), mar=c(7, 4, 7, 2) + 0.1)
      clust.dist <- as.dendrogram(hclust(dist(X), method='complete')) %>%
        color_branches(k = k) %>%
        set("branches_lty", c(1,2,1,2)) %>%
        color_labels(k = k)
      clust.corr <- as.dendrogram(hclust(as.dist(1 - family.cor.adj), method='complete')) %>%
        color_branches(k = k) %>%
        set("branches_lty", c(1,2,1,2)) %>%
        color_labels(k = k)
      plot(clust.dist, main='Euclidean Metric')
      plot(clust.corr, main='Correlation-based Metric')
      mtext(paste0('Complete-Linkage Hierarchical Clustering, k = ', k),
            side=3, line=5.5, adj=3.0, cex=1.5)
    dev.off()
  }
}

feron.phylo <- function(X, type='fan', file) {
  Y <- X
  rownames(Y) <- sapply(str_split(rownames(X), ' '), function(x) x[1])
  clust.dist <- as.dendrogram(hclust(dist(Y), method='complete'))
  clust.corr <- as.dendrogram(hclust(as.dist(1 - my.outer(t(Y), f.hellinger)), method='complete'))
  
  cols <- sapply(str_split(c('202 73 108', '118 126 22', '21 149 129', '120 106 213'), ' '),
                 function(x) rgb(x[1], x[2], x[3], maxColorValue=255))
  cols.dist <- cols[cutree(clust.dist, 4)]
  cols.corr <- cols[cutree(clust.corr, 4)]
  
  png(file=file, width=14, height=7.64, units='in', res=500)
    par(mfrow=c(1, 2), mar=c(0, 0, 0, 0), oma=c(0, 2, 0, 2))
    cex <- 0.9
    plot(as.phylo(clust.dist), type=type,
         tip.color=cols.dist, edge.lty=2, cex=cex)
    title('Euclidean Distance Metric', line=-1.5)
    plot(as.phylo(clust.corr), type=type,
         tip.color=cols.corr, edge.lty=2, cex=cex)
    title('Hellinger Distance Metric', line=-1.5)
  dev.off()
}
