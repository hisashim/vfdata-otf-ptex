#!/usr/bin/make -f

PACKAGE  = vfdata-otf-ptex
DESTDIR  =
TXMF     = /usr/share/texmf
TXMF_TL  = /usr/share/texmf-texlive
FNTDIR   = $(DESTDIR)$(TXMF)/fonts
MAPDIRS  = $(DESTDIR)/etc/texmf/dvipdfm \
           $(DESTDIR)/etc/texmf/dvipdfmx
STYDIR   = $(DESTDIR)$(TXMF)/ptex/platex/misc
FNTDIR_TL= $(DESTDIR)$(TXMF_TL)/fonts
STYDIR_TL= $(DESTDIR)$(TXMF_TL)/ptex/platex/misc

all:

.PHONY: all install clean

install: share
	cp -r share/texmf/fonts/tfm/ptex/otf $(FNTDIR)/tfm/ptex/otf
	cp -r share/texmf/fonts/vf/ptex/otf $(FNTDIR)/vf/ptex/otf
	cp -r share/texmf/fonts/ofm/public/otf $(FNTDIR)/ofm/public/otf
	for d in $(MAPDIRS); do \
	  if [ -d $$d ]; then \
	    cp -r share/texmf/doc/misc/otf/*.map $$d; \
	  fi; \
	done
	cp -r share/texmf/tex/platex/misc/otf/*.sty $(STYDIR)/otf
	ln -s share/texmf/fonts/tfm/ptex/otf $(FNTDIR_TL)/tfm/ptex/otf
	ln -s share/texmf/fonts/vf/ptex/otf $(FNTDIR_TL)/vf/ptex/otf
	ln -s share/texmf/fonts/ofm/public/otf $(FNTDIR_TL)/ofm/public/otf
	ln -s share/texmf/ptex/platex/misc/otf $(STYDIR_TL)/otf
	# hiraprop
	cp -r share/texmf/fonts/tfm/ptex/hiraprop $(FNTDIR)/tfm/ptex/hiraprop
	cp -r share/texmf/fonts/vf/ptex/hiraprop $(FNTDIR)/vf/ptex/hiraprop
	cp -r share/texmf/tex/platex/misc/hiraprop/hiraprop.sty $(STYDIR)/hiraprop
	cp -r share/texmf/tex/platex/misc/hiraprop/*.fd $(STYDIR)/hiraprop
	ln -s share/texmf/fonts/tfm/ptex/hiraprop $(FNTDIR_TL)/tfm/ptex/hiraprop
	ln -s share/texmf/fonts/vf/ptex/hiraprop $(FNTDIR_TL)/vf/ptex/hiraprop
	ln -s share/texmf/tex/platex/misc/hiraprop $(STYDIR_TL)/hiraprop
	# install hiraprop docs
	cp -r share/texmf/doc/misc/hiraprop/*.txt $(DESTDIR)/usr/share/doc/$(PACKAGE)/hiraprop
	cp -r share/texmf/doc/misc/hiraprop/*.tex $(DESTDIR)/usr/share/doc/$(PACKAGE)/hiraprop

share: otf.tar.bz2
	tar -jxf otf.tar.bz2

clean:
	-rm -rf share/
