SHORT=short
LONG=long
PUBLISH=$(SHORT)
DEP=$(PUBLISH).tex main.tex preamble.tex references.bib $(wildcard macros/*.tex) $(wildcard sections/*.tex)
# paper id assigned by conference system
ID=TBD
SOURCES=sources


default: view

all: $(LONG).pdf $(PUBLISH).pdf

view: $(PUBLISH).pdf
	evince $(PUBLISH).pdf &

publish: $(PUBLISH).pdf

$(PUBLISH).pdf: $(PUBLISH).tex $(DEP)
	pdflatex $(PUBLISH)
	bibtex $(PUBLISH)
	pdflatex $(PUBLISH)
	pdflatex $(PUBLISH)

$(LONG).pdf: $(LONG).tex $(DEP)
	pdflatex $(LONG)
	bibtex $(LONG)
	pdflatex $(LONG)
	pdflatex $(LONG)

.PHONY: upload clean distclean

upload: clean
	mkdir $(SOURCES)
	cp -r sections $(SOURCES)
	cp -r macros $(SOURCES)
	cp short.tex $(SOURCES)/paper.tex
	cp main.tex $(SOURCES)
	cp meta.tex $(SOURCES)
	cp preamble.tex $(SOURCES)
	cp references.bib $(SOURCES)
	cp ijcai25.sty $(SOURCES)
	cp named.bst $(SOURCES)
	zip -rm $(SOURCES).zip $(SOURCES)

full-upload: publish
	$(MAKE) clean
	$(MAKE) upload
	mkdir $(ID)
	cp $(SOURCES).zip $(ID)
	cp copyright-form.pdf $(ID)
	cp $(LONG).pdf $(ID)
	zip -rm $(ID).zip $(ID)
	rm -rf $(SOURCES).zip



clean:
	find . -regex '.*\.\(abs\|aux\|bbl\|blg\|dvi\|fdb_latexmk\|fls\|idx\|ilg\|ind\|log\|nav\|out\|run\.xml\|snm\|synctex\.gz\|thm\|toc\|vrb\|xmpi\|xmpdata\)' -print -delete

distclean: clean
	find . -name "$(SHORT).pdf" -print -delete
	find . -name "$(LONG).pdf" -print -delete

