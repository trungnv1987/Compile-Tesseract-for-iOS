

IOS_DEPLOY_TGT 		= "8.0"
PNG_VERSION 		= 1.6.37
TIFF_VERSION    	= 4.1.0
LEPT_VERSION		= 1.79.0
JPEG_VERSION		= 9c
TESSERACT_VERSION 	= 4.1.1

LEPTON_NAME 	= leptonica-$(LEPT_VERSION)
PNG_NAME    	= libpng-$(PNG_VERSION)
JPEG_NAME   	= jpeg-$(JPEG_VERSION)
TIFF_NAME   	= tiff-$(TIFF_VERSION)

JPEG_SRC_NAME   := jpegsrc.v$(JPEG_VERSION)# filename at the server
JPEG_DIR_NAME   := jpeg-$(JPEG_VERSION)# folder name after the JPEG_SRC_NAME archive has been unpacked


SDK_IPHONEOS_PATH			= $(shell xcrun --sdk iphoneos --show-sdk-path)
SDK_IPHONESIMULATOR_PATH	= $(shell xcrun --sdk iphonesimulator --show-sdk-path)
XCODE_DEVELOPER_PATH		="`xcode-select -p`"
XCODETOOLCHAIN_PATH			= $(XCODE_DEVELOPER_PATH)/Toolchains/XcodeDefault.xctoolchain
sdks 						= $(SDK_IPHONEOS_PATH) $(SDK_IPHONEOS_PATH) $(SDK_IPHONEOS_PATH) $(SDK_IPHONESIMULATOR_PATH) $(SDK_IPHONESIMULATOR_PATH)

libtessfiles 	= libtesseract.a
libleptfiles 	= liblept.a
libpngfiles 	= libpng.a
libjpegfiles 	= libjpeg.a
libtifffiles 	= libtiff.a

archs_all = armv7 armv7s arm64  x86_64
arch_names_all = arm-apple-darwin7 arm-apple-darwin7s arm-apple-darwin64  x86_64-apple-darwin

# archs_all = arm64  x86_64
# arch_names_all = arm-apple-darwin64  x86_64-apple-darwin

arch_names = $(foreach arch, $(ARCHS), $(call swap, $(arch), $(archs_all), $(arch_names_all) ) )
ARCHS ?= $(archs_all)



