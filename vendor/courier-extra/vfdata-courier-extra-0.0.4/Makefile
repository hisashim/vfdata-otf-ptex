SRC	= *.afm
TEXMF	= /usr/share/texmf
TEXMF_TL= /usr/share/texmf-texlive
DESTDIR	= /tmp/courier-extra
TEX	= tex -interaction batchmode
LATEX	= latex
DVITOPDF= dvipdfmx
MAP	= courier-extra
TESTNAME= bigtest
ifeq ("$(MAP)x","x")
  DVITOPDFFLAGS	=
  LABEL		= $(TESTNAME)
else
  DVITOPDFFLAGS	= -f $(MAP)
  LABEL		= $(TESTNAME)-$(MAP)
endif
# Berry naming scheme
# (http://www.tex.ac.uk/cgi-bin/texfaq2html?label=fontname)
#   pcr    Adobe Courier
#   r|b    r:Regular, b:Bold
#   [o]    o:Oblique
#   8t|8c  8t:T1, 8c:TS1
#   [n]    n:Narrow, c:Condensed
FONTS	= \
	pcrr8t	pcrrc8t	pcrro8t	pcrr8tn	pcrrc8tn	pcrro8tn	\
	pcrb8t	pcrbc8t	pcrbo8t	pcrb8tn	pcrbc8tn	pcrbo8tn	\
	pcrr8c		pcrro8c	pcrr8cn			pcrro8cn	\
	pcrb8c		pcrbo8c	pcrb8cn			pcrbo8cn
FCRPFB	= fcrr8a.pfb fcrb8a.pfb fcrro8a.pfb fcrbo8a.pfb
TESTDOCS= nfssfont
TESTPDFS= $(foreach f,$(FONTS),$(f)-$(LABEL).pdf)

all:	fontinst $(FCRPFB)
fontinst:	courier-extra-driver.tex
	cp -r $(TEXMF_TL)/fonts/afm/adobe/courier/*.afm ./
	cp -r $(TEXMF_TL)/fonts/afm/adobe/symbol/*.afm ./
	$(TEX) $<
	$(TEX) courier-extra-map.tex
	rm -f *.afm
	for f in *.pl  ; do pltotf $$f; done
	for f in *.vpl ; do vptovf $$f; done
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

test:	courier-extra-test.pdf $(FCRPFB) $(TESTPDFS)
%-$(LABEL).pdf:	$(foreach t,$(TESTDOCS),%-$(t).pdf)
	pdftk $(foreach t,$(TESTDOCS),$(*)-$(t).pdf) cat output $@
%-testfont.dvi:	%-testfont.tex
	$(TEX) $<
%-nfssfont.dvi:	%-nfssfont.tex
	$(LATEX) $<
%-fontchart.dvi:	%-fontchart.tex
	$(TEX) $<
%-testfont.tex:	$(TEXMF_TL)/tex/plain/base/testfont.tex
	@sed 's/\(\\ifx\\noinit!\\else\\init\\fi\)/%% overwriting init\n% \1/' < $< > $@
	@echo '\def\init{\def\fontname{$(*)}\startfont' >> $@
	@echo '  \$(TESTNAME)}' >> $@
	@echo '\init\bye' >> $@
	# -diff -u $< $@
%-nfssfont.tex:	$(TEXMF_TL)/tex/latex/base/nfssfont.tex
	@sed 's/\(\\ifx\\noinit!\\else\\init\\fi\)/%% overwriting init\n% \1/' < $< \
	| sed 's/\(\\endinput\)/% \1/' \
	| sed 's/\( \\typein\[\\currfontname\]%\)/% \1/' \
	| sed 's/\(   {Input external font name, e.g., cmr10^^J%\)/% \1/' \
	| sed 's/\(    (or <enter> for NFSS classification of font):}%\)/% \1/' \
	> $@
	@echo '\def\currfontname{$(*)}' >> $@
	@echo '\init\$(TESTNAME)\bye' >> $@
	@echo '\endinput' >> $@
	# -diff -u $< $@
%-fontchart.tex:	$(TEXMF_TL)/tex/plain/base/fontchart.tex
	@sed 's/\(\\read-1 to \\fontname\)/% \1\n\\def\\fontname{$(*)\\relax}/'< $< \
	> $@
	# -diff -u $< $@
%.vf:	%.vpl
	vptovf $< $@
%.tfm:	%.pl
	pltotf $< $@
fcr%.pfb:	fcr%.t1
	cp $< $@
fcr%.t1asm:	pcr%.t1asm fcr%.t1asm.patch
	cp $< $@
	patch $@ < $@.patch
%.t1:	%.t1asm
	t1asm --output $@ $<
%.t1asm:	%.pfb
	t1disasm --output $@ $<
pcr%.afm:$(TEXMF_TL)/fonts/afm/adobe/courier/pcr%.afm
	cp $< $@
pcr%.pfb:$(TEXMF_TL)/fonts/type1/adobe/courier/pcr%.pfb
	cp $< $@
ucr%.afm:$(TEXMF_TL)/fonts/afm/urw/courier/ucr%.afm
	cp $< $@
ucr%.pfb:$(TEXMF_TL)/fonts/type1/urw/courier/ucr%.pfb
	cp $< $@
%.pdf:
%.pdf:	%.dvi
	$(DVITOPDF) $(DVITOPDFFLAGS) -o $@ $<
%.dvi:
%.dvi:	%.tex
	$(LATEX) $<

search:
	-for f in $(FONTS) ; \
	do \
	echo -n "$${f}.vf:	" ; kpsewhich $${f}.vf ; \
	echo -n "$${f}.tfm:	" ; kpsewhich $${f}.tfm ; \
	done
clean:	
	rm -f *.fd *.vpl *.mtx *.pl *.log *.aux *.dvi *.t1asm *.t1
	rm -f $(foreach f,$(FONTS),$(f)-$(LABEL).tex)
cleanall: clean
	rm -f *.afm *.vf *.tfm *.pdf *.pfb
	rm -f courier-extra-dvipdfm.map
	rm -f courier-extra-dvips.map
	rm -f courier-extra-rec.tex
.PHONY:	all fontinst test install clean cleanall search
.SECONDARY:
