#! /usr/bin/env python

import pandas as pd

df = pd.read_csv('./data/family.csv')
df.set_index('Name', inplace=True)
df = df.transpose()
(m, n) = df.shape


front = """<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Feron Family</title>
    <link rel="stylesheet" type="text/css" href="freeze-table.css">
  </head>
  <body>
    <div style="width: 100%; height: 600px; max-height: 100%; overflow: auto">
      <table class="freeze-table" width="600px">"""
back = """      </table>
    </div>
  </body>
</html>"""


print(front)
s = '  '
print(f'{4*s}<thead>\n{5*s}<tr>')
print(f'{6*s}<th class="first" scope="row">Region</th>')
for i in range(n):
    print(f'{6*s}<th>{df.columns[i]}</th>')
print(f'{5*s}</tr>')
print(f'{4*s}</thead>')

print(f'{4*s}<tbody>')
for i in range(m):
    col = 'white' if i % 2 == 0 else 'gray'
    print(f'{5*s}<tr>')
    print(f'{6*s}<th class="col-id-no-{col}" scope="row">{df.index[i]}</th>')
    for j in range(n):
        print(f'{6*s}<td>{df.iloc[i,j]}</td>')
    print(f'{5*s}</tr>')
print(f'{4*s}</tbody>')
print(back)
