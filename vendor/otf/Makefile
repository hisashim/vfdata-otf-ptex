# Automation for building Debian package
# Required packages: pbuilder devscripts debhelper time (and their requirements)
# Usage: make debuild
#        sudo pbuilder create --distribution unstable
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

DISTNAME=unstable

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
	(cd $(DIR) && debuild $(DEBBUILDOPTS) -i.svn 2>&1 | tee ../$@.log; cd -)
clean: pbuilder-clean cowbuilder-clean
	-rm -f debuild.log
	(cd $(DIR) && sudo debuild clean; cd -)
distclean: clean
	-rm *.dsc *.diff.gz  *.build *.changes *.deb
pbuilder-create:
	sudo pbuilder create --distribution $(DISTNAME) --mirror http://cdn.debian.net/debian --override-config
pbuilder-update:
	sudo pbuilder update --distribution $(DISTNAME) --mirror http://cdn.debian.net/debian --override-config
pbuilder-build: $(DEBFILE_BASENAME).dsc $(DEBFILE_BASENAME).tar.gz
	@if [ ! -f $(DEBFILE_BASENAME).dsc ]; then echo 'Error: Type "make debuild" to generate .dsc.'; fi
	@if [ ! -f $(DEBFILE_BASENAME).tar.gz ]; then echo 'Error: Type "make debuild" to generate .tar.gz.'; fi
	(cd $(DIR) \
	&& sudo pbuilder build --hookdir ../pbuilder-hooks-build --bindmounts "/var/cache/pbuilder/result" ../$< 2>&1 | tee ../$@.log; \
	cd -)
pbuilder-test: $(DEBFILE_BASENAME)_all.deb
	(cd $(DIR) \
	&& sudo pbuilder execute --hookdir ../pbuilder-hooks-build --bindmounts "/var/cache/pbuilder/result"  -- \
	../pbuilder-hooks-build/test.sh $(DEBFILE_BASENAME) 2>&1 | tee ../$@.log; \
	cd -)
pbuilder-login:
	(cd $(DIR) \
	&& sudo pbuilder login --bindmounts "/var/cache/pbuilder/result" 2>&1 | tee ../$@.log; \
	cd -)
pbuilder-testclean:
	sudo rm -f /var/cache/pbuilder/result/myotftest.*
pbuilder-clean:
	-rm -f pbuilder-build.log pbuilder-login.log pbuilder-test.log
pbuilder-distclean: pbuilder-clean
	sudo rm -f /var/cache/pbuilder/result/$(DEBFILE_BASENAME)_*
cowbuilder-create:
	sudo cowbuilder --create --distribution $(DISTNAME) --mirror http://cdn.debian.net/debian --override-config
cowbuilder-update:
	sudo cowbuilder --update --distribution $(DISTNAME) --mirror http://cdn.debian.net/debian --override-config
cowbuilder-build: $(DEBFILE_BASENAME).dsc
	sudo cowbuilder --build --hookdir pbuilder-hooks-build --bindmounts "/var/cache/pbuilder/result" $< 2>&1 | tee $@.log ;
cowbuilder-login:
	sudo cowbuilder --login --hookdir pbuilder-hooks-build --bindmounts "/var/cache/pbuilder/result" 2>&1 | tee $@.log ;
cowbuilder-test: $(DEBFILE_BASENAME)_all.deb
	sudo cowbuilder --execute --hookdir pbuilder-hooks-build --bindmounts "/var/cache/pbuilder/result" -- \
	                pbuilder-hooks-build/test.sh $(DEBFILE_BASENAME) 2>&1 | tee $@.log ;
cowbuilder-testclean: pbuilder-testclean
cowbuilder-clean: pbuilder-clean
	-rm -f cowbuilder-build.log cowbuilder-login.log cowbuilder-test.log
cowbuilder-distclean: pbuilder-distclean
debclean: debuild-clean pbuilder-clean cowbuilder-clean
debdistclean: debclean debuild-distclean pbuilder-distclean cowbuilder-distclean
