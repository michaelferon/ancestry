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
    png(file=file, height=5000, width=2000)
      cex=2.5
      par(mfrow=c(6, 2), mar=c(5, 0, 4, 7) + 0.1)
      for (n in 1:nrow(df)) {
        temp <- df %>%
          slice(n)
        inds <- which(temp[-1] != 0)
        pie(as.numeric(temp[-1][inds]), labels=names(temp)[-1][inds],
            col=cols[inds], radius=0.8, cex=cex, cex.main=cex)
        title(temp[1], cex.main=cex, line=-4)
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
    png(file=file, height=2000, width=4000)
    cex=2.75
      par(mfrow=c(1, 2), oma=c(0, 0, 0, 0))
      range <- range(c(family.cor.adj, hellinger))
      corrplot(family.cor.adj, method='color', type='lower', is.corr=TRUE, diag=FALSE,
               tl.col='black', tl.srt=45, mar=c(0, 0, 2, 0), col.lim=range,
               title='Correlation', cex.main=cex, tl.cex=cex, cl.cex=cex)
      corrplot(hellinger, method='color', type='lower', is.corr=FALSE, diag=FALSE,
               tl.col='black', tl.srt=45, mar=c(0, 0, 2, 0),
               title='Hellinger Distance', cex.main=cex, tl.cex=cex, cl.cex=cex)
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
get.pca.biplot <- function(df, do.scale=FALSE, title = 'Un-Standardized') {
  X <- as.matrix(df[-1]); Y <- scale(X, scale=do.scale)
  rownames(X) <- df$name; rownames(Y) <- df$name
  eig <- eigen(t(Y) %*% Y)
  pc.out <- prcomp(X, scale=do.scale)
  
  v.exp <- (cumsum(eig$values) / sum(eig$values))[2] %>% round(digits=2)
  biplot(pc.out, scale=1, cex=0.5, xlab=expression(z[1]), ylab=expression(z[2]), main=title)
  legend('topright', paste0('% Variance: ', v.exp), pch=19, col='black', pt.cex=0.5)
}

feron.biplots <- function(df, file) {
  pdf(file=file, height=7, width=14)
    par(mfrow=c(1, 2))
    get.pca.biplot(df, do.scale=TRUE, 'Standardized')
    get.pca.biplot(df)
  dev.off()
}

# Hierarchical clustering dendrograms.
feron.clust <- function(df, k, file) {
  X <- as.matrix(df[-1])
  rownames(X) <- df$name
  family.cor.adj <- my.outer(t(X), adj.cor)
  
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
