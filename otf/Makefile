#!/usr/bin/make
# Usage: make pbuilder-build && \
#          ls /var/cache/pbuilder/result/*.{dsc,tar.gz,diff.gz,build,changes,deb}
#        make pbuilder-test && ls -al /var/cache/pbuilder/result/

## variables

PACKAGE = vfdata-otf-ptex
VERSION = $(shell head -n 1 $(PACKAGE)/debian/changelog \
                  | cut -d' ' -f 2 | sed 's/(\(.*\)-\(.*\))/\1/')
DEBREV  = $(shell head -n 1 $(PACKAGE)/debian/changelog \
                  | cut -d' ' -f 2 | sed 's/(\(.*\)-\(.*\))/\2/')
RELEASE = $(PACKAGE)-$(VERSION)
DEB     = $(PACKAGE)_$(VERSION)-$(DEBREV)
DEBUILDOPTS= 
PBUILDER=cowbuilder
PBOPTS  = --hookdir pbuilder-hooks \
          --bindmounts "/var/cache/pbuilder/result"

## targets

all: pbuilder-build

.PHONY: all deb pbuilder-build pbuilder-login pbuilder-test \
	mostlyclean clean

deb: $(DEB)_all.deb

$(DEB)_all.deb: pbuilder-build
	cp /var/cache/pbuilder/result/$@ ./

pbuilder-build: $(DEB).dsc
	@echo 'Type "make debuild-build" for .dsc, .tar.gz, or .tar.bz2.'
	[ -f $(DEB).dsc ]
	[ -f $(DEB).tar.gz ] || [ -f $(DEB).tar.bz2 ]
	sudo $(PBUILDER) --build $(PBOPTS) $<

pbuilder-login:
	sudo $(PBUILDER) --login $(PBOPTS)

pbuilder-test: $(DEB)_all.deb
	sudo $(PBUILDER) --execute $(PBOPTS) -- \
	pbuilder-hooks/test.sh $(PACKAGE) $(VERSION) $(DEBREV)

$(DEB).dsc: $(RELEASE)
	@echo To omit signing, type "make debuild DEBUILDOPTS='-us -uc'".
	(cd $(PACKAGE)-$(VERSION) && debuild $(DEBUILDOPTS); cd -)

$(RELEASE):
	cp -r $(PACKAGE) $@

mostlyclean:
	-rm -fr $(RELEASE)
	-rm -f $(DEB)*.build $(DEB)*.changes

clean: mostlyclean
	-rm -f $(DEB)*.diff.gz $(DEB)*.dsc $(DEB)*.deb
