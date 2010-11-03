#!/bin/sh
if [ -n "$1" ]
  then
  DEBFILE_BASENAME=$1
  else
  exit 1
fi

echo "### Editing apt lines..."
cp -v /etc/apt/sources.list /etc/apt/sources.list.bak
echo 'deb http://cdn.debian.net/debian unstable main contrib non-free' >> /etc/apt/sources.list
echo "### /etc/apt/sources.list"
diff -u /etc/apt/sources.list.bak /etc/apt/sources.list
apt-get update
apt-get update
echo "### Installing the package and requirements..."
dpkg -i /var/cache/pbuilder/result/${DEBFILE_BASENAME}_all.deb
apt-get install -f --yes
echo "### dpkg -l | grep '^ii'"
dpkg -l | grep '^ii'

echo "### Setting up CMAPs and font maps..."
if [ -f /etc/texmf/texmf.d/50dvipdfmx.cnf ]
then
  cp -v /etc/texmf/texmf.d/50dvipdfmx.cnf /etc/texmf/texmf.d/50dvipdfmx.cnf.bak
  echo 'CMAPINPUTS = .;/usr/share/fonts/cmap//' >> /etc/texmf/texmf.d/50dvipdfmx.cnf
  echo "### /etc/texmf/texmf.d/50dvipdfmx.cnf"
  diff -u /etc/texmf/texmf.d/50dvipdfmx.cnf.bak /etc/texmf/texmf.d/50dvipdfmx.cnf
elif [ -f /etc/texmf/texmf.d/80DVIPDFMx.cnf ]
then
  echo "### /etc/texmf/texmf.d/80DVIPDFMx.cnf"
  cat /etc/texmf/texmf.d/80DVIPDFMx.cnf
else
  echo "### Neither 50dvipdfmx.cnf or 80DVIPDFMx.cnf found."
  ls -la /etc/texmf/texmf.d/
fi
update-texmf

echo "### Copying test document..."
cp -v /usr/share/doc/vfdata-courier-extra/examples/courier-extra-test.tex ./
echo "### Processing LaTeX document..."
latex courier-extra-test.tex
dvipdfmx -f courier-extra.map courier-extra-test.dvi
echo "### Copying test result to /var/cache/pbuilder/result..."
cp -v courier-extra-test.* /var/cache/pbuilder/result
echo "### Cleaning up..."
rm -v courier-extra-test.{tex,aux,log,dvi,pdf}
echo "### Another test document..."
cat /usr/share/texmf-texlive/tex/latex/base/nfssfont.tex \
| sed 's/\(\\ifx\\noinit!\\else\\init\\fi\)/%% overwriting init\n% \1/' \
| sed 's/\(\\endinput\)/% \1/' \
| sed 's/\( \\typein\[\\currfontname\]%\)/% \1/' \
| sed 's/\(   {Input external font name, e.g., cmr10^^J%\)/% \1/' \
| sed 's/\(    (or <enter> for NFSS classification of font):}%\)/% \1/' \
> pcrr8t.tex
echo '\\def\\currfontname{pcrr8t}' >> pcrr8t.tex
echo '\\init\\bigtest\\bye' >> pcrr8t.tex
echo '\\endinput' >> pcrr8t.tex
diff -u /usr/share/texmf-texlive/tex/latex/base/nfssfont.tex pcrr8t.tex
latex pcrr8t.tex
dvipdfmx -f courier-extra.map -o pcrr8t.pdf pcrr8t.dvi
cp -v pcrr8t.* /var/cache/pbuilder/result
rm -v pcrr8t.{tex,aux,log,dvi,pdf}
echo "### Testing uninstallation..."
dpkg --remove vfdata-courier-extra
dpkg --install /var/cache/pbuilder/result/${DEBFILE_BASENAME}_all.deb
dpkg --purge vfdata-courier-extra
