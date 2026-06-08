cmake_minimum_required(VERSION 3.6)
project(MGL)

set(CMAKE_OSX_DEPLOYMENT_TARGET 14.0)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -target arm64-apple-ios14.0 -fcommon -fobjc-arc -ObjC")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -target arm64-apple-ios14.0 -fcommon -fobjc-arc -ObjC -stdlib=libc++")
set(CMAKE_C_FLAGS_DEBUG "-funwind-tables -g")

if("${CMAKE_HOST_SYSTEM_NAME}" MATCHES "Linux|^GNU$|Android")
    set(GLOBAL_LDFLAGS "-isysroot ${CMAKE_OSX_SYSROOT} -Wl,-syslibroot,${CMAKE_OSX_SYSROOT} -fuse-ld=lld")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${GLOBAL_LDFLAGS}")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${GLOBAL_LDFLAGS}")
endif()

set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -rpath @loader_path -rpath @executable_path")

include_directories(
    ${CMAKE_CURRENT_LIST_DIR}
    ${CMAKE_CURRENT_LIST_DIR}/MGL/include
    ${CMAKE_CURRENT_LIST_DIR}/MGL/include/GL
    ${CMAKE_CURRENT_LIST_DIR}/MGL/SPIRV/SPIRV-Cross
    ${CMAKE_CURRENT_LIST_DIR}/external/ANGLE
    ${CMAKE_CURRENT_LIST_DIR}/external/SPIRV-Cross
    ${CMAKE_CURRENT_LIST_DIR}/external/SPIRV-Tools/include
    ${CMAKE_CURRENT_LIST_DIR}/external/glslang/glslang/Include
    ${CMAKE_CURRENT_LIST_DIR}/external/glslang/SPIRV
    ${CMAKE_CURRENT_LIST_DIR}/external/glslang/OGLCompilersDLL
    ${CMAKE_CURRENT_LIST_DIR}/external/glslang/glslang/Public
    ${CMAKE_CURRENT_LIST_DIR}/external/glslang/glslang/MachineIndependent
    ${CMAKE_CURRENT_LIST_DIR}/external/glslang/glslang/GenericCodeGen
)

set(IOS_FRAMEWORKS
    "-framework UIKit"
    "-framework CoreFoundation"
    "-framework CoreGraphics"
    "-framework Foundation"
    "-framework QuartzCore"
    "-framework Metal"
    "-framework CoreVideo"
    "-framework GameController"
)

set(ANGLE_FRAMEWORKS
    "-F${CMAKE_CURRENT_LIST_DIR}/external"
    "-framework libEGL"
    "-framework libGLESv2"
)

file(GLOB MGL_C_SOURCES_COMMON "MGL/src/*.c")
file(GLOB MGL_M_SOURCES "MGL/src/*.m")

list(FILTER MGL_C_SOURCES_COMMON EXCLUDE REGEX ".*/gl_core\\.c$|.*/gl_es\\.c$")

file(GLOB SPIRV_CROSS_LIBS 
    ${CMAKE_CURRENT_LIST_DIR}/external/SPIRV-Cross/build/libspirv*.a
)

set(SPIRV_TOOLS_LIBS
    ${CMAKE_CURRENT_LIST_DIR}/external/SPIRV-Tools/build/source/libSPIRV-Tools.a
    ${CMAKE_CURRENT_LIST_DIR}/external/SPIRV-Tools/build/source/opt/libSPIRV-Tools-opt.a
    ${CMAKE_CURRENT_LIST_DIR}/external/SPIRV-Tools/build/source/link/libSPIRV-Tools-link.a
    ${CMAKE_CURRENT_LIST_DIR}/external/SPIRV-Tools/build/source/lint/libSPIRV-Tools-lint.a
)

set(GLSLANG_LIBS
    ${CMAKE_CURRENT_LIST_DIR}/external/glslang/build/glslang/libglslang.a
    ${CMAKE_CURRENT_LIST_DIR}/external/glslang/build/glslang/libMachineIndependent.a
    ${CMAKE_CURRENT_LIST_DIR}/external/glslang/build/glslang/libGenericCodeGen.a
    ${CMAKE_CURRENT_LIST_DIR}/external/glslang/build/glslang/OSDependent/Unix/libOSDependent.a
    ${CMAKE_CURRENT_LIST_DIR}/external/glslang/build/glslang/libglslang-default-resource-limits.a
    ${CMAKE_CURRENT_LIST_DIR}/external/glslang/build/SPIRV/libSPIRV.a
)

add_library(mgl_core SHARED
    ${MGL_C_SOURCES_COMMON}
    ${MGL_M_SOURCES}
    MGL/src/gl_core.c
)

target_compile_definitions(mgl_core PRIVATE 
    MGL_GL_CORE
    TARGET_OS_IPHONE=1
    ENABLE_OPT=0
    SPIRV_CROSS_C_API_MSL=1
    SPIRV_CROSS_C_API_GLSL=1
    SPIRV_CROSS_C_API_CPP=1
    SPIRV_CROSS_C_API_REFLECT=1
)

target_link_libraries(mgl_core
    ${IOS_FRAMEWORKS}
    ${ANGLE_FRAMEWORKS}
    ${GLSLANG_LIBS}
    ${SPIRV_CROSS_LIBS}
    ${SPIRV_TOOLS_LIBS}
    c++
)

set_target_properties(mgl_core PROPERTIES
    OUTPUT_NAME mgl_core
    SUFFIX .dylib
    PREFIX lib
)

add_library(mgl_es SHARED
    ${MGL_C_SOURCES_COMMON}
    ${MGL_M_SOURCES}
    MGL/src/gl_es.c
)

target_compile_definitions(mgl_es PRIVATE 
    MGL_GL_ES
    TARGET_OS_IPHONE=1
    ENABLE_OPT=0
    SPIRV_CROSS_C_API_MSL=1
    SPIRV_CROSS_C_API_GLSL=1
    SPIRV_CROSS_C_API_CPP=1
    SPIRV_CROSS_C_API_REFLECT=1
)

target_link_libraries(mgl_es
    ${IOS_FRAMEWORKS}
    ${ANGLE_FRAMEWORKS}
    ${GLSLANG_LIBS}
    ${SPIRV_CROSS_LIBS}
    ${SPIRV_TOOLS_LIBS}
    c++
)

set_target_properties(mgl_es PROPERTIES
    OUTPUT_NAME mgl_es
    SUFFIX .dylib
    PREFIX lib
)

set_source_files_properties(${MGL_M_SOURCES} PROPERTIES
    COMPILE_FLAGS "-fobjc-arc"
)

install(TARGETS mgl_core mgl_es
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)
