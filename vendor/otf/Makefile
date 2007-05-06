# Automation for building Debian package
PACKAGE=vfdata-otf-ptex
SOFTWARE_VERSION=1.2.9
PACKAGE_REVISION=0+0hisashim1
DIR=$(PACKAGE)-$(SOFTWARE_VERSION)
DEBFILE_BASENAME=$(PACKAGE)_$(SOFTWARE_VERSION)-$(PACKAGE_REVISION)
.PHONY: debuild pbuilder-debuild pbuilder-build pbuilder-test
DEFAULT: pbuilder-debuild
pbuilder-build:
	if [ ! -f $(DEBFILE_BASENAME).dsc ]; then echo 'make debuild to generate .dsc.'; fi
	if [ ! -f $(DEBFILE_BASENAME).tar.gz ]; then echo 'make debuild to generate .tar.gz.'; fi
	(cd $(DIR) \
	&& BINDMOUNTS="/var/cache/pbuilder/result" \
	time sudo pbuilder build ../$(DEBFILE_BASENAME).dsc --hookdir ../pbuilder-hooks-build \
	| tee ../$@.log; \
	cd -)
pbuilder-test:
	(cd $(DIR) \
	&& time sudo pbuilder \
	  execute --hookdir ../pbuilder-hooks-test --bindmounts "/var/cache/pbuilder/result" \
	  -- ../pbuilder-hooks-test/test.sh $(DEBFILE_BASENAME) \
	| tee ../$@.log; \
	cd -)
pbuilder-login:
	(cd $(DIR) \
	&& time sudo pbuilder login --bindmounts "/var/cache/pbuilder/result" \
	| tee ../$@.log; \
	cd -)
debuild:
	(cd $(DIR) && time sudo debuild -us -uc | tee ../debuild.log; cd -)
clean:
	-rm -f debuild.log pbuilder-build.log pbuilder-test.log
	(cd $(DIR) && sudo debuild clean; cd -)
distclean: clean
	-rm *.dsc *.diff.gz  *.build *.changes *.deb
