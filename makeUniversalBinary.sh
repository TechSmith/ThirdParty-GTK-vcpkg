ARM64_PATH=vcpkg/installed/arm64-osx-dynamic-release
ARM64_LIB=${ARM64_PATH}/lib

X86_64_PATH=vcpkg/installed/x64-osx-dynamic-release
X86_64_LIB=${X86_64_PATH}/lib

UNIVERSAL_PATH=universal
UNIVERSAL_LIB=${UNIVERSAL_PATH}/lib

rm -rf ${UNIVERSAL_PATH} # start clean

mkdir -p ${UNIVERSAL_LIB}

# Headers between arm64 and x86_64 are almost identical. Only libffi has some differences
# So let's just assume they are the same for now
cp -R ${ARM64_PATH}/include ${UNIVERSAL_PATH}/include

# Also copy over etc folder
cp -R ${ARM64_PATH}/etc ${UNIVERSAL_PATH}/etc

# glib is weird. It has headers in the lib folder
#mkdir -p ${UNIVERSAL_PATH}/lib/glib-2.0/include
#cp ${ARM64_PATH}/lib/glib-2.0/include/glibconfig.h ${UNIVERSAL_PATH}/lib/glib-2.0/include/glibconfig.h

# Make install paths relative for both arm64 and x86_64
#
# Only do this on actual files, not symbolic links (-type f)
find ${ARM64_LIB} -name "*.dylib" -type f -exec chmod +w {} \;
find ${ARM64_LIB} -name "*.dylib" -type f -exec python3 makeInstallPathsRelative.py @rpath {} \;
find ${X86_64_LIB} -name "*.dylib" -type f -exec chmod +w {} \;
find ${X86_64_LIB} -name "*.dylib" -type f -exec python3 makeInstallPathsRelative.py @rpath {} \;

# look through arm64 dylibs and start lipo'ing
for dylibPath in ${ARM64_LIB}/*.dylib; do
   
   filename="$(basename $dylibPath)"
   if [[ -L "$dylibPath" ]]; then
     echo "dylib = $dylibPath - copy symlink"
     cp -a $dylibPath ${UNIVERSAL_LIB}/$filename
   else
     echo "dylib = $dylibPath - need lipo"
     lipo -create -output ${UNIVERSAL_LIB}/$filename ${ARM64_LIB}/$filename ${X86_64_LIB}/$filename
   fi
done

