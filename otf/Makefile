#!/usr/bin/make
# Automation for building Debian package
# Required packages: pbuilder devscripts debhelper time (and their requirements)
# Usage: make debuild
#        sudo pbuilder create --distribution etch
#        make pbuilder-build && \
#          ls /var/cache/pbuilder/result/*.{dsc,tar.gz,diff.gz,build,changes,deb}
#        make pbuilder-test && ls -al /var/cache/pbuilder/result/

PACKAGE=vfdata-otf-ptex
VERSION=1.2.9
DEBREV=0+0hisashim7

DIR=$(PACKAGE)-$(VERSION)
DEB=$(PACKAGE)_$(VERSION)-$(DEBREV)
PACKAGE_CL=$(shell head -n 1 $(DIR)/debian/changelog | cut -d' ' -f 1)
VERSION_CL=$(shell head -n 1 $(DIR)/debian/changelog \
                            | cut -d' ' -f 2 | sed 's/(\(.*\)-\(.*\))/\1/')
DEBREV_CL=$(shell head -n 1 $(DIR)/debian/changelog \
                            | cut -d' ' -f 2 | sed 's/(\(.*\)-\(.*\))/\2/')
DISTNAME=unstable
DEBBUILDOPTS = 
PBUILDER=cowbuilder
PBOPTS=--hookdir ../pbuilder-hooks \
       --bindmounts "/var/cache/pbuilder/result"

.PHONY: debuild pbuilder-build mostlyclean clean
.DEFAULT: all

all: pbuilder-build

check:
	@echo "Checking if Makefile and debian/changelog match."
	[ "X$(PACKAGE)" == "X$(PACKAGE_CL)" ]
	[ "X$(VERSION)" == "X$(VERSION_CL)" ]
	[ "X$(DEBREV)" == "X$(DEBREV_CL)" ]

debuild:
	@echo To omit signing, type "make debuild DEBBUILDOPTS='-us -uc'".
	(cd $(PACKAGE)-$(VERSION); debuild $(DEBBUILDOPTS); cd -)

pbuilder-build: $(DEB).dsc
	@echo 'Type "make debuild-build" for .dsc, .tar.gz, or .tar.bz2.'
	[ -f $(DEB).dsc ]
	[ -f $(DEB).tar.gz ] || \
	[ -f $(DEB).tar.bz2 ]
	sudo $(PBUILDER) --build $(PBOPTS) $< 2>&1 | tee $@.log;

$(DEB).dsc: debuild

pbuilder-login:
	sudo $(PBUILDER) --login $(PBOPTS) 2>&1 | tee $@.log;

pbuilder-test: $(DEB)_all.deb
	sudo $(PBUILDER) --execute $(PBOPTS) -- \
	pbuilder-hooks/test.sh $(PACKAGE) $(VERSION) $(DEBREV) 2>&1 \
	| tee $@.log;

mostlyclean:
	(cd $(PACKAGE)-$(VERSION); fakeroot debian/rules clean; cd -)
	rm -f $(DEB)*.build
	rm -f $(DEB)*.changes
	rm -f $(DEB)*.diff.gz
	rm -f $(DEB)*.dsc
	rm -f $(DEB)*.deb

clean: mostlyclean
	-rm -f pbuilder-build.log pbuilder-login.log pbuilder-test.log
