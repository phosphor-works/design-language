# SPDX-FileCopyrightText: 2026 fuddlesworth
# SPDX-License-Identifier: GPL-3.0-or-later

cmake_minimum_required(VERSION 3.25)

project(PhosphorDesign VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "Build type" FORCE)
endif()

include(GNUInstallDirs)

# The presets set this to ON. The tests render each story, check the text and test the guard hook.
option(BUILD_TESTING "Build and register the tests" OFF)
if(BUILD_TESTING)
    enable_testing()
    find_package(Python3 REQUIRED COMPONENTS Interpreter)
    add_test(NAME prose
             COMMAND Python3::Interpreter "${CMAKE_CURRENT_SOURCE_DIR}/.claude/skills/dl-write/check_prose.py" --errors)
    add_test(NAME guard
             COMMAND Python3::Interpreter "${CMAKE_CURRENT_SOURCE_DIR}/.claude/hooks/test_guard.py")
endif()

if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    add_compile_options(-Wall -Wextra -Wpedantic -Wno-unused-parameter)
endif()

# The same minimum as the phosphor libraries, so that one checkout builds the two.
set(PHOSPHOR_DESIGN_QT_MIN 6.10)
set(QT_MIN_VERSION "${PHOSPHOR_DESIGN_QT_MIN}.0")

# ── The library ────────────────────────────────────────────────────────────
# Phosphor.Design (tokens and components) and Phosphor.Style (the Qt Quick Controls style) are QML
# files. Each module has a qmldir that a person writes. The build compiles none of these files. No
# module depends on a phosphor library, because phosphor-libs and each app depend on this
# repository.
set(PHOSPHOR_DESIGN_QML_INSTALL_DIR "${CMAKE_INSTALL_LIBDIR}/qt6/qml"
    CACHE STRING "Where the QML modules install, relative to the prefix or absolute")

install(DIRECTORY qml/Phosphor
        DESTINATION "${PHOSPHOR_DESIGN_QML_INSTALL_DIR}"
        FILES_MATCHING PATTERN "*.qml" PATTERN "qmldir")

# ── The storybook ──────────────────────────────────────────────────────────
# A development tool. It loads the QML from this source tree and reloads when a file changes, so it
# does not install.
option(PHOSPHOR_DESIGN_BUILD_STORYBOOK "Build phosphor-storybook, which shows every component in each of its states" ON)

# Stories for the components that the phosphor libraries ship (Phosphor.Theme, Phosphor.Widgets).
# Only the storybook builds those libraries. The first configure downloads the two commits that
# cmake/DesignDependencies.cmake pins. The `dev` preset sets this option to ON.
option(PHOSPHOR_DESIGN_WITH_PHOSPHOR
       "Build the stories of the components in phosphor-libs and phosphor-shell-libs, from the pinned commits"
       OFF)

if(PHOSPHOR_DESIGN_BUILD_STORYBOOK)
    find_package(Qt6 ${PHOSPHOR_DESIGN_QT_MIN} REQUIRED COMPONENTS Core Gui Qml Quick QuickControls2)
    qt_standard_project_setup()
    add_compile_definitions(QT_NO_CAST_FROM_ASCII QT_NO_KEYWORDS)
    if(PHOSPHOR_DESIGN_WITH_PHOSPHOR)
        include(cmake/DesignPhosphor.cmake)
    endif()
    add_subdirectory(storybook)
endif()
