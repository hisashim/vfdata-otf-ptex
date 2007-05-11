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
echo '% Non-embedding font map, which works without actual font data.
% Source: http://oku.edu.mie-u.ac.jp/~okumura/texwiki/?OTF
rml          H                Ryumin-Light
rmlv         V                Ryumin-Light
gbm          H                GothicBBB-Medium
gbmv         V                GothicBBB-Medium
hminr-h      H                Ryumin-Light
hminr-v      V                Ryumin-Light
otf-ujmr-h   UniJIS-UTF16-H   Ryumin-Light
otf-ujmr-v   UniJIS-UTF16-V   Ryumin-Light
otf-cjmr-h   Adobe-Japan1-6   Ryumin-Light
otf-cjmr-v   Identity-V       Ryumin-Light
hgothr-h     H                GothicBBB-Medium
hgothr-v     V                GothicBBB-Medium
otf-ujgr-h   UniJIS-UTF16-H   GothicBBB-Medium
otf-ujgr-v   UniJIS-UTF16-V   GothicBBB-Medium
otf-cjgr-h   Adobe-Japan1-6   GothicBBB-Medium
otf-cjgr-v   Identity-V       GothicBBB-Medium
' >> /etc/texmf/dvipdfm/my-pseudo-otf.map
echo "### /etc/texmf/dvipdfm/my-pseudo-otf.map"
cat /etc/texmf/dvipdfm/my-pseudo-otf.map
mktexlsr

echo "### Processing LaTeX document using OTF, without actual font data..."
echo '\documentclass{jbook}
\usepackage{otf}
\begin{document}
OpenTypeフォントを使うためのOTFパッケージのテストです。 \\
森\UTF{9DD7}外（區＋鳥） \\
内田百\UTF{9592}（門＋月） \\
\end{document}
' >> myotftest.tex
echo "### myotftest.tex"
platex myotftest.tex && dvipdfmx -f my-pseudo-otf myotftest.dvi
echo "### Copying myotftest.pdf to /var/cache/pbuilder/result..."
cp myotftest.pdf /var/cache/pbuilder/result

echo "### Cleaning up..."
rm /etc/texmf/dvipdfm/my-pseudo-otf.map
mktexlsr
rm myotftest.{tex,aux,log,dvi,pdf}

dpkg --remove vfdata-otf-ptex
dpkg --install /var/cache/pbuilder/result/${DEBFILE_BASENAME}_all.deb
dpkg --purge vfdata-otf-ptex
