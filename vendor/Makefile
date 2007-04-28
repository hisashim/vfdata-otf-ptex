# Vendor drops (Third party software incorporated)

WGET=/usr/bin/wget

all: xsltunit mmltex

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

