// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls
import Phosphor.Design
import Phosphor.Storybook

Doc {
    id: doc

    Para {
        text: "These sizes make the windows of two apps align: the height of a row, the width of a sidebar, the position of the content. The density switch in the toolbar changes the heights in the first table."
    }

    Heading {
        text: "Heights"
    }
    Spec {
        columns: [
            {
                "title": "Token",
                "width": 150
            },
            {
                "title": "Now",
                "width": 70,
                "mono": true
            },
            {
                "title": "Comfortable",
                "width": 110,
                "mono": true
            },
            {
                "title": "Compact",
                "width": 90,
                "mono": true
            },
            {
                "title": "The height of",
                "width": 420
            }
        ]
        rows: [["barHeight", Metrics.barHeight, 44, 36, "The shell's bar."], ["tileHeight", Metrics.tileHeight, 54, 46, "A quick setting."], ["rowHeight", Metrics.rowHeight, 50, 42, "A setting: its name on one side and its control on the other side."], ["listRowHeight", Metrics.listRowHeight, 44, 38, "An item that the user selects from a list in the shell: a network, a device."], ["fieldHeight", Metrics.fieldHeight, 40, 34, "A text field."], ["navRowHeight", Metrics.navRowHeight, 32, 28, "A page in a sidebar."], ["controlHeight", Metrics.controlHeight, 30, 26, "A button or a segmented control."], ["targetMin", Metrics.targetMin, 28, 28, "The smallest item that the user can press, in width and in height."]]
    }

    Heading {
        text: "Widths and icons"
    }
    Spec {
        columns: [
            {
                "title": "Token",
                "width": 150
            },
            {
                "title": "Value",
                "width": 70,
                "mono": true
            },
            {
                "title": "Used for",
                "width": 560
            }
        ]
        rows: [["sidebarWidth", Metrics.sidebarWidth, "A navigation column. Its width does not change with the window."], ["pageWidth", Metrics.pageWidth, "The maximum width of a column of settings. In a wider window, the column keeps this width and stays at the left."], ["readingWidth", Metrics.readingWidth, "The maximum width of a paragraph."], ["navIndent", Metrics.navIndent, "The indent of a page below its category."], ["iconSmall", Metrics.iconSmall, "An icon inside a control, a sidebar row or a row of settings."], ["iconSize", Metrics.iconSize, "An icon in the bar, on a tile or in a shell list."], ["iconLarge", Metrics.iconLarge, "A logo, or the icon of an empty state."]]
    }

    Heading {
        text: "A window"
    }
    Para {
        text: "This is a settings window that uses the tokens above. The sidebar has the width sidebarWidth and the sidebar ground. The page starts pageMargin from the sidebar and from the top. A card has a maximum width of pageWidth, and cards are gapLoose apart. A row has the height rowHeight and has padCard at each side."
    }
    Rectangle {
        width: Math.min(parent.width, Metrics.sidebarWidth + Metrics.pageWidth + 2 * Metrics.pageMargin)
        height: page.height + 2 * Metrics.pageMargin
        radius: Metrics.radiusCard
        color: Theme.surface
        border.width: Metrics.lineWidth
        border.color: Theme.line
        clip: true

        Rectangle {
            width: Metrics.sidebarWidth
            height: parent.height
            color: Theme.sidebar

            NavList {
                x: Metrics.space12
                y: Metrics.space12
                width: parent.width - 2 * Metrics.space12
                model: [
                    {
                        "text": "Placement",
                        "children": [
                            {
                                "id": "snapping",
                                "text": "Snapping",
                                "icon": "zones"
                            },
                            {
                                "id": "tiling",
                                "text": "Tiling",
                                "icon": "tiling"
                            },
                            {
                                "id": "scrolling",
                                "text": "Scrolling",
                                "icon": "scrolling"
                            }
                        ]
                    }
                ]
                current: "tiling"
                onPicked: id => current = id
            }
        }

        Column {
            id: page

            x: Metrics.sidebarWidth + Metrics.pageMargin
            y: Metrics.pageMargin
            width: Math.min(parent.width - x - Metrics.pageMargin, Metrics.pageWidth)
            spacing: Metrics.gapLoose

            Label {
                text: "Tiling"
                font.pixelSize: Metrics.textTitle
                font.weight: Metrics.weightStrong
                font.letterSpacing: -0.3
                bottomPadding: Metrics.space4
            }

            SettingGroup {
                width: parent.width

                SettingRow {
                    text: "Master ratio"

                    Slider {
                        from: 50
                        to: 66
                        value: 58
                    }
                }
                SettingRow {
                    text: "New windows"

                    Segmented {
                        label: "New windows"
                        options: [
                            {
                                "value": "master",
                                "text": "Master"
                            },
                            {
                                "value": "stack",
                                "text": "Stack"
                            }
                        ]
                        value: "stack"
                    }
                }
            }

            SettingGroup {
                width: parent.width

                SettingRow {
                    text: "Smart gaps"

                    Switch {
                        Accessible.name: "Smart gaps"
                    }
                }
            }
        }
    }

    Heading {
        text: "Rules"
    }
    Para {
        text: "A setting is a SettingRow. Its name is at the left and its control is at the right, and the two are centered on the row. Do not put a description below a row. If the name and the control do not explain a setting, change the name or add a preview."
    }
    Para {
        text: "Put related rows in one SettingGroup. A line separates the rows. A group has no title. If a group must have a name, make it a section with a heading, gapSection below the previous section."
    }
    Para {
        text: "The title, the cards and the headings of a page have the same left edge. The controls of a card have the same right edge."
    }
    Para {
        text: "The shell keeps screenInset between the bar and the edge of the screen. Windows keep the same distance from each other and from the bar. Thus the desktop has one margin."
    }
    Para {
        text: "Each item that the user can press has a minimum size of targetMin in width and in height. The drawing can be smaller. An icon button draws a 16 px icon in a 28 px target."
    }
}
