if [ ! -e ./pdftex]; then
  ln -s ../../source/build-pdftex/texk/web2c/pdftex .
fi

set -x
TFMFONTS=. ./pdftex -ini ./f.tex
