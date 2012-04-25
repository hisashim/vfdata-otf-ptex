#!/usr/bin/make -f

PACKAGE  = vfdata-otf-ptex
DESTDIR  =
TEXMF    = /usr/share/texmf
TEXMF_TL = /usr/share/texmf-texlive
FONTDIR  = $(DESTDIR)$(TEXMF)/fonts
MAPDIRS  = $(DESTDIR)/etc/texmf/dvipdfm \
           $(DESTDIR)/etc/texmf/dvipdfmx
STYDIR   = $(DESTDIR)$(TEXMF)/ptex/platex/misc
FONTDIR_TL=$(DESTDIR)$(TEXMF_TL)/fonts
STYDIR_TL= $(DESTDIR)$(TEXMF_TL)/ptex/platex/misc

all:

.PHONY: all install clean

install: share
	mkdir -p $(FONTDIR)/tfm/ptex
	mkdir -p $(FONTDIR)/vf/ptex
	mkdir -p $(FONTDIR)/ofm/public
	mkdir -p $(MAPDIRS)
	mkdir -p $(STYDIR)/otf
	cp -r share/texmf/fonts/tfm/ptex/otf $(FONTDIR)/tfm/ptex/
	cp -r share/texmf/fonts/vf/ptex/otf $(FONTDIR)/vf/ptex/
	cp -r share/texmf/fonts/ofm/public/otf $(FONTDIR)/ofm/public/
	for d in $(MAPDIRS); do \
	  if [ -d $$d ]; then \
	    cp -r share/texmf/doc/misc/otf/*.map $$d; \
	  fi; \
	done
	cp -r share/texmf/tex/platex/misc/otf/*.sty $(STYDIR)/otf
	mkdir -p $(FONTDIR_TL)/tfm/ptex
	mkdir -p $(FONTDIR_TL)/vf/ptex
	mkdir -p $(FONTDIR_TL)/ofm/public
	mkdir -p $(STYDIR_TL)
	cd $(FONTDIR_TL)/tfm/ptex && \
	ln -s ../../../../texmf/fonts/tfm/ptex/otf otf
	cd $(FONTDIR_TL)/vf/ptex && \
	ln -s ../../../../texmf/fonts/vf/ptex/otf otf
	cd $(FONTDIR_TL)/ofm/public && \
	ln -s ../../../../texmf/fonts/ofm/public/otf otf
	cd $(STYDIR_TL) && \
	ln -s ../../../../texmf/ptex/platex/misc/otf otf
	# hiraprop
	mkdir -p $(FONTDIR)/tfm/ptex
	mkdir -p $(FONTDIR)/vf/ptex
	mkdir -p $(STYDIR)/hiraprop
	cp -r share/texmf/fonts/tfm/ptex/hiraprop $(FONTDIR)/tfm/ptex/
	cp -r share/texmf/fonts/vf/ptex/hiraprop $(FONTDIR)/vf/ptex/
	cp -r share/texmf/tex/platex/misc/hiraprop/hiraprop.sty $(STYDIR)/hiraprop
	cp -r share/texmf/tex/platex/misc/hiraprop/*.fd $(STYDIR)/hiraprop
	mkdir -p $(FONTDIR_TL)/tfm/ptex
	mkdir -p $(FONTDIR_TL)/vf/ptex
	mkdir -p $(STYDIR_TL)
	cd $(FONTDIR_TL)/tfm/ptex && \
	ln -s ../../../../texmf/fonts/tfm/ptex/hiraprop hiraprop
	cd $(FONTDIR_TL)/vf/ptex && \
	ln -s ../../../../texmf/fonts/vf/ptex/hiraprop hiraprop
	cd $(STYDIR_TL) && \
	ln -s ../../../../texmf/ptex/platex/misc/hiraprop hiraprop
	mkdir -p $(DESTDIR)/usr/share/doc/$(PACKAGE)/hiraprop
	cp -r share/texmf/doc/misc/hiraprop/*.txt $(DESTDIR)/usr/share/doc/$(PACKAGE)/hiraprop
	cp -r share/texmf/doc/misc/hiraprop/*.tex $(DESTDIR)/usr/share/doc/$(PACKAGE)/hiraprop

share: otf.tar.bz2
	tar -jxf otf.tar.bz2

clean:
	-rm -rf share/
