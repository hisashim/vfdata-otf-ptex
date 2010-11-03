SRC	= *.afm
TEXMF	= /usr/share/texmf
TEXMF_TL= /usr/share/texmf-texlive
DESTDIR	= /tmp/courier-extra
TEX	= tex -interaction batchmode
LATEX	= latex
DVITOPDF= dvipdfmx
MAP	= courier-extra
ifeq ("$(MAP)x","x")
  DVITOPDFFLAGS	=
else
  DVITOPDFFLAGS	= -f $(MAP)
endif

all:	fontinst
fontinst:	courier-extra-driver.tex
	cp -r $(TEXMF_TL)/fonts/afm/adobe/courier/*.afm ./
	cp -r $(TEXMF_TL)/fonts/afm/adobe/symbol/*.afm ./
	$(TEX) $<
	$(TEX) courier-extra-map.tex
	rm -f *.afm
	for f in *.pl  ; do pltotf $$f; done
	for f in *.vpl ; do vptovf $$f; done
test:	courier-extra-test.pdf
install:	
	mkdir -p $(DESTDIR)$(TEXMF_TL)/fonts/{tfm,vf}/public/courier-extra \
	         $(DESTDIR)/etc/texmf/dvipdfm \
	         $(DESTDIR)$(TEXMF_TL)/tex/latex/courier-extra
	cp -r *.tfm $(DESTDIR)$(TEXMF_TL)/fonts/tfm/public/courier-extra
	cp -r *.vf  $(DESTDIR)$(TEXMF_TL)/fonts/vf/public/courier-extra
	cp -r *.map $(DESTDIR)/etc/texmf/dvipdfm
	cp -r *.fd  $(DESTDIR)$(TEXMF_TL)/tex/latex/courier-extra
	cp -r *.sty $(DESTDIR)$(TEXMF_TL)/tex/latex/courier-extra
	cd $(DESTDIR)$(TEXMF) ; \
	ln -s       $(TEXMF_TL)/fonts/tfm/public/courier-extra \
	            fonts/tfm/public/courier-extra ; \
	ln -s       $(TEXMF_TL)/fonts/vf/public/courier-extra \
	            fonts/vf/public/courier-extra ; \
	ln -s       $(TEXMF_TL)/tex/latex/courier-extra \
	            tex/latex/courier-extra ;

%.vf:	%.vpl
	vptovf $< $@
%.tfm:	%.pl
	pltotf $< $@
%.pdf:
%.pdf:	%.dvi
	$(DVITOPDF) $(DVITOPDFFLAGS) -o $@ $<
%.dvi:
%.dvi:	%.tex
	$(LATEX) $<
clean:	
	rm -f *.{fd,vpl,mtx,pl,log,aux,dvi}
cleanall: clean
	rm -f *.{afm,vf,tfm,pdf}
.PHONY:	all fontinst test install clean cleanall
.SECONDARY:	
