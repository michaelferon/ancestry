#! /usr/bin/env python

# %% Setup.
import os, sys
from importlib import reload # To reload functions module.
root_dir = "/Users/michaelferon/Projects/ancestry" # Root directory.
img_dir = f"{root_dir}/test/py_img" # Image output directory.
os.chdir(root_dir)
sys.path.append(os.path.abspath(f"{root_dir}/src/analysis")) # To import functions module.

# Import libraries.
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import functions as fns

# Load data.
df = pd.read_csv(f"{root_dir}/data/family.csv", index_col="Name") / 100
people = df.index
regions = df.columns

# For saving figures.
imgs = set()
class Image:
    def __init__(self, fig, filename, dpi="figure"):
        self.fig = fig
        self.filename = filename
        self.dpi = dpi
    def __eq__(self, other):
        return self.filename == other.filename
    def __hash__(self):
        return hash(self.filename)

    def save(self):
        self.fig.savefig(f"{img_dir}/{self.filename}", bbox_inches="tight", dpi=self.dpi)


# %% Pie charts.
imgs.add(Image(fns.getPieChart(df), "pie.png", dpi=400))
imgs.add(Image(fns.getPieChart(df, shadow=True, explode=True), "pie.pdf"))


# %% Ethnic similarity scores.
imgs.add(Image(fns.ethnicSimilarity(df, cmap="bone"), "ethnic-similarity.png", dpi=700))




# %%
for img in imgs:
    img.save()

# %%
