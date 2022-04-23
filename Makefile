.ONESHELL:
SHELL = /usr/local/bin/bash
Rscript = /usr/local/bin/Rscript

FIGS = ./figs
figs_pdf = $(FIGS)/pie.pdf $(FIGS)/ethnic-similarity.pdf $(FIGS)/pca-biplots.pdf $(FIGS)/clust-k3.pdf $(FIGS)/clust-k4.pdf
data = ./data/family.csv


all : $(figs_pdf) #./docs/index.html

$(figs_pdf) : ./src/R/main.R ./src/R/functions.R $(data)
	$(Rscript) $< > /dev/null 2>&1

# ./docs/index.html : $(data)
# 	./src/python/html.py > $@
