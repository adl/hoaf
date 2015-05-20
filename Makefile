.PHONY: html pdf

html: index.html support.html
pdf: autfmt.pdf

PANDOC = pandoc -f markdown_github+tex_math_dollars -s

index.html: README.md pandoc.css template.html
	 $(PANDOC) -T 'The Hanoi Omega-Automata Format' README.md  --mathjax -c pandoc.css --toc --template template.html -o $@
support.html: support.md pandoc.css template.html
	 $(PANDOC) -T 'HOA Format Tool Support' support.md -c pandoc.css --toc --template template.html -o $@

hoaf.tex: README.md header.tex
	sed 's/^[:space:]*-[^-]/\n&/' README.md > README.tmp.md
	$(PANDOC) README.tmp.md -t latex -H header.tex -o - |\
	sed 's/\\(\(\\def[^$$]*\)\\)/\1\n/;s/^\\includegraphics{\(.*\)\.svg}/\\input{\1.tex}/;' |\
	perl -0777 -pe 's:\\input{figures/.*?\\end{verbatim}:\\begin{samepage}$$&\\end{samepage}:somg' > $@

hoaf.pdf: hoaf.tex
	xelatex hoaf.tex

examples/examples.zip: scripts/extract.pl README.md
	scripts/extract.pl README.md
	zip -9 $@ examples/*.hoa

.PHONY: webpack gh-pages
webpack: index.html support.html hoaf.pdf examples/examples.zip
	$(MAKE) $(MAKEFLAGS) -C figures
	tar zcvf www.tgz index.html hoaf.pdf examples.html support.html pandoc.css figures/*.svg examples/examples.zip examples/*.hoa

gh-pages: webpack
	v=`git describe --always --abbrev=8 --dirty`; \
	b=`git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`; \
	git fetch && \
	git checkout -f -B gh-pages origin/gh-pages && \
	git pull origin gh-pages && \
	tar zxvf www.tgz && \
	tar ztf www.tgz | xargs git add -f && \
	git commit -m "Update webpages from $$v" && \
	git push origin gh-pages && \
	git checkout -f "$$b"
