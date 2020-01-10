

include ../include/config.mk

IMAGE_SRC = $(shell pwd)
PNG_SRC   = $(IMAGE_SRC)/$(PNG_NAME)
JPEG_SRC = $(IMAGE_SRC)/$(JPEG_DIR_NAME)
TIFF_SRC = $(IMAGE_SRC)/$(TIFF_NAME)

IMAGE_LIB_DIR = $(shell pwd)/dependencies/lib/
IMAGE_INC_DIR = $(shell pwd)/dependencies/include/
LIB_FAT_DIR   = $(shell pwd)/dependencies/lib

JPEG_SRC_DIR = $(shell pwd)/dependencies/include/jpeg/
TIFF_SRC_DIR = $(shell pwd)/dependencies/include/tiff/
PNG_SRC_DIR = $(shell pwd)/dependencies/include/png/


libpngfolders  = $(foreach arch, $(arch_names), $(PNG_SRC)/$(arch)/)
libjpegfolders = $(foreach arch, $(arch_names), $(JPEG_SRC)/$(arch)/)
libtifffolders = $(foreach arch, $(arch_names), $(TIFF_SRC)/$(arch)/)

libpngfolders_all  = $(foreach arch, $(arch_names_all), $(PNG_SRC)/$(arch)/)
libjpegfolders_all = $(foreach arch, $(arch_names_all), $(JPEG_SRC)/$(arch)/)
libtifffolders_all = $(foreach arch, $(arch_names_all), $(TIFF_SRC)/$(arch)/)

libpngmakefile  = $(foreach folder, $(libpngfolders), $(addprefix $(folder), Makefile) )
libjpegmakefile = $(foreach folder, $(libjpegfolders), $(addprefix $(folder), Makefile) )
libtiffmakefile = $(foreach folder, $(libtifffolders), $(addprefix $(folder), Makefile) )

libpngfat  = $(addprefix $(IMAGE_LIB_DIR), $(libpngfiles))
libjpegfat = $(addprefix $(IMAGE_LIB_DIR), $(libjpegfiles))
libtifffat = $(addprefix $(IMAGE_LIB_DIR), $(libtifffiles))

libpng     = $(foreach folder, $(libpngfolders), $(addprefix $(folder)/lib/, $(libpngfiles)) )
libjpeg    = $(foreach folder, $(libjpegfolders), $(addprefix $(folder)/lib/, $(libjpegfiles)) )
libtiff    = $(foreach folder, $(libtifffolders), $(addprefix $(folder)/lib/, $(libtifffiles)) )

libpngconfig  = $(PNG_SRC)/configure
libjpegconfig = $(JPEG_SRC)/configure
libtiffconfig = $(TIFF_SRC)/configure

index = $(words $(shell a="$(2)";echo $${a/$(1)*/$(1)} ))
swap  = $(word $(call index,$(1),$(2)),$(3))

dependant_libs = libpng libjpeg libtiff

.PHONY : all
all : $(dependant_libs)

#######################
# Build libtiff and all of it's dependencies
#######################
libtiff : $(libtifffat)

$(libtifffat) : $(libtiff)
	mkdir -p $(@D)
	xcrun lipo $(realpath $(addsuffix lib/$(@F), $(libtifffolders_all)) ) -create -output $@
	mkdir -p $(TIFF_SRC_DIR)
	cp -rvf $(firstword $(libtifffolders))/include/*.h $(TIFF_SRC_DIR)	

$(libtiff) :  $(libtiffmakefile)
	cd $(abspath $(@D)/..) ; \
	$(MAKE) -sj8 && $(MAKE) install

$(TIFF_SRC)/%/Makefile : $(libtiffconfig)
	export SDKROOT="$(call swap, $*, $(arch_names_all), $(sdks))" ; \
	export CFLAGS="-Qunused-arguments -arch $(call swap, $*, $(arch_names_all), $(archs_all)) -pipe -no-cpp-precomp -isysroot $$SDKROOT -miphoneos-version-min=$(IOS_DEPLOY_TGT) -O2 -fembed-bitcode" ; \
	export CPPFLAGS=$$CFLAGS ; \
	export CXXFLAGS="$$CFLAGS -Wno-deprecated-register"; \
	mkdir -p $(@D) ; \
	cd $(@D) ; \
	../configure --host=$* --enable-fast-install --prefix=`pwd` --without-x --with-jpeg-include-dir=$(abspath $(@D)/../../$(JPEG_DIR_NAME)/$*/include) --with-jpeg-lib-dir=$(abspath $(@D)/../../$(JPEG_DIR_NAME)/$*/lib)

libpng : $(libpngfat)

$(libpngfat) : $(libpng)
	mkdir -p $(@D)
	xcrun lipo $(realpath $(addsuffix lib/$(@F), $(libpngfolders_all)) ) -create -output $@
	mkdir -p $(PNG_SRC_DIR)
	cp -rvf $(firstword $(libpngfolders))/include/*.h $(PNG_SRC_DIR)

$(libpng) : $(libpngmakefile)
	cd $(abspath $(@D)/..) ; \
	$(MAKE) -sj8 && $(MAKE) install

$(PNG_SRC)/%/Makefile : $(libpngconfig)
	export SDKROOT="$(call swap, $*, $(arch_names_all), $(sdks))" ; \
	export CFLAGS="-Qunused-arguments -arch $(call swap, $*, $(arch_names_all), $(archs_all)) -pipe -no-cpp-precomp -isysroot $$SDKROOT -miphoneos-version-min=$(IOS_DEPLOY_TGT) -O2 -fembed-bitcode" ; \
	export CPPFLAGS=$$CFLAGS ; \
	export CXXFLAGS="$$CFLAGS -Wno-deprecated-register"; \
	mkdir -p $(@D) ; \
	cd $(@D) ; \
	../configure --host=$* --prefix=`pwd`

libjpeg : $(libjpegfat)

$(libjpegfat) : $(libjpeg)
	mkdir -p $(@D)
	xcrun lipo $(realpath $(addsuffix lib/$(@F), $(libjpegfolders_all)) ) -create -output $@
	mkdir -p $(JPEG_SRC_DIR)
	cp -rvf $(firstword $(libjpegfolders))/include/*.h $(JPEG_SRC_DIR)

$(libjpeg) : $(libjpegmakefile)
	cd $(abspath $(@D)/..) ; \
	$(MAKE) -sj8 && $(MAKE) install

$(JPEG_SRC)/%/Makefile : $(libjpegconfig)
	export SDKROOT="$(call swap, $*, $(arch_names_all), $(sdks))" ; \
	export CFLAGS="-Qunused-arguments -arch $(call swap, $*, $(arch_names_all), $(archs_all)) -pipe -no-cpp-precomp -isysroot $$SDKROOT -miphoneos-version-min=$(IOS_DEPLOY_TGT) -O2 -fembed-bitcode" ; \
	export CPPFLAGS=$$CFLAGS ; \
	export CXXFLAGS="$$CFLAGS -Wno-deprecated-register"; \
	mkdir -p $(@D) ; \
	cd $(@D) ; \
	../configure --host=$* --prefix=`pwd`

#######################
# Download sources
#######################
$(libtiffconfig) :
	curl http://download.osgeo.org/libtiff/$(TIFF_NAME).tar.gz | tar -xpf-

$(libjpegconfig) :
	curl http://www.ijg.org/files/$(JPEG_SRC_NAME).tar.gz | tar -xpf-

$(libpngconfig) :		
	curl https://nchc.dl.sourceforge.net/project/libpng/libpng16/$(PNG_VERSION)/$(PNG_NAME).tar.xz | tar -xpf-

#######################
# Clean
#######################
.PHONY : clean
clean : cleanimages cleanlept cleantess

.PHONY : distclean
distclean : distcleanimages distcleanlept distcleantess

.PHONY : mostlyclean
mostlyclean : mostlycleanimages mostlycleanlept mostlycleantess

.PHONY : cleanimages
cleanimages :
	cd $(IMAGE_SRC) ; \
	$(MAKE) clean

.PHONY : cleanlept
cleanlept :
	for folder in $(realpath $(libleptfolders_all) ); do \
        cd $$folder; \
        $(MAKE) clean; \
	done ;

.PHONY : cleantess
cleantess :
	for folder in $(realpath $(libtessfolders_all) ); do \
        cd $$folder; \
        $(MAKE) clean; \
    done ;

.PHONY : mostlycleanimages
mostlycleanimages :

.PHONY : mostlycleanlept
mostlycleanlept :
	for folder in $(realpath $(libleptfolders) ); do \
        cd $$folder; \
        $(MAKE) mostlyclean; \
    done ;

.PHONY : mostlycleantess
mostlycleantess :
	for folder in $(realpath $(libtessfolders_all) ); do \
        cd $$folder; \
        $(MAKE) mostlyclean; \
    done ;

.PHONY : distcleanimages
distcleanimages :
	-rm -rf $(IMAGE_SRC)

PHONY : distcleanlept
distcleanlept :
	-rm -rf $(LEPT_INC_DIR)/leptonica
	-rm -rf $(libleptfat)
	-rm -rf $(LEPTON_SRC)

.PHONY : distcleantess
distcleantess :
	-rm -rf $(TESS_INC_DIR)/tesseract
	-rm -rf $(libtessfat)
	-rm -rf $(TESSERACT_SRC)

.PHONY : FORCE
FORCE :
