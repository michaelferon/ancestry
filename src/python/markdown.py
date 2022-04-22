#! /usr/bin/env python

import pandas as pd

df = pd.read_csv('../data/family.csv')
df.set_index('Name', inplace=True)
print(df.transpose().to_markdown(index=True))
