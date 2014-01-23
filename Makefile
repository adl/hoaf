.PHONY: html pdf

html: autfmt.html
pdf: autfmt.pdf

autfmt.html: README.md pandoc.css
	pandoc -f markdown_github README.md -s -c pandoc.css --toc -o autfmt.html

autfmt.pdf: README.md
	pandoc -f markdown_github README.md -s --latex-engine=xelatex -o autfmt.pdf
