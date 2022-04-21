## functions.R

# Loads familial data.
get_data <- function() {
  df <- read_csv('../data/family.csv') %>%
    mutate_if(is.numeric, function(x) x / 100)
  
  # Check that relative frequencies sum to 1.
  test <- apply(df[-1], 1, sum)
  if (any(test != 1)) {
    message(paste('Data error:', paste(df$Name[which(test != 1)], collapse=', ')))
  }
  return(df)
}

# Generates ethnicity pie chart and saves to pdf.
plot_pie_chart <- function(df) {
  # Color scheme for n=14 different ethnicities.
  cols <- RColorBrewer::brewer.pal(12, 'Set3')
  cols <- c(cols[1:7], '#FFFFFF', cols[8:10], '#000000', cols[11:12])

  pdf(file='../figs/pie.pdf', height=25, width=10)
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

# Hellinger distance function.
f.hellinger <- function(p, q) {
  return( 1/sqrt(2) * sqrt(sum((sqrt(p) - sqrt(q))^2)) )
}

# Hellinger distance matrix.
get_hellinger_matrix <- function(df) {
  hellinger <- matrix(NA, nrow(df), nrow(df))
  colnames(hellinger) <- df$Name; rownames(hellinger) <- df$Name
  for (i in 1:nrow(df)) {
    for (j in i:nrow(df)) {
      p <- as.numeric(df[i, -1])
      q <- as.numeric(df[j, -1])
      hellinger[i, j] <- 1 - f.hellinger(p, q) %>%
        round(digits = 2)
      hellinger[j, i] <- hellinger[i, j]
    }
  }
  return(hellinger)
}

# Adjusted correlation function.
adj.cor <- function(data) {
  n <- ncol(data)
  out <- matrix(NA, n, n)
  for (i in 1:n) {
    for (j in i:n) {
      p <- as.numeric(data[, i])
      q <- as.numeric(data[, j])
      inds <- p == 0 & q == 0
      p <- p[!inds]
      q <- q[!inds]
      out[i, j] <- cor(p, q)
      out[j, i] <- out[i, j]
    }
  }
  return(out)
}

plot_ethnic_similarity <- function(df) {
  # Compute ethnic correlation and adjusted correlation.
  family.cor <- round(cor(t(df[-1])), digits=2)
  colnames(family.cor) <- df$Name; rownames(family.cor) <- df$Name
  family.cor.adj <- round(adj.cor(t(df[-1])), digits=2)
  colnames(family.cor.adj) <- df$Name; rownames(family.cor.adj) <- df$Name
  
  hellinger <- get_hellinger_matrix(df)
  
  
  # Ethnic similarity matrices.
  pdf(file='../figs/ethnic-similarity.pdf', height=7, width=14)
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

get_pca_biplot <- function(df, do.scale=FALSE, title = 'Un-Standardized') {
  X <- as.matrix(df[-1]); Y <- scale(X, scale=do.scale)
  rownames(X) <- df$Name; rownames(Y) <- df$Name
  eig <- eigen(t(Y) %*% Y)
  pc.out <- prcomp(X, scale=do.scale)
  
  v.exp <- (cumsum(eig$values) / sum(eig$values))[2] %>% round(digits=2)
  biplot(pc.out, scale=1, cex=0.5, xlab=expression(z[1]), ylab=expression(z[2]), main=title)
  legend('topright', paste0('% Variance: ', v.exp), pch=19, col='black', pt.cex=0.5)
}

feron_biplots <- function(df) {
  pdf(file='../figs/pca-biplots.pdf', height=7, width=14)
    par(mfrow=c(1, 2))
    get_pca_biplot(df, do.scale=TRUE, 'Standardized')
    get_pca_biplot(df)
  dev.off()
}

feron_clust <- function(df) {
  pdf(file='../figs/clust.pdf', height=7, width=11)
    X <- as.matrix(df[-1])
    rownames(X) <- df$Name
    par(mfrow=c(1, 2), mar=c(7, 4, 7, 2) + 0.1)
    clust.dist <- as.dendrogram(hclust(dist(X), method='complete')) %>%
      color_branches(k = 4) %>%
      set("branches_lty", c(1,2,1,2)) %>%
      color_labels(k = 4)
    clust.corr <- as.dendrogram(hclust(as.dist(1 - cor(t(X))), method='complete')) %>%
      color_branches(k = 4) %>%
      set("branches_lty", c(1,2,1,2)) %>%
      color_labels(k = 4)
    plot(clust.dist, main='Euclidean Metric')
    plot(clust.corr, main='Correlation-based Metric')
    mtext('Complete-Linkage Hierarchical Clustering, k = 4',
          side=3, line=5.5, adj=3.0, cex=1.5)
  dev.off()
}


