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
      -DWARNINGS_AS_ERRORS=OFF # TODO: This will be redundant when https://github.com/Azure/azure-sdk-for-c/pull/261 checks in
)
vcpkg_install_cmake()

# License info is required
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/dj-az-c-sdk-consolidated RENAME copyright)

# Hack: There should be a way to prevent header files from showing up in debug/include
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

vcpkg_test_cmake(PACKAGE_NAME dj-az-c-sdk-consolidated MODULE)
