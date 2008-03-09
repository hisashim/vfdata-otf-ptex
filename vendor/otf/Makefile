# Automation for building Debian package
# Required packages: pbuilder devscripts debhelper time (and their requirements)
# Usage: make debuild
#        sudo pbuilder create --distribution etch
#        make pbuilder-build && ls /var/cache/pbuilder/result/*.{dsc,tar.gz,diff.gz,build,changes,deb}
#        make pbuilder-test && acroread /var/cache/pbuilder/result/myotftest.pdf
PACKAGE=vfdata-otf-ptex
SOFTWARE_VERSION=1.2.9
PACKAGE_REVISION=0+0hisashim5
DIR=$(PACKAGE)-$(SOFTWARE_VERSION)
DEBFILE_BASENAME=$(PACKAGE)_$(SOFTWARE_VERSION)-$(PACKAGE_REVISION)

PACKAGE_CL=`head -n 1 $(DIR)/debian/changelog | sed 's/^\(.*\) (\([^)]*\)-\([^)]*\)).*/\1/g'`
SOFTWARE_VERSION_CL=`head -n 1 $(DIR)/debian/changelog | sed 's/^\(.*\) (\([^)]*\)-\([^)]*\)).*/\2/g'`
PACKAGE_REVISION_CL=`head -n 1 $(DIR)/debian/changelog | sed 's/^\(.*\) (\([^)]*\)-\([^)]*\)).*/\3/g'`

.PHONY: debuild pbuilder-debuild pbuilder-build pbuilder-test check clean distclean
.DEFAULT: pbuilder-debuild
check:
	@if [ "$(PACKAGE)" != "$(PACKAGE_CL)" ]; \
	then echo "Package name mismatch: Makefile: $(PACKAGE), changelog: $(PACKAGE_REVISION_CL)"; \
	fi
	@if [ "$(SOFTWARE_VERSION)" != "$(SOFTWARE_VERSION_CL)" ]; \
	then echo "Software version mismatch: Makefile: $(SOFTWARE_VERSION), changelog: $(SOFTWARE_VERSION_CL)"; \
	fi
	@if [ "$(PACKAGE_REVISION)" != "$(PACKAGE_REVISION_CL)" ]; \
	then echo "Package revision mismatch: Makefile: $(PACKAGE_REVISION), changelog: $(PACKAGE_REVISION_CL)"; \
	fi
debuild:
	(cd $(DIR) && time debuild $(DEBBUILDOPTS) -i.svn 2>&1 | tee ../$@.log; cd -)
clean:
	-rm -f debuild.log pbuilder-build.log pbuilder-test.log
	(cd $(DIR) && sudo debuild clean; cd -)
distclean: clean
	-rm *.dsc *.diff.gz  *.build *.changes *.deb
pbuilder-create:
	sudo pbuilder create --distribution etch --mirror http://cdn.debian.net/debian --override-config
pbuilder-update:
	sudo pbuilder update --distribution etch --mirror http://cdn.debian.net/debian --override-config
pbuilder-build: $(DEBFILE_BASENAME).dsc $(DEBFILE_BASENAME).tar.gz
	@if [ ! -f $(DEBFILE_BASENAME).dsc ]; then echo 'Error: Type "make debuild" to generate .dsc.'; fi
	@if [ ! -f $(DEBFILE_BASENAME).tar.gz ]; then echo 'Error: Type "make debuild" to generate .tar.gz.'; fi
	(cd $(DIR) \
	&& sudo pbuilder build --hookdir ../pbuilder-hooks-build --bindmounts "/var/cache/pbuilder/result" ../$< 2>&1 | tee ../$@.log; \
	cd -)
pbuilder-test: $(DEBFILE_BASENAME)_all.deb
	(cd $(DIR) \
	&& sudo pbuilder execute --hookdir ../pbuilder-hooks-test --bindmounts "/var/cache/pbuilder/result"  -- \
	../pbuilder-hooks-test/test.sh $(DEBFILE_BASENAME) 2>&1 | tee ../$@.log; \
	cd -)
pbuilder-login:
	(cd $(DIR) \
	&& time sudo pbuilder login --bindmounts "/var/cache/pbuilder/result" 2>&1 | tee ../$@.log; \
	cd -)
