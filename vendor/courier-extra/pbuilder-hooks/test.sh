#!/bin/sh
if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ]
  then
  PACKAGE=$1
  SOFTWARE_VERSION=$2
  PACKAGE_REVISION=$3
  DEBFILE_BASENAME=${PACKAGE}_${SOFTWARE_VERSION}-${PACKAGE_REVISION}
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

echo "### Copying source package..."
cp -v /var/cache/pbuilder/result/${DEBFILE_BASENAME}.dsc ./
cp -v /var/cache/pbuilder/result/${DEBFILE_BASENAME}.tar.gz ./
cp -v /var/cache/pbuilder/result/${DEBFILE_BASENAME}_*.changes ./
echo "### Extracting source package..."
tar fxz ${DEBFILE_BASENAME}.tar.gz
echo "### Processing test documents..."
cd ${PACKAGE}-${SOFTWARE_VERSION}
apt-get install t1utils
make test
make clean
echo "### Copying test result to /var/cache/pbuilder/result..."
cp -v pcr*.pdf /var/cache/pbuilder/result
echo "### Cleaning up..."
rm -v pcr*.{tex,aux,log,dvi,pdf}
cd -
echo "### Copying test document..."
cp -v /usr/share/doc/vfdata-courier-extra/examples/courier-extra-test.tex ./
echo "### Processing test document..."
latex courier-extra-test.tex
dvipdfmx -f courier-extra.map courier-extra-test.dvi
echo "### Copying test result to /var/cache/pbuilder/result..."
cp -v courier-extra-test.* /var/cache/pbuilder/result
echo "### Cleaning up..."
rm -v courier-extra-test.{tex,aux,log,dvi,pdf}
echo "### Testing uninstallation..."
dpkg --remove vfdata-courier-extra
dpkg --install /var/cache/pbuilder/result/${DEBFILE_BASENAME}_all.deb
dpkg --purge vfdata-courier-extra
