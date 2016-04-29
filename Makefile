RMD_FILES = $(wildcard *.Rmd)
HTML_FILES = $(RMD_FILES:%.Rmd=%.html)

all: html

html: $(HTML_FILES)

%.html: %.Rmd $(HTML_FILES_DEPENDS)
	-R --slave -e "rmarkdown::render('$<',encoding='UTF-8')"

watch:
	watchman watch "$(shell pwd)"
	watchman -- trigger "$(shell pwd)" remake $(RMD_FILES) Makefile -- make html

unwatch:
	watchman watch-del "$(shell pwd)"

.PHONY: clean
clean:
	-rm -rf *_cache *_files

.PHONY: clean-all
clean-all: clean
	-rm -rf $(HTML_FILES)
