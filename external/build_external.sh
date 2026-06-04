set -e
SDKPATH=`xcrun --sdk iphoneos --show-sdk-path`
WORKINGDIR="build"
CMAKE_BUILD_TYPE="release"
JOBS=4

#mkdir -p $(WORKINGDIR)
#cd $(WORKINGDIR) && cmake . \
#        -DCMAKE_BUILD_TYPE=$(CMAKE_BUILD_TYPE) \
#        -DCMAKE_CROSSCOMPILING=true \
#        -DCMAKE_SYSTEM_NAME=Darwin \
#        -DCMAKE_SYSTEM_PROCESSOR=aarch64 \
#        -DCMAKE_OSX_SYSROOT="$(SDKPATH)" \
#        -DCMAKE_OSX_ARCHITECTURES=arm64 \
#        -DCMAKE_C_FLAGS="-arch arm64" \
#        ..

#cmake --build $(WORKINGDIR) --config $(CMAKE_BUILD_TYPE) -j$(JOBS)

cp ../MGL/include/MGLContext.h glfw/src
cp ../MGL/include/MGLRenderer.h glfw/src
cd SPIRV-Tools
#mkdir -p build
#cd build
#cmake .. $ios -DCMAKE_POLICY_VERSION_MINIMUM=3.5
#make -j 4
mkdir -p $WORKINGDIR
cd $WORKINGDIR && cmake . \
    -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
    -DCMAKE_CROSSCOMPILING=true \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_SYSTEM_PROCESSOR=aarch64 \
    -DCMAKE_OSX_SYSROOT=$SDKPATH \
    -DCMAKE_OSX_ARCHITECTURES=arm64 \
    -DCMAKE_C_FLAGS="-arch arm64" \
    ..

cmake --build . --config $CMAKE_BUILD_TYPE -j$JOBS
cd ../..
cd SPIRV-Cross
#mkdir -p build
#cd build
#cmake .. $ios -DCMAKE_POLICY_VERSION_MINIMUM=3.5
#make -j 4
#cd ../..
mkdir -p $WORKINGDIR
cd $WORKINGDIR && cmake . \
    -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
    -DCMAKE_CROSSCOMPILING=true \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_SYSTEM_PROCESSOR=aarch64 \
    -DCMAKE_OSX_SYSROOT=$SDKPATH \
    -DCMAKE_OSX_ARCHITECTURES=arm64 \
    -DCMAKE_C_FLAGS="-arch arm64" \
    ..

cmake --build . --config $CMAKE_BUILD_TYPE -j$JOBS
cd ../..
cd SPIRV-Headers
#mkdir -p build
#cd build
#cmake .. $ios -DCMAKE_POLICY_VERSION_MINIMUM=3.5
#make -j 4
#cd ../..
mkdir -p $WORKINGDIR
cd $WORKINGDIR && cmake . \
    -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
    -DCMAKE_CROSSCOMPILING=true \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_OSX_DEPLOYMENT_TARGET=14.0 \
    -DCMAKE_SYSTEM_PROCESSOR=aarch64 \
    -DCMAKE_OSX_SYSROOT=$SDKPATH \
    -DCMAKE_OSX_ARCHITECTURES=arm64 \
    -DCMAKE_C_FLAGS="-arch arm64" \
    ..

cmake --build . --config $CMAKE_BUILD_TYPE -j$JOBS
cd ../..
cd glslang
./update_glslang_sources.py
#mkdir -p build
#cd build
#cmake .. $ios -DCMAKE_POLICY_VERSION_MINIMUM=3.5
#make -j 4
#cd ../..
mkdir -p $WORKINGDIR
cd $WORKINGDIR && cmake . \
    -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
    -DCMAKE_CROSSCOMPILING=true \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_SYSTEM_PROCESSOR=aarch64 \
    -DCMAKE_OSX_SYSROOT=$SDKPATH \
    -DCMAKE_OSX_ARCHITECTURES=arm64 \
    -DCMAKE_C_FLAGS="-arch arm64" \
    ..

cmake --build . --config $CMAKE_BUILD_TYPE -j$JOBS
cd ../..
#cd glfw
#mkdir build
#cd build
#cmake .. $ios -DCMAKE_POLICY_VERSION_MINIMUM=3.5
#make -j 4 glfw
#cd ../..

