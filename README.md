# Compile-Tesseract-for-iOS


### Steps to compile Tesseract lib and dependencies for iOS version only

#### Step 1
Open Terminal app and run the following commands:<br/>
```
mkdir -p dependencies/include
mkdir -p dependencies/lib
cp -R ./include/curl/  dependencies/include/curl/
cp -rvf include/libcurl.a  dependencies/lib/libcurl.a
```

#### Step 2  Download Tesseract
download tesseract at https://github.com/tesseract-ocr/tesseract
then rename like tesseract_4.1.1 at root folder

#### Step 3 Download leptonica
download leptonica at  http://leptonica.org/download.html
then rename like leptonica_1.79.0 at root folder

#### Step 4 change version you want for libs in include/config.mk

#### Step 5 edit in file tesseract/configure.ac 

AX_CHECK_COMPILE_FLAG([-mavx], [avx=true], [avx=false], [$WERROR])<br/>
=> AX_CHECK_COMPILE_FLAG([-mavx], [avx=false], [avx=false], [$WERROR])

AX_CHECK_COMPILE_FLAG([-mfma], [fma=true], [fma=false], [$WERROR])<br/>
=>AX_CHECK_COMPILE_FLAG([-mfma], [fma=false], [fma=false], [$WERROR])

AX_CHECK_COMPILE_FLAG([-msse4.1], [sse41=true], [sse41=false], [$WERROR])<br/>
=>AX_CHECK_COMPILE_FLAG([-msse4.1], [sse41=false], [sse41=false], [$WERROR])<br/>

AX_CHECK_COMPILE_FLAG([-mavx2], [avx2=true], [avx2=false], [$WERROR])<br/>
=>AX_CHECK_COMPILE_FLAG([-mavx2], [avx2=false], [avx2=false], [$WERROR])

PKG_CHECK_MODULES([libcurl], [libcurl], [have_libcurl=true], [have_libcurl=false])<br/>
=>PKG_CHECK_MODULES([libcurl], [libcurl], [have_libcurl=false], [have_libcurl=false])

#### Step 6 fix "_opendir$INODE64" not found
    copy fix_opendir_INODE64.c to leptonica/src
    include file to  leptonica/sarray1.c
    ```#include "fix_opendir_INODE64.c" ```    

#### Step 7 fix 'curl/curl.h' file not found (Because the curl already included so this step may be not neccessary, but in case you have such error please replace my curl lib with your own curl lib)      
    download curl https://curl.haxx.se/download.html
    then configure it to a another destination folder
    ```
    ./configure --prefix=/path/to/destination/
    `xcode-select -p`/usr/bin/make -sj8 
    `xcode-select -p`/usr/bin/make install
    ```
    copy file lib/lcurl.a to dependencies/lib
    copy curl src folder to dependencies/include/curl    


#### Step 8
Run make in libtiff-ios folder

#### Step 9
Run make in foot folder

# NOTE when compiling, if such error occurs
    ```
    configure: error: C++ compiler cannot create executables    
    ```
    For example:
    ```
    cd /Users/trung.nv/Desktop/trungnv/demo/tesseract-ios/make/tesseract-4.1.1/x86_64-apple-darwin ; \
	ln -s /Users/trung.nv/Desktop/trungnv/demo/tesseract-ios/make/leptonica-1.79.0/src/ leptonica ; \
	../configure --host=x86_64-apple-darwin --prefix=`pwd` --enable-shared=no --disable-graphics
    ```
    copy the error command to another terminal tab and run   
