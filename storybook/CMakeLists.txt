# SPDX-FileCopyrightText: 2026 Phosphor Works Team
# SPDX-License-Identifier: LGPL-2.1-or-later

qt_add_executable(phosphor-storybook
    main.cpp
    session.cpp
    session.h
)

# The storybook reads its QML from the source tree and not from resources. Thus a saved file appears
# without a build.
target_compile_definitions(phosphor-storybook PRIVATE
    STORYBOOK_SOURCE_DIR="${CMAKE_SOURCE_DIR}"
)

target_link_libraries(phosphor-storybook PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
)

if(PHOSPHOR_DESIGN_WITH_PHOSPHOR)
    design_link_phosphor(phosphor-storybook)
endif()

# The build compiles no QML. These tests load each story and fail on a QML error or a warning.
if(BUILD_TESTING)
    foreach(scheme dark light)
        add_test(NAME stories-render-${scheme}
                 COMMAND Python3::Interpreter "${CMAKE_CURRENT_SOURCE_DIR}/tests/render_stories.py"
                         "$<TARGET_FILE:phosphor-storybook>" --set scheme=${scheme})
    endforeach()
endif()
