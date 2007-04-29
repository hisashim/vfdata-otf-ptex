# Automation for building Debian package
PACKAGE=vfdata-otf-ptex
SOFTWARE_VERSION=1.2.9
PACKAGE_REVISION=0+0hisashim1
DIR=$(PACKAGE)-$(SOFTWARE_VERSION)
DEBFILE_BASENAME=$(PACKAGE)_$(SOFTWARE_VERSION)-$(PACKAGE_REVISION)
.PHONY: debuild pbuilder-debuild pbuilder-build
DEFAULT: pbuilder-debuild
pbuilder-build:
	(cd $(DIR) && time sudo pbuilder build ../$(DEBFILE_BASENAME).dsc | tee ../pbuilder-build.log; cd -)
debuild:
	(cd $(DIR) && time sudo debuild -us -uc | tee ../debuild.log; cd -)
clean:
	(cd $(DIR) && sudo debuild clean; cd -)
	-rm -f debuild.log pbuilder-build.log
