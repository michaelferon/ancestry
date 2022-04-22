.ONESHELL:
SHELL = /usr/local/bin/bash
Rscript = /usr/local/bin/Rscript

FIGS = ./figs
figs_pdf = $(FIGS)/pie.pdf $(FIGS)/ethnic-similarity.pdf $(FIGS)/pca-biplots.pdf $(FIGS)/clust-k3.pdf $(FIGS)/clust-k4.pdf
figs_jpg = $(patsubst ./figs/%.pdf, ./figs/%.jpg, $(figs_pdf))

data = ./data/family.csv


all : $(figs_pdf) $(figs_jpg) ./docs/index.html

$(figs_pdf) : ./src/R/main.R ./src/R/functions.R $(data)
	$(Rscript) $< > /dev/null 2>&1

./figs/%.jpg : ./figs/%.pdf
	convert -density 500 $^ -quality 90 $@

./docs/index.html : $(data)
	./src/python/html.py > $@
