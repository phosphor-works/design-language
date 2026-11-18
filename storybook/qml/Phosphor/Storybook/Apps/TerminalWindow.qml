// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import Phosphor.Design

// The window of the Afterglow terminal: the frame of each Phosphor app, a row of tabs and the
// terminal.
//
// The tabs are in the title bar, so the terminal gets the full height. The cursor has the focus
// color, as each item that takes the keys. The text of the terminal uses the brand colors for its
// own purposes. These are the colors of the terminal palette. They are not states of the interface.
WindowFrame {
    id: root

    property var tabs: ["shell-design", "build", "logs"]
    property int tab: 0
    // Each line is a list of [color name, text]. An empty line is a gap.
    property var lines: [[["rose", "❯ "], ["text", "cmake --build build"]], [["cyan", "[128/128] "], ["text", "Linking phosphor-storybook"]], [], [["rose", "❯ "], ["text", "ctest --preset standalone"]], [["green", "✓ "], ["muted", "prose"]], [["green", "✓ "], ["muted", "guard"]], [["green", "✓ "], ["muted", "stories-render-dark"]], [["green", "✓ "], ["muted", "stories-render-light"]], [], [["cyan", "100% tests passed"]], [], [["rose", "❯ "]]]

    signal tabPicked(int index)

    implicitWidth: 560
    implicitHeight: 340
    icon: "terminal"
    title: tabs.length === 1 ? tabs[0] : ""

    tools: [
        IconButton {
            iconName: "plus"
            text: "New tab"
        }
    ]

    // With more than one tab, the tabs replace the title.
    TabBar {
        id: bar

        parent: root
        x: Metrics.padCard + Metrics.iconSmall + Metrics.iconGap
        y: (root.titleHeight - height) / 2 + root.border.width
        visible: root.tabs.length > 1
        width: root.tabs.length * 104
        currentIndex: root.tab
        onCurrentIndexChanged: root.tabPicked(currentIndex)

        Repeater {
            model: root.tabs

            TabButton {
                required property string modelData

                text: modelData
            }
        }
    }

    Column {
        x: Metrics.padCard
        y: Metrics.space4
        spacing: Metrics.space2

        Repeater {
            model: root.lines

            Row {
                id: line

                required property var modelData
                required property int index

                // A positioner does not place an item with a width of 0, so an empty line has a width.
                width: Math.max(1, implicitWidth)
                height: Metrics.lineBody

                Repeater {
                    model: line.modelData

                    Text {
                        required property var modelData

                        text: modelData[1]
                        color: Theme[modelData[0]] ?? Theme.text
                        font.family: Metrics.fontMono
                        font.pixelSize: Metrics.textBody
                    }
                }

                // The cursor is at the end of the last line.
                Rectangle {
                    visible: line.index === root.lines.length - 1
                    width: Metrics.space8
                    height: Metrics.lineBody - Metrics.space2
                    radius: 1
                    color: Theme.focus
                    opacity: root.focused ? 1 : 0.4
                }
            }
        }
    }
}
