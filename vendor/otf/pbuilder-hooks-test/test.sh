#!/bin/sh
if [ -n "$1" ]
  then
  DEBFILE_BASENAME=$1
  else
  exit 1
fi

echo "### Editing apt lines..."
cp /etc/apt/sources.list{,.bak}
echo 'deb http://ftp.jp.debian.org/debian etch main contrib non-free' >> /etc/apt/sources.list
echo "### /etc/apt/sources.list"
diff -u /etc/apt/sources.list{.bak,}
apt-get update
apt-get update

echo "### Installing vfdata-otf-ptex and requirements..."
dpkg -i /var/cache/pbuilder/result/${DEBFILE_BASENAME}_all.deb
apt-get install -f --yes
echo "### dpkg -l | grep '^ii'"
dpkg -l | grep '^ii'

echo "### Setting up CMAPs and font maps..."
if [ -f /etc/texmf/texmf.d/50dvipdfmx.cnf ]
then
  cp /etc/texmf/texmf.d/50dvipdfmx.cnf{,.bak}
  echo 'CMAPINPUTS = .;/usr/share/fonts/cmap//' >> /etc/texmf/texmf.d/50dvipdfmx.cnf
  echo "### /etc/texmf/texmf.d/50dvipdfmx.cnf"
  diff -u /etc/texmf/texmf.d/50dvipdfmx.cnf{.bak,}
elif [ -f /etc/texmf/texmf.d/80DVIPDFMx.cnf ]
then
  echo "### /etc/texmf/texmf.d/80DVIPDFMx.cnf"
  cat /etc/texmf/texmf.d/80DVIPDFMx.cnf
else
  echo "### Neither 50dvipdfmx.cnf or 80DVIPDFMx.cnf found."
  ls -la /etc/texmf/texmf.d/
fi
update-texmf
cp /usr/share/doc/vfdata-otf-ptex/examples/my-pseudo-otf.map ./
echo "### my-pseudo-otf.map"
cat my-pseudo-otf.map

echo "### Processing LaTeX document using OTF, without actual font data..."
cp /usr/share/doc/vfdata-otf-ptex/examples/myotftest.tex ./
echo "### myotftest.tex"
platex myotftest.tex && dvipdfmx -f my-pseudo-otf.map myotftest.dvi
echo "### Copying myotftest.pdf to /var/cache/pbuilder/result..."
cp myotftest.pdf /var/cache/pbuilder/result

echo "### Cleaning up..."
rm my-pseudo-otf.map myotftest.{tex,aux,log,dvi,pdf}

echo "### Testing uninstallation..."
dpkg --remove vfdata-otf-ptex
dpkg --install /var/cache/pbuilder/result/${DEBFILE_BASENAME}_all.deb
dpkg --purge vfdata-otf-ptex
