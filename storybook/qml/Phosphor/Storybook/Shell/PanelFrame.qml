// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import Phosphor.Design

// A panel outside the shell body, for a story that shows one state of a panel. The frame has the
// surface color and follows the size of the panel with the same spring as the shell body.
Rectangle {
    id: root

    default property alias panel: slot.data
    readonly property Item _panel: slot.children.length > 0 ? slot.children[0] : null

    width: _panel ? _panel.width : 0
    height: _panel ? Math.max(_panel.implicitHeight, _panel.height) : 0
    radius: Metrics.radiusSurface
    color: Theme.shellSurface
    border.width: Metrics.lineWidth
    border.color: Theme.line
    clip: true

    Behavior on height {
        enabled: !Session.capture

        FlowSpring {}
    }

    Item {
        id: slot

        anchors.fill: parent
    }
}
