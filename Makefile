.ONESHELL:
SHELL = /usr/local/bin/bash
Rscript = /usr/local/bin/Rscript

FIGS = ./figs
figs_pdf = $(FIGS)/pie.pdf $(FIGS)/ethnic-similarity.pdf $(FIGS)/pca-biplots.pdf $(FIGS)/clust-k3.pdf $(FIGS)/clust-k4.pdf
data = ./data/family.csv


all : $(figs_pdf)

$(figs_pdf) : ./src/R/main.R ./src/R/functions.R $(data)
	$(Rscript) $< > /dev/null 2>&1


.PHONY : database view connect
database : $(data)
	@mariadb ancestry -A < ./src/sql/init.sql && echo 'Database updated.'
view :
	@mariadb ancestry -A --execute="SELECT * FROM data;"
connect:
	@mariadb ancestry -A
