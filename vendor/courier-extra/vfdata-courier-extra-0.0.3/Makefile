SRC	= *.afm
TXMF	= /usr/share/texmf
TXMF_TL	= /usr/share/texmf-texlive
DESTDIR	= /tmp/courier-extra
TEX	= tex -interaction batchmode
LATEX	= latex
DVI2PDF	= dvipdfmx -f courier-extra.map

all:	fontinst
fontinst:	courier-extra-driver.tex
	cp -r $(TXMF_TL)/fonts/afm/adobe/courier/*.afm ./
	cp -r $(TXMF_TL)/fonts/afm/adobe/symbol/*.afm ./
	$(TEX) $<
	$(TEX) courier-extra-map.tex
	rm -f *.afm
	for f in *.pl  ; do pltotf $$f; done
	for f in *.vpl ; do vptovf $$f; done
test:	courier-extra-test.pdf
install:	
	mkdir -p $(DESTDIR)$(TXMF_TL)/fonts/{tfm,vf}/public/courier-extra \
	         $(DESTDIR)/etc/texmf/dvipdfm \
	         $(DESTDIR)$(TXMF_TL)/tex/latex/courier-extra
	cp -r *.tfm $(DESTDIR)$(TXMF_TL)/fonts/tfm/public/courier-extra
	cp -r *.vf  $(DESTDIR)$(TXMF_TL)/fonts/vf/public/courier-extra
	cp -r *.map $(DESTDIR)/etc/texmf/dvipdfm
	cp -r *.fd  $(DESTDIR)$(TXMF_TL)/tex/latex/courier-extra
	cp -r *.sty $(DESTDIR)$(TXMF_TL)/tex/latex/courier-extra
	cd $(DESTDIR)$(TXMF) ; \
	ln -s       $(TXMF_TL)/fonts/tfm/public/courier-extra \
	            fonts/tfm/public/courier-extra ; \
	ln -s       $(TXMF_TL)/fonts/vf/public/courier-extra \
	            fonts/vf/public/courier-extra ; \
	ln -s       $(TXMF_TL)/tex/latex/courier-extra \
	            tex/latex/courier-extra ;

%.vf:	%.vpl
	vptovf $< $@
%.tfm:	%.pl
	pltotf $< $@
%.pdf:
%.pdf:	%.dvi
	$(DVI2PDF) $<
%.dvi:
%.dvi:	%.tex
	$(LATEX) $<
clean:	
	rm -f *.{fd,vpl,mtx,pl,log,aux,dvi}
cleanall: clean
	rm -f *.{afm,vf,tfm,pdf}
.PHONY:	fontinst test install clean cleanall
SECONDARY:	
