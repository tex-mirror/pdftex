test1:
	../../source/build-pdftex/texk/web2c/pdftex -ini test-no-date-id.tex

test2:
	../../source/build-pdftex/texk/web2c/pdftex -ini test-fixed-date-id.tex

test3:
	-SOURCE_DATE_EPOCH=abc123 ../../source/build-pdftex/texk/web2c/pdftex -ini -interaction=batchmode test-SOURCE_DATE_EPOCH.tex
	-SOURCE_DATE_EPOCH=123abc ../../source/build-pdftex/texk/web2c/pdftex -ini -interaction=batchmode test-SOURCE_DATE_EPOCH.tex
	-SOURCE_DATE_EPOCH=10 ../../source/build-pdftex/texk/web2c/pdftex -ini -interaction=batchmode test-SOURCE_DATE_EPOCH.tex
	-SOURCE_DATE_EPOCH=0 ../../source/build-pdftex/texk/web2c/pdftex -ini -interaction=batchmode test-SOURCE_DATE_EPOCH.tex
	-SOURCE_DATE_EPOCH=0.0 ../../source/build-pdftex/texk/web2c/pdftex -ini -interaction=batchmode test-SOURCE_DATE_EPOCH.tex
	-SOURCE_DATE_EPOCH=-1 ../../source/build-pdftex/texk/web2c/pdftex -ini -interaction=batchmode test-SOURCE_DATE_EPOCH.tex
	-SOURCE_DATE_EPOCH="" ../../source/build-pdftex/texk/web2c/pdftex -ini -interaction=batchmode test-SOURCE_DATE_EPOCH.tex
	# -SOURCE_DATE_EPOCH=1439928155 ../../source/build-pdftex/texk/web2c/pdftex -ini -interaction=batchmode test-SOURCE_DATE_EPOCH.tex

clean:
	rm -f *.log *.pdf *.fmt *.aux

fmt:
	../../source/build-pdftex/texk/web2c/pdftex -ini *pdflatex.ini
	../../source/build-pdftex/texk/web2c/pdftex -ini *pdfetex.ini
