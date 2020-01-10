
include ./include/config.mk


TESSERACT_SRC = $(shell pwd)/tesseract-$(TESSERACT_VERSION)
LEPTON_SRC = $(shell pwd)/$(LEPTON_NAME)
IMAGE_SRC = $(shell pwd)/libtiff-ios
PNG_SRC   = $(IMAGE_SRC)/$(PNG_NAME)
JPEG_SRC = $(IMAGE_SRC)/$(JPEG_NAME)
TIFF_SRC = $(IMAGE_SRC)/$(TIFF_NAME)

IMAGE_LIB_DIR = $(IMAGE_SRC)/dependencies/lib/
IMAGE_INC_DIR = $(IMAGE_SRC)/dependencies/include/
INCLUDE_DIR   = $(shell pwd)/dependencies/include
LEPT_INC_DIR  = $(INCLUDE_DIR)
TESS_INC_DIR  = $(INCLUDE_DIR)
LIB_FAT_DIR   = $(shell pwd)/dependencies/lib


libleptfolders = $(foreach arch, $(arch_names), $(LEPTON_SRC)/$(arch)/)
libtessfolders = $(foreach arch, $(arch_names), $(TESSERACT_SRC)/$(arch)/)
libleptfolders_all = $(foreach arch, $(arch_names_all), $(LEPTON_SRC)/$(arch)/)
libtessfolders_all = $(foreach arch, $(arch_names_all), $(TESSERACT_SRC)/$(arch)/)

libleptmakefile = $(foreach folder, $(libleptfolders), $(addprefix $(folder), Makefile) )
libtessmakefile = $(foreach folder, $(libtessfolders), $(addprefix $(folder), Makefile) )
imagesmakefile  = $(addprefix $(IMAGE_SRC)/, Makefile)

libleptfat = $(LIB_FAT_DIR)/$(libleptfiles)
libtessfat = $(LIB_FAT_DIR)/$(libtessfiles)
imagesfat  = $(libpngfat) $(libjpegfat) $(libtifffat)
libpngfat  = $(LIB_FAT_DIR)/$(libpngfiles)
libjpegfat = $(LIB_FAT_DIR)/$(libjpegfiles)
libtifffat = $(LIB_FAT_DIR)/$(libtifffiles)

libtess    = $(foreach folder, $(libtessfolders), $(addprefix $(folder)/lib/, $(libtessfiles)) )
liblept    = $(foreach folder, $(libleptfolders), $(addprefix $(folder)/lib/, $(libleptfiles)) )
images     = $(libpng) $(libjpeg) $(libtiff)
libpng     = $(addprefix $(IMAGE_LIB_DIR), $(libpngfiles))
libjpeg    = $(addprefix $(IMAGE_LIB_DIR), $(libjpegfiles))
libtiff    = $(addprefix $(IMAGE_LIB_DIR), $(libtifffiles))

libtessautogen = $(TESSERACT_SRC)/autogen.sh
libtessconfig = $(TESSERACT_SRC)/configure
libleptconfig = $(LEPTON_SRC)/configure

index = $(words $(shell a="$(2)";echo $${a/$(1)*/$(1)} ))
swap  = $(word $(call index,$(1),$(2)),$(3))

dependant_libs =  $(libtessfat) $(libleptfat) $(libpngfat) $(libjpegfat) $(libtifffat)

common_cflags = -L$(LIB_FAT_DIR) -Qunused-arguments -arch $(call swap, $*, $(arch_names_all), $(archs_all)) -pipe -no-cpp-precomp -isysroot $$SDKROOT -miphoneos-version-min=$(IOS_DEPLOY_TGT) -O2

.PHONY : all
all : $(dependant_libs)

#######################
# TESSERACT-OCR
#######################
$(libtessfat) : $(libtess)
	mkdir -p $(LIB_FAT_DIR)
	xcrun lipo $(realpath $(addsuffix lib/$(@F), $(libtessfolders_all)) ) -create -output $@
	mkdir -p $(TESS_INC_DIR)
	cp -rvf $(firstword $(libtessfolders))/include/tesseract $(TESS_INC_DIR)

$(libtess) : $(libtessmakefile)
	cd $(abspath $(@D)/..) && $(MAKE) -sj8 && $(MAKE) install

$(TESSERACT_SRC)/%/Makefile : $(libtessconfig) $(libleptfat)
	export LIBS="-lz -lpng -ljpeg -ltiff" ; \
	export SDKROOT="$(call swap, $*, $(arch_names_all), $(sdks))" ; \
	export CFLAGS="-I$(TESSERACT_SRC)/$*/ $(common_cflags) -fembed-bitcode" ; \
	export CPPFLAGS=$$CFLAGS ; \
	export CXXFLAGS="-I$(TESSERACT_SRC)/$*/ $(common_cflags) -Wno-deprecated-register"; \
	export LDFLAGS="-L$$SDKROOT/usr/lib/ -L$(LEPTON_SRC)/$*/src/.libs" ; \
	export LEPTONICA_CFLAGS="-I$(TESSERACT_SRC)/$*/ $(common_cflags) -I$(LEPT_INC_DIR)/leptonica" ; \
	export LEPTONICA_LIBS="-llept" ; \
	mkdir -p $(@D) ; \
	cd $(@D) ; \
	ln -s $(LEPTON_SRC)/src/ leptonica ; \
	../configure --host=$* --prefix=`pwd` --enable-shared=no --disable-graphics

$(libtessconfig) : $(libtessautogen)
	cd $(@D) && ./autogen.sh 2> /dev/null

#######################
# LEPTONLIB
#######################
$(libleptfat) : $(liblept)
	mkdir -p $(LIB_FAT_DIR)
	xcrun lipo $(realpath $(addsuffix lib/$(@F), $(libleptfolders_all)) ) -create -output $@
	mkdir -p $(LEPT_INC_DIR)
	cp -rvf $(firstword $(libleptfolders))/include/leptonica $(LEPT_INC_DIR)

$(liblept) : $(libleptmakefile)
	cd $(abspath $(@D)/..) ; \
	$(MAKE) -sj8 && $(MAKE) install

$(LEPTON_SRC)/%/Makefile : $(imagesfat) $(libleptconfig)
	export LIBS="-lz -lpng -ljpeg -ltiff" ; \
	export SDKROOT="$(call swap, $*, $(arch_names_all), $(sdks))" ; \
	export CFLAGS="-I$(INCLUDE_DIR) $(common_cflags) -fembed-bitcode" ; \
	export CPPFLAGS=$$CFLAGS ; \
	export CXXFLAGS="-I$(INCLUDE_DIR) $(common_cflags) -Wno-deprecated-register"; \
    export LDFLAGS="-L$$SDKROOT/usr/lib/ -L$(LIB_FAT_DIR)" ; \
	mkdir -p $(@D) ; \
	cd $(@D) ; \
    ../configure --host=$* --prefix=`pwd` --enable-shared=no --disable-programs --with-zlib --with-libpng --with-jpeg --without-giflib --without-libwebp --without-libopenjpeg --with-libtiff

#######################
# Build libtiff and all of it's dependencies
#######################
$(imagesfat) : $(images)
	mkdir -p $(@D)
	cp -rvf $? $(@D)
	mkdir -p $(INCLUDE_DIR)
	cp -rvf $(IMAGE_INC_DIR) $(INCLUDE_DIR)

$(images) : $(imagesmakefile) FORCE
	cd $(IMAGE_SRC) ; \
	until `$(MAKE) -s`; do sleep 5; done

#######################
# Download dependencies
#######################

$(libleptconfig) :
	curl http://leptonica.org/source/$(LEPTON_NAME).tar.gz | tar -xpf-

