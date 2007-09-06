# Vendor drops (Third party software incorporated)

WGET=/usr/bin/wget
.PHONY: all xsltunit xsltml otf libxsl-ruby art
download-all: xsltunit xsltml otf libxsl-ruby art

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

# libxsl-ruby by Sean Chittenden and contributors
# http://rubyforge.org/projects/libxsl/
libxsl-ruby:
	$(WGET) --directory-prefix=$@ http://rubyforge.org/frs/download.php/9358/libxsl-ruby-0.3.6.tar.gz
# open bible by Aaron Johnson
# old book by Molumen
# Tritonia_Lusitania_1935.jpg by OAR/(NURP)
art:
	$(WGET) --directory-prefix=$@ http://upload.wikimedia.org/wikipedia/commons/3/36/Open_bible_01_01.svg
	$(WGET) --directory-prefix=$@ http://openclipart.org/people/molumen/molumen_Old_book.svg
	$(WGET) --directory-prefix=$@ http://upload.wikimedia.org/wikipedia/commons/4/47/Tritonia_Lusitania_1935.jpg
