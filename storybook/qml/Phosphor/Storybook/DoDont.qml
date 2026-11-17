// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import Phosphor.Design

// A pair of examples from the guide: the correct text and the text that it replaces. `why` is the
// rule that the pair shows.
Column {
    id: pair

    property string good
    property string bad
    property string why

    width: parent ? Math.min(parent.width, 760) : implicitWidth
    spacing: Metrics.space6

    Row {
        width: parent.width
        spacing: Metrics.gap

        Repeater {
            model: [[pair.good, "check", Theme.success], [pair.bad, "close", Theme.danger]]

            Rectangle {
                required property var modelData

                width: (pair.width - Metrics.gap) / 2
                height: Math.max(Metrics.fieldHeight, sample.implicitHeight + 2 * Metrics.space10)
                radius: Metrics.radiusControl
                color: Theme.card

                Icon {
                    id: verdict

                    x: Metrics.space12
                    anchors.verticalCenter: parent.verticalCenter
                    name: parent.modelData[1]
                    size: Metrics.iconSmall
                    color: parent.modelData[2]
                }

                Text {
                    id: sample

                    anchors.left: verdict.right
                    anchors.leftMargin: Metrics.iconGap
                    anchors.right: parent.right
                    anchors.rightMargin: Metrics.space12
                    anchors.verticalCenter: parent.verticalCenter
                    wrapMode: Text.Wrap
                    text: parent.modelData[0]
                    color: Theme.text
                    font.family: Metrics.fontUi
                    font.pixelSize: Metrics.textBody
                    font.weight: Metrics.weightBody
                }
            }
        }
    }

    Text {
        width: parent.width
        wrapMode: Text.Wrap
        text: pair.why
        color: Theme.muted
        font.family: Metrics.fontUi
        font.pixelSize: Metrics.textLabel
        font.weight: Metrics.weightBody
    }
}
