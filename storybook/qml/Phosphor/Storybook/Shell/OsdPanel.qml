// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import Phosphor.Design

// The on-screen display for a key that changes a level: volume, brightness. It opens from the
// status chip of the bar and closes again. The icon names the level, the meter shows it and the
// number gives its value.
Row {
    id: root

    property string icon: "volume"
    property real value: 0.62

    width: 240
    height: implicitHeight
    padding: Metrics.pad
    topPadding: Metrics.space8
    spacing: Metrics.gapLoose

    Icon {
        id: glyph

        anchors.verticalCenter: parent.verticalCenter
        name: root.icon
    }

    Meter {
        anchors.verticalCenter: parent.verticalCenter
        width: root.width - 2 * Metrics.pad - glyph.width - number.width - 2 * root.spacing
        value: root.value
    }

    Text {
        id: number

        anchors.verticalCenter: parent.verticalCenter
        width: 26
        horizontalAlignment: Text.AlignRight
        text: Math.round(root.value * 100)
        color: Theme.text
        font.family: Metrics.fontMono
        font.pixelSize: Metrics.textLabel
    }
}
