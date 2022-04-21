#! /usr/bin/env python

import pandas as pd

df = pd.read_csv('../data/family.csv')
df.set_index('Name', inplace=True)
df = df.transpose()

(m, n) = df.shape

s = '  '
print(f'<thead>\n{s}<tr>')
print(f'{2*s}<th class="first" scope="row">Region</th>')
for i in range(n):
    print(f'{2*s}<th>{df.columns[i]}</th>')
print(f'{s}</tr>')
print('</thead>')

print('<tbody>')
for i in range(m):
    col = 'white' if i % 2 == 0 else 'gray'
    print(f'{s}<tr>')
    print(f'{2*s}<th class="col-id-no-{col}" scope="row">{df.index[i]}</th>')
    for j in range(n):
        print(f'{2*s}<td>{df.iloc[i,j]}</td>')
    print(f'{s}</tr>')
print('</tbody>')
