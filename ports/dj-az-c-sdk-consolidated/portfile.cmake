# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT_DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   CURRENT_INSTALLED_DIR     = ${VCPKG_ROOT_DIR}\installed\${TRIPLET}
#   DOWNLOADS                 = ${VCPKG_ROOT_DIR}\downloads
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#   VCPKG_TOOLCHAIN           = ON OFF
#   TRIPLET_SYSTEM_ARCH       = arm x86 x64
#   BUILD_ARCH                = "Win32" "x64" "ARM"
#   MSBUILD_PLATFORM          = "Win32"/"x64"/${TRIPLET_SYSTEM_ARCH}
#   DEBUG_CONFIG              = "Debug Static" "Debug Dll"
#   RELEASE_CONFIG            = "Release Static"" "Release DLL"
#   VCPKG_TARGET_IS_WINDOWS
#   VCPKG_TARGET_IS_UWP
#   VCPKG_TARGET_IS_LINUX
#   VCPKG_TARGET_IS_OSX
#   VCPKG_TARGET_IS_FREEBSD
#   VCPKG_TARGET_IS_ANDROID
#   VCPKG_TARGET_EXECUTABLE_SUFFIX
#   VCPKG_TARGET_STATIC_LIBRARY_SUFFIX
#   VCPKG_TARGET_SHARED_LIBRARY_SUFFIX
#
# 	See additional helpful variables in /docs/maintainers/vcpkg_common_definitions.md

# # Specifies if the port install should fail immediately given a condition
# vcpkg_fail_port_install(MESSAGE "dj-az-c-sdk-consolidated currently only supports Linux and Mac platforms" ON_TARGET "Windows")

# vcpkg_download_distfile(ARCHIVE
#     URLS "https://github.com/Azure/azure-sdk-for-c/archive/ab3c45b1759747bab2b9274d9028aacc82fc2764.zip"
#     FILENAME "dj-az-c-sdk-consolidated-0.1.0-preview.1.zip"
#     SHA512 d55d91e2917a756d1df887c0e443b6908312d3d5d79f50920e29c60efbfbdea5d4fdbc33d0b3efbc774b391e7ae541b6fd201af88c85a3ef95af4e1499409d68
# )

# vcpkg_extract_source_archive_ex(
#     OUT_SOURCE_PATH SOURCE_PATH
#     ARCHIVE ${ARCHIVE} 
#     # (Optional) A friendly name to use instead of the filename of the archive (e.g.: a version number or tag).
#     # REF 1.0.0
#     # (Optional) Read the docs for how to generate patches at:
#     # https://github.com/Microsoft/vcpkg/blob/master/docs/examples/patching.md
#     # PATCHES
#     #   001_port_fixes.patch
#     #   002_more_port_fixes.patch
# )

# # Check if one or more features are a part of a package installation.
# # See /docs/maintainers/vcpkg_check_features.md for more details
# vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
#   FEATURES # <- Keyword FEATURES is required because INVERTED_FEATURES are being used
#     tbb   WITH_TBB
#   INVERTED_FEATURES
#     tbb   ROCKSDB_IGNORE_PACKAGE_TBB
# )

# vcpkg_configure_cmake(
#     SOURCE_PATH ${SOURCE_PATH}
#     PREFER_NINJA # Disable this option if project cannot be built with Ninja
#     # OPTIONS -DUSE_THIS_IN_ALL_BUILDS=1 -DUSE_THIS_TOO=2
#     # OPTIONS_RELEASE -DOPTIMIZE=1
#     # OPTIONS_DEBUG -DDEBUGGABLE=1
# )

# vcpkg_install_cmake()

# # Moves all .cmake files from /debug/share/dj-az-c-sdk-consolidated/ to /share/dj-az-c-sdk-consolidated/
# # See /docs/maintainers/vcpkg_fixup_cmake_targets.md for more details
# vcpkg_fixup_cmake_targets(CONFIG_PATH cmake TARGET_PATH share/dj-az-c-sdk-consolidated)

# # Handle copyright
# file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/dj-az-c-sdk-consolidated RENAME copyright)

# # Post-build test for cmake libraries
# vcpkg_test_cmake(PACKAGE_NAME dj-az-c-sdk-consolidated)


vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Azure/azure-sdk-for-c
    REF djurek/vcpkg-consolidated
    SHA512 7c4d8e5131df5956ee6af1272d2dd5187c8959076be941a1b6dff00cf184d54cbc3572167b3a4ee603b085be497cdeb915487136effa6694ecb6852f6a903e4f
    HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
      -DWARNINGS_AS_ERRORS=OFF
)
vcpkg_install_cmake()

# License info is required
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/dj-az-c-sdk-consolidated RENAME copyright)

# Hack: There should be a way to prevent header files from showing up in debug/include
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

vcpkg_test_cmake(PACKAGE_NAME dj-az-c-sdk-consolidated MODULE)
