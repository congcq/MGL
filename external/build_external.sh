set -e
SDKPATH=`xcrun --sdk iphoneos --show-sdk-path`
WORKINGDIR="build"
CMAKE_BUILD_TYPE="release"
JOBS=`sysctl -n hw.ncpu`

cd SPIRV-Tools
mkdir -p $WORKINGDIR
cd $WORKINGDIR && cmake . \
    -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
    -DCMAKE_CROSSCOMPILING=true \
    -DCMAKE_SYSTEM_NAME=iOS \
    -DCMAKE_SYSTEM_PROCESSOR=aarch64 \
    -DCMAKE_OSX_SYSROOT=$SDKPATH \
    -DCMAKE_OSX_ARCHITECTURES=arm64 \
    -DCMAKE_C_FLAGS="-arch arm64 -target arm64-apple-ios14.0" \
    -DCMAKE_CXX_FLAGS="-arch arm64 -target arm64-apple-ios14.0 -stdlib=libc++" \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    ..

cmake --build . --config $CMAKE_BUILD_TYPE -j$JOBS
cd ../..
cd SPIRV-Cross
mkdir -p $WORKINGDIR
cd $WORKINGDIR && cmake . \
    -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
    -DCMAKE_CROSSCOMPILING=true \
    -DCMAKE_SYSTEM_NAME=iOS \
    -DCMAKE_SYSTEM_PROCESSOR=aarch64 \
    -DCMAKE_OSX_SYSROOT=$SDKPATH \
    -DCMAKE_OSX_ARCHITECTURES=arm64 \
    -DCMAKE_C_FLAGS="-arch arm64 -target arm64-apple-ios14.0" \
    -DCMAKE_CXX_FLAGS="-arch arm64 -target arm64-apple-ios14.0 -stdlib=libc++" \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    ..

cmake --build . --config $CMAKE_BUILD_TYPE -j$JOBS
cd ../..
cd SPIRV-Headers
mkdir -p $WORKINGDIR
cd $WORKINGDIR && cmake . \
    -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
    -DCMAKE_CROSSCOMPILING=true \
    -DCMAKE_SYSTEM_NAME=iOS \
    -DCMAKE_OSX_DEPLOYMENT_TARGET=14.0 \
    -DCMAKE_SYSTEM_PROCESSOR=aarch64 \
    -DCMAKE_OSX_SYSROOT=$SDKPATH \
    -DCMAKE_OSX_ARCHITECTURES=arm64 \
    -DCMAKE_C_FLAGS="-arch arm64 -target arm64-apple-ios14.0" \
    -DCMAKE_CXX_FLAGS="-arch arm64 -target arm64-apple-ios14.0 -stdlib=libc++" \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    ..

cmake --build . --config $CMAKE_BUILD_TYPE -j$JOBS
cd ../..
cd glslang
./update_glslang_sources.py
mkdir -p $WORKINGDIR
cd $WORKINGDIR && cmake . \
    -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
    -DCMAKE_CROSSCOMPILING=true \
    -DCMAKE_SYSTEM_NAME=iOS \
    -DCMAKE_SYSTEM_PROCESSOR=aarch64 \
    -DCMAKE_OSX_SYSROOT=$SDKPATH \
    -DCMAKE_OSX_ARCHITECTURES=arm64 \
    -DCMAKE_C_FLAGS="-arch arm64 -target arm64-apple-ios14.0" \
    -DCMAKE_CXX_FLAGS="-arch arm64 -target arm64-apple-ios14.0 -stdlib=libc++" \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    ..

cmake --build . --config $CMAKE_BUILD_TYPE -j$JOBS
cd ../..

