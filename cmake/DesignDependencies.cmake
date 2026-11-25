# SPDX-FileCopyrightText: 2026 Phosphor Works Team
# SPDX-License-Identifier: LGPL-2.1-or-later
#
# The sources that the storybook builds and that are not in this repository: one commit of
# phosphor-libs and one commit of phosphor-shell-libs. Each is pinned to its archive by commit, URL
# and SHA-256. This file is the only location of a pin.
#
# Only the storybook uses these sources, and only when PHOSPHOR_DESIGN_WITH_PHOSPHOR is on. The
# library (qml/) uses only Qt.
#
# CPM.cmake downloads each archive one time into CPM_SOURCE_CACHE. The default is .cache/cpm at the
# root of this repository, and each build directory uses it. A configure needs no network after the
# first download.
#
# To build a local checkout in place of a pin, set -DCPM_phosphor-libs_SOURCE=<dir> or
# -DCPM_phosphor-shell-libs_SOURCE=<dir>. The `local` preset sets the two variables to the
# checkouts next to this repository.
#
# The storybook is a development tool and has no package. Thus this file has no mode for a build
# from archives that a packager supplies.
#
# To move a pin, change its VERSION, its URL and its SHA256 together. Get the hash from a download
# that you checked. The two commits must agree: phosphor-shell-libs builds against the
# phosphor-libs commit in its cmake/PhosphorShellLibsDependencies.cmake. Use that commit here.

include_guard(GLOBAL)

set(PHOSPHOR_DESIGN_DEPS phosphor-libs phosphor-shell-libs)

set(PHOSPHOR_DESIGN_DEP_phosphor-libs_VERSION "c5d6ee8a24f803607b403f90b8625b94b8a25110")
set(PHOSPHOR_DESIGN_DEP_phosphor-libs_URL "https://github.com/phosphor-works/phosphor-libs/archive/c5d6ee8a24f803607b403f90b8625b94b8a25110.tar.gz")
set(PHOSPHOR_DESIGN_DEP_phosphor-libs_SHA256 "f072437c31f9b96e5ed43c32e55bc0e6e8c7ac7323262dbeaf871008c670e8e6")

set(PHOSPHOR_DESIGN_DEP_phosphor-shell-libs_VERSION "18386019f57cd9d225c1bfe5d3bd4668cba07ddb")
set(PHOSPHOR_DESIGN_DEP_phosphor-shell-libs_URL "https://github.com/phosphor-works/phosphor-shell-libs/archive/18386019f57cd9d225c1bfe5d3bd4668cba07ddb.tar.gz")
set(PHOSPHOR_DESIGN_DEP_phosphor-shell-libs_SHA256 "4f93d39a3d793787007c9cb21ca7b5803837d395eb64e194b84a3ad3db5aab5e")

# CPM.cmake, the same release that phosphor-libs pins. Thus the module of phosphor-libs uses this
# copy.
set(PHOSPHOR_DESIGN_CPM_VERSION "0.43.2")
set(PHOSPHOR_DESIGN_CPM_SHA256 "49a3bef91ceb65bb66d57255e12d1ffd22abc2f6408fa9fe4534c544a2f232aa")

get_filename_component(_PHOSPHOR_DESIGN_DEPS_ROOT "${CMAKE_CURRENT_LIST_DIR}/.." ABSOLUTE)

# CPM keeps a part of its state in variables of the scope that includes it. Thus this file loads
# CPM here, at the scope that includes this file, and not in a function.
if(NOT COMMAND CPMAddPackage)
    if(NOT DEFINED CPM_SOURCE_CACHE AND NOT DEFINED ENV{CPM_SOURCE_CACHE})
        set(CPM_SOURCE_CACHE "${_PHOSPHOR_DESIGN_DEPS_ROOT}/.cache/cpm" CACHE PATH
            "Where CPM.cmake keeps the packages that it downloads. Each build directory uses it")
    endif()
    if(DEFINED CPM_SOURCE_CACHE)
        set(_design_cpm_file "${CPM_SOURCE_CACHE}/cpm/CPM_${PHOSPHOR_DESIGN_CPM_VERSION}.cmake")
    else()
        set(_design_cpm_file "$ENV{CPM_SOURCE_CACHE}/cpm/CPM_${PHOSPHOR_DESIGN_CPM_VERSION}.cmake")
    endif()
    # Each configure checks the hash, so a damaged copy in the cache does not stay.
    set(_design_cpm_have "")
    if(EXISTS "${_design_cpm_file}")
        file(SHA256 "${_design_cpm_file}" _design_cpm_have)
    endif()
    if(NOT _design_cpm_have STREQUAL PHOSPHOR_DESIGN_CPM_SHA256)
        file(DOWNLOAD
             "https://github.com/cpm-cmake/CPM.cmake/releases/download/v${PHOSPHOR_DESIGN_CPM_VERSION}/CPM.cmake"
             "${_design_cpm_file}"
             EXPECTED_HASH SHA256=${PHOSPHOR_DESIGN_CPM_SHA256}
             STATUS _design_cpm_status)
        list(GET _design_cpm_status 0 _design_cpm_code)
        if(NOT _design_cpm_code EQUAL 0)
            file(REMOVE "${_design_cpm_file}")
            message(FATAL_ERROR
                "Could not download CPM.cmake ${PHOSPHOR_DESIGN_CPM_VERSION}: ${_design_cpm_status}. "
                "Turn PHOSPHOR_DESIGN_WITH_PHOSPHOR off to build with only Qt.")
        endif()
    endif()
    include("${_design_cpm_file}")
endif()

# design_fetch_dependency(<name>)
#
# Gets the pinned archive <name> and sets <name>_SOURCE_DIR in the scope of the caller. The caller
# selects what to build from that tree.
function(design_fetch_dependency name)
    if(NOT name IN_LIST PHOSPHOR_DESIGN_DEPS)
        message(FATAL_ERROR "design_fetch_dependency: ${CMAKE_CURRENT_FUNCTION_LIST_FILE} has no pin for '${name}'")
    endif()
    # Use the pinned archive and not an installed package. An installed package gives no source
    # tree, and it is not the pinned code.
    set(CPM_USE_LOCAL_PACKAGES OFF)
    set(CPM_LOCAL_PACKAGES_ONLY OFF)
    CPMAddPackage(NAME ${name} VERSION "${PHOSPHOR_DESIGN_DEP_${name}_VERSION}"
                  URL "${PHOSPHOR_DESIGN_DEP_${name}_URL}"
                  URL_HASH SHA256=${PHOSPHOR_DESIGN_DEP_${name}_SHA256}
                  DOWNLOAD_ONLY YES)
    if(NOT IS_DIRECTORY "${${name}_SOURCE_DIR}/libs")
        message(FATAL_ERROR
            "CPM gave no ${name} tree (${name}_SOURCE_DIR is '${${name}_SOURCE_DIR}'). "
            "Check CPM_${name}_SOURCE and CPM_SOURCE_CACHE.")
    endif()
    set(${name}_SOURCE_DIR "${${name}_SOURCE_DIR}" PARENT_SCOPE)
endfunction()
