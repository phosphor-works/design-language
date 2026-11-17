// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import Phosphor.Design

// A color role: the swatch, its name, its current value and its use.
Column {
    id: swatch

    property color color
    property string name
    property string use

    width: 132
    spacing: 3

    Rectangle {
        width: parent.width
        height: 56
        radius: Metrics.radiusControl + 2
        color: swatch.color
        border.width: 1
        border.color: Theme.line
    }

    Text {
        topPadding: 5
        text: swatch.name
        color: Theme.text
        font.family: Metrics.fontUi
        font.pixelSize: Metrics.textBody
        font.weight: Metrics.weightStrong
    }

    Text {
        text: swatch.color.toString().toUpperCase()
        color: Theme.muted
        font.family: Metrics.fontMono
        font.pixelSize: 12
    }

    Text {
        width: parent.width
        wrapMode: Text.Wrap
        text: swatch.use
        color: Theme.muted
        font.family: Metrics.fontUi
        font.pixelSize: 12
    }
}
