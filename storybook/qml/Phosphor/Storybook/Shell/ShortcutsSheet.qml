// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls
import Phosphor.Design

// The list of keyboard shortcuts: the modes at the left, one field, and each action with its keys.
//
// A row is a name and its keys. The sheet has no tagline, no "field guide" card, no count line and
// no footer. The field filters the rows of all modes.
Surface {
    id: root

    property string mode: "tiling"
    property alias query: field.text
    property var modes: [
        {
            "id": "tiling",
            "text": "Tiling",
            "icon": "tiling"
        },
        {
            "id": "scrolling",
            "text": "Scrolling",
            "icon": "scrolling"
        },
        {
            "id": "snapping",
            "text": "Snapping",
            "icon": "zones"
        },
        {
            "id": "shell",
            "text": "Shell",
            "icon": "bar"
        }
    ]
    // Each group: { mode, name, rows }. Each row: [name, keys].
    property var groups: [
        {
            "mode": "tiling",
            "name": "Focus",
            "rows": [["Focus a window", ["Alt", "Shift", "←→↑↓"]], ["Focus master", ["Meta", "Shift", "M"]], ["Next window", ["Meta", "Alt", "."]], ["Previous window", ["Meta", "Alt", ","]]]
        },
        {
            "mode": "tiling",
            "name": "Arrange",
            "rows": [["Move a window", ["Meta", "Alt", "Shift", "←→↑↓"]], ["Swap with master", ["Meta", "Shift", "Enter"]], ["Float a window", ["Meta", "F"]], ["Rotate windows", ["Meta", "Ctrl", "]"]]]
        },
        {
            "mode": "scrolling",
            "name": "Columns",
            "rows": [["Focus a column", ["Meta", "←→"]], ["Move a column", ["Meta", "Shift", "←→"]], ["Change the width", ["Meta", "R"]]]
        },
        {
            "mode": "snapping",
            "name": "Zones",
            "rows": [["Snap to a zone", ["Meta", "1-9"]], ["Move to the next zone", ["Meta", "Shift", "→"]]]
        },
        {
            "mode": "shell",
            "name": "Panels",
            "rows": [["Launcher", ["Meta"]], ["Overview", ["Meta", "Tab"]], ["Lock", ["Meta", "L"]], ["Shortcuts", ["Meta", "/"]]]
        }
    ]

    readonly property var _shown: {
        const wanted = query.trim().toLowerCase();
        if (wanted === "")
            return groups.filter(group => group.mode === mode);
        return groups.map(group => ({
                    "mode": group.mode,
                    "name": group.name,
                    "rows": group.rows.filter(row => row[0].toLowerCase().includes(wanted))
                })).filter(group => group.rows.length > 0);
    }
    readonly property real _list: 480

    width: implicitWidth
    height: implicitHeight
    padding: Metrics.padCard

    Row {
        spacing: Metrics.gapSection

        NavList {
            width: 168
            model: root.modes
            current: root.query.trim() === "" ? root.mode : ""
            onPicked: id => {
                root.mode = id;
                field.clear();
            }
        }

        Column {
            width: root._list
            spacing: Metrics.gapLoose

            TextField {
                id: field

                width: parent.width
                leftPadding: Metrics.space12 + Metrics.iconSize + Metrics.iconGap
                placeholderText: "Search"

                Icon {
                    x: Metrics.space12
                    anchors.verticalCenter: parent.verticalCenter
                    name: "search"
                    color: field.activeFocus ? Theme.focus : Theme.muted
                }
            }

            Repeater {
                model: root._shown

                Column {
                    id: group

                    required property var modelData

                    width: root._list

                    Text {
                        x: Metrics.padRow
                        height: Metrics.lineLabel + Metrics.space8
                        text: group.modelData.name
                        color: Theme.muted
                        font.family: Metrics.fontUi
                        font.pixelSize: Metrics.textLabel
                        font.weight: Metrics.weightStrong
                    }

                    SettingGroup {
                        width: parent.width

                        Repeater {
                            model: group.modelData.rows

                            SettingRow {
                                required property var modelData

                                text: modelData[0]

                                Row {
                                    spacing: Metrics.space4

                                    Repeater {
                                        model: modelData[1]

                                        Keycap {
                                            required property string modelData

                                            text: modelData
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // No action matches the search.
            Item {
                width: parent.width
                height: Metrics.rowHeight
                visible: root._shown.length === 0

                Icon {
                    anchors.centerIn: parent
                    name: "search"
                    size: Metrics.iconLarge
                    color: Theme.muted
                    opacity: 0.5
                }
            }
        }
    }
}
