#! /usr/bin/env python

import pandas as pd
df = pd.read_csv("./data/family.csv", index_col="Name")

with open ("./data/family.json", "w") as f: # General json data object.
    f.write(df.to_json(indent=4))
with open("./docs/js/data.js", "w") as f:   # json object as js var.
    f.write("var data = " + df.to_json(indent=4) + ";\n")
