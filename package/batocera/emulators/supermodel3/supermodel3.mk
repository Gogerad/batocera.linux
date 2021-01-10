################################################################################
#
# SUPERMODEL3
#
################################################################################

SUPERMODEL3_VERSION = r845
SUPERMODEL3_SITE = https://svn.code.sf.net/p/model3emu/code/trunk
SUPERMODEL3_SITE_METHOD=svn
SUPERMODEL3_DEPENDENCIES = sdl2 zlib libglew libzip sdl2_net
SUPERMODEL3_LICENSE = GPLv3

define SUPERMODEL3_BUILD_CMDS
	cp $(@D)/Makefiles/Makefile.UNIX $(@D)/Makefile
	$(SED) "s|-O2|-O3|g" $(@D)/Makefile
	$(SED) "s|CC = gcc|CC = $(TARGET_CC)|g" $(@D)/Makefile
	$(SED) "s|CXX = g++|CXX = $(TARGET_CXX)|g" $(@D)/Makefile
	$(SED) "s|LD = gcc|LD = $(TARGET_CC)|g" $(@D)/Makefile
	$(SED) "s|sdl2-config|$(STAGING_DIR)/usr/bin/sdl2-config|g" $(@D)/Makefile
	$(SED) "s+-march=native -mfpmath=sse++g" $(@D)/Makefiles/Rules.inc
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) -f Makefile VERBOSE=1
endef

define SUPERMODEL3_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bin/supermodel $(TARGET_DIR)/usr/bin/supermodel
	$(INSTALL) -D -m 0644 $(@D)/Config/Games.xml $(TARGET_DIR)/usr/share/batocera/datainit/system/configs/model3/Games.xml
	$(INSTALL) -D -m 0644 $(@D)/Config/Supermodel.ini $(TARGET_DIR)/usr/share/batocera/datainit/system/configs/model3/Supermodel.ini
	mkdir -p $(TARGET_DIR)/usr/share/batocera/datainit/system/configs/model3/NVRAM/
	mkdir -p $(TARGET_DIR)/userdata/saves/model3/
	mkdir -p $(TARGET_DIR)/userdata/screenshots/model3/
endef

define SUPERMODEL3_LINE_ENDINGS_FIXUP
	# DOS2UNIX Supermodel.ini and Main.cpp - patch system does not support different line endings
	sed -i -E -e "s|\r$$||g" $(@D)/Src/OSD/SDL/Main.cpp
	sed -i -E -e "s|\r$$||g" $(@D)/Src/Inputs/Inputs.cpp
endef

SUPERMODEL3_PRE_PATCH_HOOKS += SUPERMODEL3_LINE_ENDINGS_FIXUP

$(eval $(generic-package))
