.PHONY: html pdf

html: index.html
pdf: autfmt.pdf

PANDOC = pandoc -f markdown_github+tex_math_dollars -s

index.html: README.md pandoc.css template.html
	 $(PANDOC) README.md  --mathjax -c pandoc.css --toc --template template.html -o $@
autfmt.pdf: README.md
	$(PANDOC) README.md --latex-engine=xelatex -o $@

examples/examples.zip: scripts/extract.pl README.md
	scripts/extract.pl README.md
	zip -9 $@ examples/*.hoa

.PHONY: webpack gh-pages
webpack: index.html examples/examples.zip
	$(MAKE) $(MAKEFLAGS) -C figures
	tar zcvf www.tgz index.html examples.html pandoc.css figures/*.svg examples/examples.zip examples/*.hoa

gh-pages: webpack
	v=`git describe --always --abbrev=8 --dirty`; \
	b=`git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`; \
	git checkout -f gh-pages && \
	git pull origin gh-pages && \
	tar zxvf www.tgz && \
	tar ztf www.tgz | xargs git add -f && \
	git commit -m "Update webpages from $$v" && \
	git push origin gh-pages && \
	git checkout -f "$$b"
