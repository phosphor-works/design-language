// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import Phosphor.Design

// A table in the guide. Each column is { title, width, mono, swatch }. Each row is an array of
// strings, one string for each column. A `swatch` column draws its cell as a color chip, so its
// strings are colors.
Column {
    id: table

    property var columns: []
    property var rows: []

    width: parent ? parent.width : implicitWidth

    Row {
        height: Metrics.lineCaption + Metrics.space8

        Repeater {
            model: table.columns

            Text {
                required property var modelData

                width: modelData.width
                text: modelData.title
                color: Theme.muted
                font.family: Metrics.fontUi
                font.pixelSize: Metrics.textCaption
                font.weight: Metrics.weightStrong
            }
        }
    }

    Repeater {
        model: table.rows

        Column {
            id: line

            required property var modelData

            width: table.width

            Rectangle {
                width: parent.width
                height: Metrics.lineWidth
                color: Theme.line
            }

            Row {
                topPadding: Metrics.space8
                bottomPadding: Metrics.space8

                Repeater {
                    model: table.columns

                    Item {
                        id: cell

                        required property var modelData
                        required property int index
                        readonly property string value: String(line.modelData[index] ?? "")

                        width: modelData.width
                        height: Math.max(words.implicitHeight, chip.visible ? chip.height : 0)

                        Rectangle {
                            id: chip

                            visible: cell.modelData.swatch === true
                            width: 36
                            height: 20
                            radius: Metrics.radiusInner
                            color: visible ? cell.value : "transparent"
                            border.width: Metrics.lineWidth
                            border.color: Theme.line
                        }

                        Text {
                            id: words

                            visible: !chip.visible
                            width: parent.width - Metrics.space12
                            wrapMode: Text.Wrap
                            text: cell.value
                            color: cell.index === 0 ? Theme.text : Theme.muted
                            font.family: cell.modelData.mono === true ? Metrics.fontMono : Metrics.fontUi
                            font.pixelSize: cell.modelData.mono === true ? Metrics.textLabel : Metrics.textBody
                            font.weight: cell.index === 0 ? Metrics.weightStrong : Metrics.weightBody
                        }
                    }
                }
            }
        }
    }
}
