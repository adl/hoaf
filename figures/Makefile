TEX = aut1.tex aut2.tex aut3.tex aut4.tex aut5.tex aut6.tex aut7.tex	\
      aut8.tex aut9.tex aut10.tex aut11.tex aut_alph1.tex
DEPS = common.tex
SVG = ${TEX:.tex=.svg}
PDF = ${TEX:.tex=.pdf}

.PHONY: all clean

all: $(PDF) $(SVG)

clean:
	rm -f *.aux *.log *.fls *.fdb_latexmk *~ $(SVG)

$(SVG): $(DEPS)

.SUFFIXES: .tex .pdf .svg

.tex.pdf:
	pdflatex $<
.pdf.svg:
	pdf2svg $< $@
