vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO QiangqiangZhou/SimpleAmqpClient
    REF v2.5.2
    SHA512 a0b820239631c4ade83f2057442c2c44e4bb79a85837f81974d78cbb0b309f2b23ad738d435b760281c5e90c17b1ca777fa8fe38147abec2ca1105bbf4b87da6
    HEAD_REF master
)

set(BUILD_SHARED_LIBS ON)
# note: Platform-native buildsystem will be more helpful to launch/debug the tests/samples.
# note: The PDB file path is making Ninja fails to install.
#       For Windows, we rely on /MP. The other platforms should be able to build with PREFER_NINJA.
set(WINDOWS_USE_MSBUILD ON)
if(VCPKG_TARGET_IS_WINDOWS)
    set(WINDOWS_USE_MSBUILD "WINDOWS_USE_MSBUILD")
endif()

#set(CGEN ${CURRENT_HOST_INSTALLED_DIR}/tools/contoso-cgen/cgen${VCPKG_HOST_EXECUTABLE_SUFFIX})
vcpkg_add_to_path("${CURRENT_HOST_INSTALLED_DIR}/tools/glib/")
vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
	OPTIONS
        -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}#		-DCODE_GENERATOR=${CGEN}
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

message(STATUS "Installing done")
