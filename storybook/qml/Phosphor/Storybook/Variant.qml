// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import Phosphor.Design

// One state of a component, with its name below it. `surface` puts the content on a shell surface.
// Use it for a component that is always on a shell surface.
Column {
    id: variant

    property string name
    property bool surface: false
    default property alias content: slot.data

    spacing: 10

    Rectangle {
        width: slot.width + (variant.surface ? 2 * Metrics.pad : 0)
        height: slot.height + (variant.surface ? 2 * Metrics.pad : 0)
        radius: Metrics.radiusSurface
        color: variant.surface ? Theme.surface : "transparent"
        border.width: variant.surface ? 1 : 0
        border.color: Theme.line

        Item {
            id: slot

            x: variant.surface ? Metrics.pad : 0
            y: variant.surface ? Metrics.pad : 0
            width: childrenRect.width
            height: childrenRect.height
        }
    }

    Text {
        text: variant.name
        color: Theme.muted
        font.family: Metrics.fontUi
        font.pixelSize: 12
        font.weight: Metrics.weightBody
    }
}
