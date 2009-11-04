# Vendor drops (Third party software incorporated)

WGET=/usr/bin/wget
.PHONY: all xsltunit xsltml otf libxsl-ruby texml art book-r5rs book-strunk-style book-carroll-alice-ja courier-extra
all: xsltunit xsltml otf libxsl-ruby texml art book-r5rs book-strunk-style book-carroll-alice-ja courier-extra

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
	$(WGET) --directory-prefix=$@ http://rubyforge.org/frs/download.php/40144/libxslt-ruby-0.8.2.tgz

# TeXML processor by Oleg Parashchenko
# http://getfo.org/texml/
texml:
	$(WGET) --directory-prefix=$@ http://prdownloads.sourceforge.net/getfo/texml-2.0.1.tar.gz

# open bible by Aaron Johnson
# old book by Molumen
# Tritonia_Lusitania_1935.jpg by OAR/(NURP)
art:
	$(WGET) --directory-prefix=$@ http://upload.wikimedia.org/wikipedia/commons/3/36/Open_bible_01_01.svg
	$(WGET) --directory-prefix=$@ http://openclipart.org/people/molumen/molumen_Old_book.svg
	$(WGET) --directory-prefix=$@ http://upload.wikimedia.org/wikipedia/commons/4/47/Tritonia_Lusitania_1935.jpg

# R5RS Japanese translation by Hisao Suzuki
book-r5rs-ja:
	$(WGET) --directory-prefix=$@ http://www.unixuser.org/~euske/doc/r5rs-ja/r5rs-ja.tar.gz

# William Strunk, "The Elements of Style" Japanese translation
book-strunk-style-ja:
	$(WGET) --directory-prefix=$@ http://www.kt.rim.or.jp/~hisashim/elementsofstyle/elementsofstyle.html

# Alice's Adventures in Wonderland (Japanese translation by Hiroo YAMAGATA)
book-carroll-alice-ja:
	$(WGET) --directory-prefix=$@ --page-requisites --no-clobber --no-directories http://www.genpaku.org/alice01/alice01j.html
	$(WGET) --directory-prefix=$@ --accept=tif --reject=html --mirror --no-parent --no-directories http://homepage.mac.com/sciapod/sc/free_downloads/alice/

# Courier extra weights and variants
courier-extra:
	mkdir courier-extra
