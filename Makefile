#!/usr/bin/make
# Usage: make clean all
#        make pbuilder-test && ls -al /var/cache/pbuilder/result/

## variables

# metadata

PRODUCT = otf
PACKAGE = $(shell head -n 1 $(PRODUCT)/debian/changelog \
                  | cut -d' ' -f 1)
VERSION = $(shell head -n 1 $(PRODUCT)/debian/changelog \
                  | cut -d' ' -f 2 | sed 's/(\(.*\)-\(.*\))/\1/')
DEBREV  = $(shell head -n 1 $(PRODUCT)/debian/changelog \
                  | cut -d' ' -f 2 | sed 's/(\(.*\)-\(.*\))/\2/')

# programs

TAR_XVCS= tar --exclude=".svn" --exclude=".git" --exclude=".hg"
DEBUILDOPTS= 
PBUILDER=cowbuilder
PBOPTS  = --hookdir pbuilder-hooks \
          --bindmounts "/var/cache/pbuilder/result"

# files and directories

RELEASE = $(PACKAGE)-$(VERSION)
DEB     = $(PACKAGE)_$(VERSION)-$(DEBREV)

## targets

all: deb

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
	(cd $(RELEASE) && debuild $(DEBUILDOPTS); cd -)

$(RELEASE): $(PRODUCT)
	mkdir $@
	(cd $(PRODUCT); $(TAR_XVCS) -cf - .; cd -) | (cd $@ && tar xpf -)

mostlyclean:
	-rm -fr $(RELEASE)
	-rm -f $(DEB).tar.gz
	-rm -f $(DEB)*.build $(DEB)*.changes

clean: mostlyclean
	-rm -f $(DEB)*.diff.gz $(DEB)*.dsc $(DEB)*.deb
