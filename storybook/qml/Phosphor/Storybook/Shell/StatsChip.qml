// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import Phosphor.Design

// The system load in the bar. There are three styles. `numbers` shows the icon and one value.
// `meters` shows one small meter for each resource. `traces` shows the recent history of the first
// resource. A resource keeps its color in each style and in the panel.
BarChip {
    id: root

    property string style: "numbers" // numbers, meters, traces
    // Each resource: { name, value, level, tone, history }.
    property var stats: [
        {
            "name": "CPU",
            "value": "28%",
            "level": 0.28,
            "tone": "cyan",
            "history": [0.2, 0.24, 0.22, 0.3, 0.42, 0.36, 0.28, 0.26, 0.33, 0.3, 0.27, 0.28]
        },
        {
            "name": "GPU",
            "value": "16%",
            "level": 0.16,
            "tone": "purple",
            "history": [0.1, 0.12, 0.1, 0.14, 0.2, 0.18, 0.15, 0.16, 0.17, 0.15, 0.16, 0.16]
        },
        {
            "name": "Memory",
            "value": "29%",
            "level": 0.29,
            "tone": "blue",
            "history": [0.27, 0.27, 0.28, 0.28, 0.28, 0.29, 0.29, 0.29, 0.29, 0.29, 0.29, 0.29]
        }
    ]

    text: "System load"
    icons: style === "numbers" ? ["chip"] : []
    label: style === "numbers" && stats.length > 0 ? stats[0].value : ""

    // One meter for each resource. A meter stands, so that three fit in the width of one icon.
    Row {
        anchors.verticalCenter: parent.verticalCenter
        spacing: Metrics.space2 + 1
        visible: root.style === "meters"

        Repeater {
            model: root.stats

            Rectangle {
                required property var modelData

                width: 4
                height: 16
                radius: 2
                color: Theme.track

                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: Math.max(2, parent.height * parent.modelData.level)
                    radius: 2
                    color: Theme[parent.modelData.tone] ?? Theme.accent

                    Behavior on height {
                        TrailSpring {}
                    }
                }
            }
        }
    }

    Sparkline {
        anchors.verticalCenter: parent.verticalCenter
        width: 40
        height: 16
        visible: root.style === "traces" && root.stats.length > 0
        values: root.stats.length > 0 ? root.stats[0].history : []
        color: root.stats.length > 0 ? (Theme[root.stats[0].tone] ?? Theme.accent) : Theme.accent
    }
}
