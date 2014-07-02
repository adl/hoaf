.PHONY: html pdf

html: index.html
pdf: autfmt.pdf

PANDOC = pandoc -f markdown_github -s

index.html: README.md pandoc.css template.html
	 $(PANDOC) README.md -c pandoc.css --toc --template template.html -o $@

autfmt.pdf: README.md
	$(PANDOC) README.md --latex-engine=xelatex -o $@


.PHONY: webpack gh-pages
webpack: index.html
	$(MAKE) $(MAKEFLAGS) -C figures
	tar zcvf www.tgz index.html pandoc.css figures/*.svg

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

.PHONY: extract-examples

extract-examples: README.md
	rm -rf examples/
	mkdir -p examples
	scripts/extract-hoa README.md examples
