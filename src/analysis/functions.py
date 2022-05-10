import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from mpl_toolkits.axes_grid1 import make_axes_locatable


_SQRT2 = np.sqrt(2)

def hellingerCloseness(p, q):
    """Returns measure of similarity for discrete probability distributions p and q.
    
    Computes `1 - H(p, q)`, where `H(p, q)` is the Hellinger distance between
    discrete probability distributions p and q. Function assumes p and q are non-negative
    and defined on the same probability space. In this case, output is between 0 and 1.

    Parameters
    ----------
    p, q : 1-dimensional array-like
        Must have same size.

    Returns
    -------
    `float`
        Similarity metric.
    """

    return 1 - np.linalg.norm(np.sqrt(p) - np.sqrt(q)) / _SQRT2


def adjustedCorr(p, q):
    """Returns correlation of p and q, ignoring elements where both p and q are zero.
    
    Parameters
    ----------
    p, q : 1-dimensional array-like
        Must have same size.

    Returns
    -------
    `float`
        Adjusted correlation.
    """

    inds = (p == 0) & (q == 0)
    return np.corrcoef(p[~inds], q[~inds])[0, 1]


def getPieChart(df, shadow=False, explode=False):
    """Returns 2-column grid of pie charts.

    Parameters
    ----------
    df : `pandas.DataFrame`
        Contains data to be plotted.
    shadow : `bool`, default: False
        Boolean indicating whether to draw shadows under each pie chart.
    explode : `bool`, default: False
        Boolean indicating whether to highlight each person's dominant ethnic region.

    Returns
    -------
    `matplotlib.figure.Figure`
        Figure containing grid-layout of pie charts.
    """

    people = df.index
    regions = df.columns

    # Associate each region with a color (got these colors from R).
    colors = pd.Series(["#8DD3C7", "#FFFFB3", "#BEBADA", "#FB8072", "#80B1D3", "#FDB462", "#B3DE69", "#FFFFFF", "#FCCDE5", "#D9D9D9", "#BC80BD", "#000000", "#CCEBC5", "#FFED6F"], index = regions)

    # 2-column grid of subplots.
    fig, axs = plt.subplots(people.size // 2, 2, figsize=(15.0, 35.0))
    for i, person in enumerate(people):
        x = df.T[person].loc[lambda z : z != 0] # Vector of ethnic values for person.
        xpl_factor = 0.1 * (x.values == np.max(x.values)) if explode else None # Explode factor.

        ax = axs[i // 2, i % 2] # Get proper Axes object.
        ax.set_title(person, fontweight="bold")
        ax.pie(x, labels=x.index, colors=colors[x.index], explode=xpl_factor, shadow=shadow)

    return fig


def ethnicSimilarity(df, cmap="viridis"):
    """Returns 2x2 grid of heatmaps of ethnic similarity scores.

    Function computes an ethnic siilarity score between each combination of rows (people)
    in `df` using four different metrics:
        - Correlation.
        - Adjusted correlation: see `adjustedCorr()`.
        - Euclidean distance.
        - Hellinger distance.

    Parameters
    ----------
    df : `pandas.DataFrame`
        Contains data to be plotted.
    cmap : `string`
        Colormap to pass to matplotlib.

    Returns
    -------
    `matplotlib.figure.Figure`
        Figure containing 2x2 grid-layout of heatmaps.
    """

    people = df.index
    methods = ["pearson", adjustedCorr, lambda x, y: 1 - np.linalg.norm(x - y), hellingerCloseness]
    titles = ["Correlation", "Adjusted Correlation", "Euclidean Distance", "Hellinger Distance"]

    data = [df.T.corr(method).values for method in methods]
    maxs = [np.max(d[d != 1]) for d in data]

    fig, axs = plt.subplots(2, 2, figsize=(9*11.6/10.5, 9), constrained_layout=True)
    axs = axs.reshape(4)
    ims = [ax.imshow(d, vmax=m, cmap=cmap) for ax, d, m in zip(axs, data, maxs)]

    for i, (im, ax, title) in enumerate(zip(ims, axs, titles)):
        div = make_axes_locatable(ax)
        cax = div.append_axes("right", size="5%", pad=0.20)
        fig.colorbar(im, cax=cax, orientation="vertical")
        ax.set_title(title)

        if i // 2:
            ax.set_xticks(np.arange(people.size), labels=[p.split()[0] for p in people])
            ax.set_xticklabels(ax.get_xticklabels(), rotation=45, ha="right", rotation_mode="anchor")
        else:
            ax.set_xticks([])

        if not i % 2:
            ax.set_yticks(np.arange(people.size), labels=[p.split()[0] for p in people])
        else:
            ax.set_yticks([])

    return fig
