# Vendor drops (Third party software incorporated)

WGET=/usr/bin/wget
.PHONY: all xsltunit xsltml otf
download-all: xsltunit xsltml otf

# XSLTUnit by Eric van der Vlist
# http://xsltunit.org/
xsltunit:
	$(WGET) --directory-prefix=$@ http://xsltunit.org/0/2/xsltunit.xsl

# XSLT MathML to LaTeX Library by Vasil I. Yaroshevich
# http://sourceforge.net/projects/xsltml/
xsltml:
	$(WGET) --directory-prefix=$@ http://downloads.sourceforge.net/xsltml/xsltml_2.1.2.zip

# OTF package for pLaTeX by Shuzaburo SAITO
# http://psitau.at.infoseek.co.jp/otf.html
# compiled and packaged by Akira KAKUTO
# http://www.fsci.fuk.kindai.ac.jp/%7Ekakuto/win32-ptex/web2c75.html
otf:
	$(WGET) --directory-prefix=$@ ftp://akagi.ms.u-tokyo.ac.jp/pub/TeX/win32/otf.tar.bz2
	$(WGET) --directory-prefix=$@ http://psitau.at.infoseek.co.jp/otfstable.zip
	$(WGET) --directory-prefix=$@ http://psitau.at.infoseek.co.jp/PDF/otfmanual.pdf
