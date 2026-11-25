// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls
import Phosphor.Design

// The notifications that the user did not dismiss. A card that the user dismisses goes away, and
// the panel becomes shorter. When there are no cards, a dim bell is the full content. The panel has
// no title and no count line.
Column {
    id: root

    // Each item: { icon, tone, title, body, time, count, picture }.
    property var items: [
        {
            "icon": "chat",
            "tone": "purple",
            "title": "Maya",
            "body": "Left notes on the lock screen spacing",
            "time": "2m",
            "count": 3
        },
        {
            "icon": "image",
            "tone": "blue",
            "title": "Screenshot",
            "body": "Saved to Pictures",
            "time": "18m",
            "picture": Qt.resolvedUrl("../../../../assets/cover-a-walk.jpg")
        },
        {
            "icon": "disk",
            "tone": "rose",
            "title": "Backup",
            "body": "Archive drive disconnected. Reconnect it to finish the backup that started at 14:02.",
            "time": "1h"
        }
    ]
    property bool quiet: false
    readonly property int count: items.length

    width: 344
    padding: Metrics.pad
    topPadding: Metrics.space8
    spacing: Metrics.gap

    Repeater {
        model: root.items

        NotificationCard {
            required property var modelData
            required property int index

            width: root.width - 2 * Metrics.pad
            icon: modelData.icon
            tone: Theme[modelData.tone] ?? Theme.accent
            title: modelData.title
            body: modelData.body
            time: modelData.time
            count: modelData.count ?? 1
            picture: modelData.picture ?? ""
            onPressed: expanded = !expanded
            onDismissed: root.items = root.items.filter((item, at) => at !== index)
        }
    }

    Button {
        anchors.right: parent.right
        anchors.rightMargin: Metrics.pad
        flat: true
        text: "Clear"
        visible: root.count > 0
        onClicked: root.items = []
    }

    Item {
        width: root.width - 2 * Metrics.pad
        height: Metrics.rowHeight + Metrics.space16
        visible: root.count === 0

        Icon {
            anchors.centerIn: parent
            name: root.quiet ? "bellOff" : "bell"
            size: Metrics.iconLarge
            color: Theme.muted
            opacity: 0.5
        }
    }
}
