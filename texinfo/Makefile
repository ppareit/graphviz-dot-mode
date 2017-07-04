SOURCE	:= graphviz-dot-mode.texi
INCLUDE	:= fdl.texi gpl-2.0.texi gpl.texi

INFODIR := /usr/local/share/info/emacs

TEXINFODIR := /usr/local/Cellar/texinfo/6.4/bin
TEXI2ANY := $(TEXINFODIR)/texi2any
TEXI2PDF := $(TEXINFODIR)/texi2pdf
TEXI2DVI := $(TEXINFODIR)/texi2dvi
INSTALLINFO := $(TEXINFODIR)/install-info
SMARTYPANTS := /usr/local/bin/smartypants
PANDOC := /usr/local/bin/pandoc
GZIP := /usr/bin/gzip
INSTALL := /usr/bin/install

help:
	# Options:
	# make info
	# make install
	#
	# make html
	# make pdf
	# make ps
	# make txt
	# make docbook
	# make adoc
	# make epub	# lacks index
	# make md	# lacks index
	#
	# make clean
	#
	# Be sure to update file locations in top of Makefile for your system.

info: graphviz-dot-mode.info.gz

html: graphviz-dot-mode.html

pdf: graphviz-dot-mode.pdf

ps: graphviz-dot-mode.ps

txt: graphviz-dot-mode.txt

docbook: graphviz-dot-mode.xml

adoc: graphviz-dot-mode.adoc

epub: graphviz-dot-mode.epub

md: graphviz-dot-mode.md

graphviz-dot-mode.info: ${SOURCE} ${INCLUDE}
	$(TEXI2ANY) --info $<

graphviz-dot-mode.info.gz: graphviz-dot-mode.info
	$(GZIP) $<

install: graphviz-dot-mode.info.gz
	$(INSTALL) $< $(INFODIR)
	$(INSTALLINFO) $(INFODIR)/$< $(INFODIR)/dir

graphviz-dot-mode.html: ${SOURCE} ${INCLUDE}
	$(TEXI2ANY) --HTML --no-split --no-headers ${SOURCE} | ${SMARTYPANTS}

graphviz-dot-mode.pdf: ${SOURCE} ${INCLUDE} graphviz-dot-mode.info
	$(TEXI2PDF) $<

graphviz-dot-mode.ps: ${SOURCE} ${INCLUDE} graphviz-dot-mode.info
	$(TEXI2DVI) --ps  $<

graphviz-dot-mode.txt: ${SOURCE} ${INCLUDE}
	$(TEXI2ANY) --plaintext $< >$@

graphviz-dot-mode.xml: ${SOURCE} ${INCLUDE} graphviz-dot-mode.info
	$(TEXI2ANY) --docbook $<

# index entries are not handled correctly in docbook-derived formats below
graphviz-dot-mode.adoc: graphviz-dot-mode.xml
	$(PANDOC) -t asciidoc -o $@ -f docbook $<

graphviz-dot-mode.epub: graphviz-dot-mode.xml
	$(PANDOC) -t epub -o $@ -f docbook $<

graphviz-dot-mode.md: graphviz-dot-mode.xml
	$(PANDOC) -t markdown_strict -o $@ -f docbook $<

clean:
	rm *.aux *.toc *.log || true
	rm *.cp *.cps *.vr *.vrs *.fn *.fns *.ky *.kys *.pg *.pgs || true
	rm graphviz-dot-mode.dvi graphviz-dot-mode.ps graphviz-dot-mode.adoc || true
	rm graphviz-dot-mode.xml graphviz-dot-mode.epub graphviz-dot-mode.md || true
	rm graphviz-dot-mode.html graphviz-dot-mode.txt graphviz-dot-mode.pdf || true
	rm graphviz-dot-mode.info graphviz-dot-mode.info.gz || true

