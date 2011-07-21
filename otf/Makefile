#!/usr/bin/make
# Automation for building Debian package
# Required packages: pbuilder devscripts debhelper time (and their requirements)
# Usage: make debuild
#        sudo pbuilder create --distribution etch
#        make pbuilder-build && \
#          ls /var/cache/pbuilder/result/*.{dsc,tar.gz,diff.gz,build,changes,deb}
#        make pbuilder-test && ls -al /var/cache/pbuilder/result/

PACKAGE = vfdata-otf-ptex
VERSION = 1.2.9
DIR     = $(PACKAGE)-$(VERSION)
DEBREV  = $(shell head -n 1 $(DIR)/debian/changelog \
                  | cut -d' ' -f 2 | sed 's/(\(.*\)-\(.*\))/\2/')
DEB     = $(PACKAGE)_$(VERSION)-$(DEBREV)
PACKAGE_CL=$(shell head -n 1 $(DIR)/debian/changelog | cut -d' ' -f 1)
VERSION_CL=$(shell head -n 1 $(DIR)/debian/changelog \
                   | cut -d' ' -f 2 | sed 's/(\(.*\)-\(.*\))/\1/')
DISTNAME=unstable
DEBBUILDOPTS= 
PBUILDER=cowbuilder
PBOPTS  = --hookdir pbuilder-hooks \
          --bindmounts "/var/cache/pbuilder/result"

.PHONY: debuild pbuilder-build mostlyclean clean
.DEFAULT: all

all: check pbuilder-build

check:
	@echo "Checking if Makefile and debian/changelog match."
	[ "X$(PACKAGE)" == "X$(PACKAGE_CL)" ]
	[ "X$(VERSION)" == "X$(VERSION_CL)" ]

debuild:
	@echo To omit signing, type "make debuild DEBBUILDOPTS='-us -uc'".
	(cd $(PACKAGE)-$(VERSION); debuild $(DEBBUILDOPTS); cd -)

pbuilder-build: $(DEB).dsc
	@echo 'Type "make debuild-build" for .dsc, .tar.gz, or .tar.bz2.'
	[ -f $(DEB).dsc ]
	[ -f $(DEB).tar.gz ] || [ -f $(DEB).tar.bz2 ]
	sudo $(PBUILDER) --build $(PBOPTS) $<

$(DEB).dsc: debuild

pbuilder-login:
	sudo $(PBUILDER) --login $(PBOPTS)

pbuilder-test: $(DEB)_all.deb
	sudo $(PBUILDER) --execute $(PBOPTS) -- \
	pbuilder-hooks/test.sh $(PACKAGE) $(VERSION) $(DEBREV)

mostlyclean:
	(cd $(PACKAGE)-$(VERSION); fakeroot debian/rules clean; cd -)
	-rm -f $(DEB)*.build $(DEB)*.changes

clean: mostlyclean
	-rm -f $(DEB)*.diff.gz $(DEB)*.dsc $(DEB)*.deb
