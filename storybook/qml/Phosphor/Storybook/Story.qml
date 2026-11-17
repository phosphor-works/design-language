// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick

// A story shows one component in each state that a reviewer must see. Each child is a Variant.
//
// Set `fill` for a story that is one scene and fills the canvas.
Item {
    id: story

    default property alias variants: flow.data
    property bool fill: false

    implicitHeight: flow.height

    Flow {
        id: flow

        width: story.width
        padding: 28
        spacing: 36
    }
}
