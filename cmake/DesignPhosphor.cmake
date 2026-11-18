# SPDX-FileCopyrightText: 2026 fuddlesworth
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Adds the components that the phosphor libraries ship to the storybook, so that the user can
# compare them with the components of this repository.
#
# Only the storybook uses this file. The library (qml/) must not depend on a phosphor library,
# because the phosphor libraries will depend on the library.
#
# The libraries come from the two commits that cmake/DesignDependencies.cmake pins: one of
# phosphor-libs and one of phosphor-shell-libs. That file tells how to build a local checkout in
# place of a pin, for example to show a branch that is not merged.

include("${CMAKE_CURRENT_LIST_DIR}/DesignDependencies.cmake")

design_fetch_dependency(phosphor-libs)
design_fetch_dependency(phosphor-shell-libs)

# The install rules of the phosphor libraries are for a system install of phosphor. This build
# installs none of their files.
macro(install)
    if(NOT PHOSPHOR_DESIGN_INSIDE_PHOSPHOR)
        _install(${ARGN})
    endif()
endmacro()

# Adds libraries of one repository in the given sequence. A library that calls find_package() for
# a different library uses the target in this build only if that target exists. Thus the sequence
# is the dependency sequence.
function(design_add_phosphor_libs repository)
    # The test suites of the phosphor libraries are not part of this build.
    set(BUILD_TESTING OFF)
    set(PHOSPHOR_DESIGN_INSIDE_PHOSPHOR ON)
    set(tree "${${repository}_SOURCE_DIR}")
    foreach(lib IN LISTS ARGN)
        if(NOT EXISTS "${tree}/libs/${lib}/CMakeLists.txt")
            message(FATAL_ERROR
                "${tree} has no ${lib}. This ${repository} tree is older than the commit that "
                "cmake/DesignDependencies.cmake pins.")
        endif()
        add_subdirectory("${tree}/libs/${lib}" "${CMAKE_BINARY_DIR}/phosphor/${lib}" EXCLUDE_FROM_ALL)
    endforeach()
endfunction()

# The pins of the archives that some phosphor libraries download. Include the module at the top
# scope, because its list is a directory variable. It loads no second CPM: DesignDependencies.cmake
# loaded one.
if(NOT EXISTS "${phosphor-libs_SOURCE_DIR}/cmake/PhosphorDependencies.cmake")
    message(FATAL_ERROR
        "${phosphor-libs_SOURCE_DIR}/cmake/PhosphorDependencies.cmake not found. This phosphor-libs tree is "
        "older than the commit that cmake/DesignDependencies.cmake pins.")
endif()
include("${phosphor-libs_SOURCE_DIR}/cmake/PhosphorDependencies.cmake")

# phosphor-wayland compiles generated Wayland protocol sources, and these are C. Without the C
# language, CMake ignores them with no message, and the link fails.
enable_language(C)

set(QT_SILENCE_MISSING_DEPENDENCY_TARGET_WARNING ON)
find_package(Qt6 ${PHOSPHOR_DESIGN_QT_MIN} REQUIRED COMPONENTS ShaderTools QuickShapes)

# Phosphor.Widgets needs Phosphor.Theme and org.phosphor.animation. The animation library needs the
# six libraries before it.
design_add_phosphor_libs(phosphor-libs
    phosphor-fsloader
    phosphor-registry
    phosphor-shaders
    phosphor-rendering
    phosphor-wayland
    phosphor-layer
    phosphor-animation
)
design_add_phosphor_libs(phosphor-shell-libs
    phosphor-theme
    phosphor-shell-widgets
)

function(design_link_phosphor target)
    target_link_libraries(${target} PRIVATE
        PhosphorShellWidgets::PhosphorShellWidgetsQml
        PhosphorShellWidgetsQmlplugin
        PhosphorThemeQml
        PhosphorThemeQmlplugin
        PhosphorAnimation::PhosphorAnimationQml
        PhosphorAnimationQmlplugin
    )
    target_compile_definitions(${target} PRIVATE STORYBOOK_HAVE_PHOSPHOR)
endfunction()
