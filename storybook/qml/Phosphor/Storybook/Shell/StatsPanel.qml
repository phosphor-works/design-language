// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Templates as T
import Phosphor.Design

// The load of the computer: one row for each resource. A row shows the name, the recent history or
// the level, and the value at this time. A press opens the row and shows its details in the same
// panel.
//
// Each resource has one of the brand colors, so the user finds a row by its color. The panel has no
// title, no "desktop activity" line and no footer.
Column {
    id: root

    property string open // the resource whose details show
    property var stats: [
        {
            "id": "cpu",
            "icon": "chip",
            "name": "CPU",
            "value": "28%",
            "tone": "cyan",
            "history": [0.2, 0.24, 0.22, 0.3, 0.42, 0.36, 0.28, 0.26, 0.33, 0.3, 0.27, 0.28],
            "parts": [0.42, 0.18, 0.31, 0.12, 0.55, 0.22, 0.09, 0.36],
            "detail": "54 °C"
        },
        {
            "id": "gpu",
            "icon": "gpu",
            "name": "GPU",
            "value": "16%",
            "tone": "purple",
            "history": [0.1, 0.12, 0.1, 0.14, 0.2, 0.18, 0.15, 0.16, 0.17, 0.15, 0.16, 0.16],
            "parts": [0.19],
            "detail": "3.1 GB"
        },
        {
            "id": "memory",
            "icon": "memory",
            "name": "Memory",
            "value": "18.4 GB",
            "tone": "blue",
            "level": 0.29,
            "parts": [0.29, 0.08],
            "detail": "64 GB"
        },
        {
            "id": "network",
            "icon": "network",
            "name": "Network",
            "value": "12.4 MB/s",
            "tone": "cyan",
            "history": [0.3, 0.5, 0.45, 0.7, 0.62, 0.8, 0.74, 0.66, 0.7, 0.58, 0.61, 0.64],
            "parts": [],
            "detail": "0.8 MB/s"
        },
        {
            "id": "storage",
            "icon": "disk",
            "name": "Storage",
            "value": "358 GB",
            "tone": "rose",
            "level": 0.62,
            "parts": [0.62, 0.55],
            "detail": "840 GB"
        }
    ]

    readonly property real _inner: width - 2 * Metrics.space8

    width: 320
    padding: Metrics.space8
    topPadding: Metrics.space6

    Repeater {
        model: root.stats

        Column {
            id: stat

            required property var modelData
            readonly property color tone: Theme[modelData.tone] ?? Theme.accent
            readonly property bool isOpen: modelData.id === root.open

            width: root._inner

            T.AbstractButton {
                id: row

                width: parent.width
                height: Metrics.listRowHeight
                onClicked: root.open = stat.isOpen ? "" : stat.modelData.id

                Accessible.name: stat.modelData.name + " " + stat.modelData.value

                contentItem: Item {
                    Icon {
                        id: glyph

                        x: Metrics.padRow
                        anchors.verticalCenter: parent.verticalCenter
                        name: stat.modelData.icon
                        color: stat.tone
                    }

                    Text {
                        anchors.left: glyph.right
                        anchors.leftMargin: Metrics.space12
                        anchors.verticalCenter: parent.verticalCenter
                        text: stat.modelData.name
                        color: Theme.text
                        font.family: Metrics.fontUi
                        font.pixelSize: Metrics.textRow
                        font.weight: Metrics.weightBody
                    }

                    // A resource with a history shows the history. A resource that fills shows its level.
                    Sparkline {
                        anchors.right: number.left
                        anchors.rightMargin: Metrics.space12
                        anchors.verticalCenter: parent.verticalCenter
                        width: 64
                        height: 20
                        visible: stat.modelData.history !== undefined && !stat.isOpen
                        values: stat.modelData.history ?? []
                        color: stat.tone
                    }
                    Meter {
                        anchors.right: number.left
                        anchors.rightMargin: Metrics.space12
                        anchors.verticalCenter: parent.verticalCenter
                        width: 64
                        visible: stat.modelData.level !== undefined && !stat.isOpen
                        value: stat.modelData.level ?? 0
                        color: stat.tone
                    }

                    Text {
                        id: number

                        anchors.right: parent.right
                        anchors.rightMargin: Metrics.space10
                        anchors.verticalCenter: parent.verticalCenter
                        width: 72
                        horizontalAlignment: Text.AlignRight
                        text: stat.modelData.value
                        color: Theme.text
                        font.family: Metrics.fontMono
                        font.pixelSize: Metrics.textLabel
                    }
                }

                background: Rectangle {
                    radius: Metrics.radiusControl + 2
                    color: stat.isOpen ? Theme.selected : row.hovered ? Theme.hover : "transparent"

                    Behavior on color {
                        Tint {}
                    }

                    FocusRing {
                        target: row
                        around: parent.radius
                    }
                }
            }

            // The details: a larger history, one meter for each part, and the second value.
            Column {
                x: Metrics.padRow
                width: parent.width - 2 * Metrics.padRow
                topPadding: Metrics.space8
                bottomPadding: Metrics.space12
                spacing: Metrics.gap
                visible: stat.isOpen

                Sparkline {
                    width: parent.width
                    height: 48
                    visible: stat.modelData.history !== undefined
                    values: stat.modelData.history ?? []
                    color: stat.tone
                }

                Grid {
                    id: parts

                    readonly property int count: stat.modelData.parts.length

                    width: parent.width
                    columns: Math.min(4, Math.max(1, count))
                    spacing: Metrics.space8
                    visible: count > 0

                    Repeater {
                        model: stat.modelData.parts

                        Meter {
                            required property real modelData

                            width: (parts.width - (parts.columns - 1) * parts.spacing) / parts.columns
                            value: modelData
                            color: stat.tone
                        }
                    }
                }

                Text {
                    text: stat.modelData.detail
                    color: Theme.muted
                    font.family: Metrics.fontMono
                    font.pixelSize: Metrics.textLabel
                }
            }
        }
    }
}
