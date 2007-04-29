# Vendor drops (Third party software incorporated)

WGET=/usr/bin/wget

all: xsltunit mmltex otf

# XSLTUnit by Eric van der Vlist
# http://xsltunit.org/
xsltunit: xsltunit.xsl
xsltunit.xsl:
	$(WGET) http://xsltunit.org/0/2/xsltunit.xsl

# XSLT MathML to LaTeX Library by Vasil I. Yaroshevich
# http://sourceforge.net/projects/xsltml/
mmltex: xsltml_2.1.2.zip
xsltml_2.1.2.zip:
	$(WGET) http://downloads.sourceforge.net/xsltml/xsltml_2.1.2.zip

# OTF package for pLaTeX by Shuzaburo SAITO
# http://psitau.at.infoseek.co.jp/otf.html
# compiled and packaged by Akira KAKUTO
# http://www.fsci.fuk.kindai.ac.jp/%7Ekakuto/win32-ptex/web2c75.html
otf: otf.tar.bz2 otfstable.zip otfmanual.pdf
otf.tar.bz2:
	$(WGET) ftp://akagi.ms.u-tokyo.ac.jp/pub/TeX/win32/otf.tar.bz2
otfstable.zip:
	$(WGET) http://psitau.at.infoseek.co.jp/otfstable.zip
otfmanual.pdf:
	$(WGET) http://psitau.at.infoseek.co.jp/PDF/otfmanual.pdf
