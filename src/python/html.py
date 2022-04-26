#! /usr/bin/env python

import pandas as pd

df = pd.read_csv('./data/family.csv')
df.set_index('Name', inplace=True)
df = df.transpose()
(m, n) = df.shape

df.transpose().to_json('./data/family.json', indent=4)
