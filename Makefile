.PHONY: html pdf

html: autfmt.html
pdf: autfmt.pdf

autfmt.html: README.md
	pandoc -f markdown_github README.md -s -o autfmt.html

autfmt.pdf: README.md
	pandoc -f markdown_github README.md -s --latex-engine=xelatex -o autfmt.pdf
