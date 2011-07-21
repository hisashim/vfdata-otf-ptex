#!/usr/bin/make
# Automation for building Debian package
# Required packages: pbuilder devscripts debhelper time (and their requirements)
# Usage: make debuild
#        sudo pbuilder create --distribution etch
#        make pbuilder-build && \
#          ls /var/cache/pbuilder/result/*.{dsc,tar.gz,diff.gz,build,changes,deb}
#        make pbuilder-test && ls -al /var/cache/pbuilder/result/

PACKAGE=vfdata-otf-ptex
SOFTWARE_VERSION=1.2.9
PACKAGE_REVISION=0+0hisashim7

DIR=$(PACKAGE)-$(SOFTWARE_VERSION)
DEBFILE_BASENAME=$(PACKAGE)_$(SOFTWARE_VERSION)-$(PACKAGE_REVISION)
PACKAGE_CL=$(shell head -n 1 $(DIR)/debian/changelog | cut -d' ' -f 1)
SOFTWARE_VERSION_CL=$(shell head -n 1 $(DIR)/debian/changelog \
                            | cut -d' ' -f 2 | sed 's/(\(.*\)-\(.*\))/\1/')
PACKAGE_REVISION_CL=$(shell head -n 1 $(DIR)/debian/changelog \
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
	[ "X$(SOFTWARE_VERSION)" == "X$(SOFTWARE_VERSION_CL)" ]
	[ "X$(PACKAGE_REVISION)" == "X$(PACKAGE_REVISION_CL)" ]

debuild:
	@echo To omit signing, type "make debuild DEBBUILDOPTS='-us -uc'".
	(cd $(PACKAGE)-$(SOFTWARE_VERSION); debuild $(DEBBUILDOPTS); cd -)

pbuilder-build: $(DEBFILE_BASENAME).dsc
	@echo 'Type "make debuild-build" for .dsc, .tar.gz, or .tar.bz2.'
	[ -f $(DEBFILE_BASENAME).dsc ]
	[ -f $(DEBFILE_BASENAME).tar.gz ] || \
	[ -f $(DEBFILE_BASENAME).tar.bz2 ]
	sudo $(PBUILDER) --build $(PBOPTS) $< 2>&1 | tee $@.log;

$(DEBFILE_BASENAME).dsc: debuild

pbuilder-login:
	sudo $(PBUILDER) --login $(PBOPTS) 2>&1 | tee $@.log;

pbuilder-test: $(DEBFILE_BASENAME)_all.deb
	sudo $(PBUILDER) --execute $(PBOPTS) -- \
	pbuilder-hooks/test.sh $(PACKAGE) $(SOFTWARE_VERSION) $(PACKAGE_REVISION) 2>&1 \
	| tee $@.log;

mostlyclean:
	(cd $(PACKAGE)-$(SOFTWARE_VERSION); fakeroot debian/rules clean; cd -)
	rm -f $(DEBFILE_BASENAME)*.build
	rm -f $(DEBFILE_BASENAME)*.changes
	rm -f $(DEBFILE_BASENAME)*.diff.gz
	rm -f $(DEBFILE_BASENAME)*.dsc
	rm -f $(DEBFILE_BASENAME)*.deb

clean: mostlyclean
	-rm -f pbuilder-build.log pbuilder-login.log pbuilder-test.log
