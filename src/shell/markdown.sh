#! /usr/bin/env bash

convert -density 500 ../figs/pie.pdf -quality 90 ../figs/pie.jpg
convert -density 500 ../figs/ethnic-similarity.pdf -quality 90 ../figs/ethnic-similarity.jpg

file='../README.md'
./markdown.py > $file

echo >> $file
echo '![](./figs/pie.jpg?raw=true "Pie Chart")' >> $file
echo >> $file
echo '![](./figs/ethnic-similarity.jpg?raw=true "Pie Chart")' >> $file
