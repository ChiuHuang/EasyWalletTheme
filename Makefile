ifeq ($(ROOTLESS),1)
THEOS_PACKAGE_SCHEME = rootless
else ifeq ($(ROOTHIDE),1)
THEOS_PACKAGE_SCHEME = roothide
endif

ARCHS = arm64
INSTALL_TARGET_PROCESSES = EasyWallet
TARGET = iphone:clang:16.5:14.0
PACKAGE_VERSION = 0.1.0
GIT_COMMIT = $(shell git rev-parse --verify --short=12 HEAD 2>/dev/null || echo unknown)

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = EasyWalletTheme
$(TWEAK_NAME)_FILES = $(shell find Source \( -name '*.x' -o -name '*.xm' -o -name '*.m' \))
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -DTWEAK_VERSION=$(PACKAGE_VERSION) -DTWEAK_GIT_COMMIT=\"$(GIT_COMMIT)\"
$(TWEAK_NAME)_FRAMEWORKS = UIKit Foundation QuartzCore

# Sideloaded build injects Sideloading.x (re-sign fixes); jailbreak .deb skips it.
ifeq ($(SIDELOADING),1)
$(TWEAK_NAME)_FILES += Source/Sideloading.x
endif

include $(THEOS_MAKE_PATH)/tweak.mk
