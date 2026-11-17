# SPDX-FileCopyrightText: 2026 fuddlesworth
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Adds the components that the PlasmaZones tree ships to the storybook, so that the user can compare
# them with the components of this repository.
#
# Only the storybook uses this file. The library (qml/) must not depend on a phosphor library,
# because phosphor-libs will depend on the library.
#
# Until phosphor-libs has its own repository, this file reads a PlasmaZones checkout next to this
# repository. Afterglow uses the same method. To show a branch that is not merged, set
# PHOSPHOR_DESIGN_PHOSPHOR_DIR to a different checkout or worktree.

set(_design_phosphor_dir "${PHOSPHOR_DESIGN_PHOSPHOR_DIR}")

foreach(tier phosphor-libs phosphor-shell-libs)
    if(NOT IS_DIRECTORY "${_design_phosphor_dir}/${tier}/libs")
        message(FATAL_ERROR
            "${_design_phosphor_dir} has no ${tier}/libs. Set -DPHOSPHOR_DESIGN_PHOSPHOR_DIR=/path/to/PlasmaZones, "
            "or turn PHOSPHOR_DESIGN_WITH_PHOSPHOR off to build the library's own stories alone.")
    endif()
endforeach()

# The install rules of the phosphor libraries are for a system install of phosphor. This build
# installs none of their files.
macro(install)
    if(NOT PHOSPHOR_DESIGN_INSIDE_PHOSPHOR)
        _install(${ARGN})
    endif()
endmacro()

# Adds the libraries of one tier in the given sequence. A library that calls find_package() for a
# different library uses the target in this build only if that target exists. Thus the sequence is
# the dependency sequence.
function(design_add_phosphor_libs tier)
    # The test suites of the phosphor libraries are not part of this build.
    set(BUILD_TESTING OFF)
    set(PHOSPHOR_DESIGN_INSIDE_PHOSPHOR ON)
    foreach(lib IN LISTS ARGN)
        if(NOT EXISTS "${_design_phosphor_dir}/${tier}/libs/${lib}/CMakeLists.txt")
            message(FATAL_ERROR
                "${_design_phosphor_dir}/${tier} has no ${lib}. This PlasmaZones checkout is older than the storybook expects.")
        endif()
        add_subdirectory("${_design_phosphor_dir}/${tier}/libs/${lib}"
                         "${CMAKE_BINARY_DIR}/phosphor/${lib}" EXCLUDE_FROM_ALL)
    endforeach()
endfunction()

# The pins of the archives that some libraries download. Include the module at the top scope,
# because its list is a directory variable.
if(EXISTS "${_design_phosphor_dir}/cmake/PhosphorDependencies.cmake")
    include("${_design_phosphor_dir}/cmake/PhosphorDependencies.cmake")
endif()

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
