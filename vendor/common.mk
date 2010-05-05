#!/usr/bin/make
# Automation for building Debian package
# Required packages: pbuilder devscripts debhelper time (and their requirements)
# Usage: make debuild
#        sudo pbuilder create --distribution etch
#        make pbuilder-build && ls /var/cache/pbuilder/result/*.{dsc,tar.gz,diff.gz,build,changes,deb}
#        make pbuilder-test && ls -al /var/cache/pbuilder/result/
DIR=$(PACKAGE)-$(SOFTWARE_VERSION)
DEBFILE_BASENAME=$(PACKAGE)_$(SOFTWARE_VERSION)-$(PACKAGE_REVISION)
PACKAGE_CL=`head -n 1 $(DIR)/debian/changelog | sed 's/^\(.*\) (\([^)]*\)-\([^)]*\)).*/\1/g'`
SOFTWARE_VERSION_CL=`head -n 1 $(DIR)/debian/changelog | sed 's/^\(.*\) (\([^)]*\)-\([^)]*\)).*/\2/g'`
PACKAGE_REVISION_CL=`head -n 1 $(DIR)/debian/changelog | sed 's/^\(.*\) (\([^)]*\)-\([^)]*\)).*/\3/g'`
DISTNAME=unstable
DEBBUILDOPTS = 

.PHONY: debuild-build debuild-clean debuild-distclean \
	pbuilder-build pbuilder-clean pbuilder-distclean \
	cowbuilder-build cowbuilder-clean cowbuilder-distclean \
	debclean debdistclean \
	download
.DEFAULT: all

all: cowbuilder-build

check:
	@if [ "X$(PACKAGE)" != "X$(PACKAGE_CL)" ]; then \
	  echo "Package name mismatch: Makefile: $(PACKAGE), changelog: $(PACKAGE_CL)"; \
	fi
	@if [ "X$(SOFTWARE_VERSION)" != "X$(SOFTWARE_VERSION_CL)" ]; then \
	  echo "Software version mismatch: Makefile: $(SOFTWARE_VERSION), changelog: $(SOFTWARE_VERSION_CL)"; \
	fi
	@if [ "X$(PACKAGE_REVISION)" != "X$(PACKAGE_REVISION_CL)" ]; then \
	  echo "Package revision mismatch: Makefile: $(PACKAGE_REVISION), changelog: $(PACKAGE_REVISION_CL)"; \
	fi

debuild-build:
	@echo If you want to omit signing, type "make debuild DEBBUILDOPTS='-us -uc'".
	(cd $(PACKAGE)-$(SOFTWARE_VERSION); debuild $(DEBBUILDOPTS); cd -)

debuild-clean:
	(cd $(PACKAGE)-$(SOFTWARE_VERSION); fakeroot debian/rules clean; cd -)

debuild-distclean: debuild-clean
	rm -f $(DEBFILE_BASENAME)*.build
	rm -f $(DEBFILE_BASENAME)*.changes
	rm -f $(DEBFILE_BASENAME)*.diff.gz
	rm -f $(DEBFILE_BASENAME)*.dsc
	rm -f $(DEBFILE_BASENAME)*.deb

pbuilder-build: $(DEBFILE_BASENAME).dsc
	@if [ ! -f $(DEBFILE_BASENAME).dsc ]; \
	  then echo 'Error: Type "make debuild-build" to generate .dsc.'; \
	fi
	@if [ ! -f $(DEBFILE_BASENAME).tar.gz ]; \
	  then echo 'Warning: Type "make debuild-build" to generate .tar.gz.'; \
	fi
	@if [ ! -f $(DEBFILE_BASENAME).tar.bz2 ]; \
	  then echo 'Warning: Type "make debuild-build" to generate .tar.bz2.'; \
	fi
	(cd $(DIR) \
	&& sudo pbuilder build \
	                 --hookdir ../pbuilder-hooks \
	                 --bindmounts "/var/cache/pbuilder/result" ../$< 2>&1 \
	| tee ../$@.log; \
	cd -)

pbuilder-clean:
	-rm -f pbuilder-build.log pbuilder-login.log pbuilder-test.log

pbuilder-distclean: pbuilder-clean
	sudo rm -f /var/cache/pbuilder/result/$(DEBFILE_BASENAME)_*

pbuilder-login:
	(cd $(DIR) \
	&& sudo pbuilder login --bindmounts "/var/cache/pbuilder/result" 2>&1 \
	| tee ../$@.log; \
	cd -)

pbuilder-test: $(DEBFILE_BASENAME)_all.deb
	(cd $(DIR) \
	&& sudo pbuilder execute \
	                 --hookdir ../pbuilder-hooks \
	                 --bindmounts "/var/cache/pbuilder/result"  -- \
	../pbuilder-hooks/test.sh $(DEBFILE_BASENAME) 2>&1 \
	| tee ../$@.log; \
	cd -)

pbuilder-testclean:
	sudo rm -f /var/cache/pbuilder/result/courier-extra-test.*

cowbuilder-build: $(DEBFILE_BASENAME).dsc
	@if [ ! -f $(DEBFILE_BASENAME).dsc ]; \
	  then echo 'Error: Type "make debuild-build" to generate .dsc.'; \
	fi
	@if [ ! -f $(DEBFILE_BASENAME).tar.gz ]; \
	  then echo 'Warning: Type "make debuild-build" to generate .tar.gz.'; \
	fi
	@if [ ! -f $(DEBFILE_BASENAME).tar.bz2 ]; \
	  then echo 'Warning: Type "make debuild-build" to generate .tar.bz2.'; \
	fi
	sudo cowbuilder --build \
	                --hookdir pbuilder-hooks \
	                --bindmounts "/var/cache/pbuilder/result" $< 2>&1 \
	| tee $@.log ;

cowbuilder-clean: pbuilder-clean
	-rm -f cowbuilder-build.log cowbuilder-login.log cowbuilder-test.log

cowbuilder-distclean: pbuilder-distclean

cowbuilder-login:
	sudo cowbuilder --login \
	                --hookdir pbuilder-hooks \
	                --bindmounts "/var/cache/pbuilder/result" 2>&1 \
	| tee $@.log ;

cowbuilder-test: $(DEBFILE_BASENAME)_all.deb
	sudo cowbuilder --execute \
	                --hookdir pbuilder-hooks \
	                --bindmounts "/var/cache/pbuilder/result" -- \
	pbuilder-hooks/test.sh $(DEBFILE_BASENAME) 2>&1 \
	| tee $@.log ;

cowbuilder-testclean: pbuilder-testclean

debclean: debuild-clean pbuilder-clean cowbuilder-clean

debdistclean: debclean debuild-distclean pbuilder-distclean cowbuilder-distclean

download:
