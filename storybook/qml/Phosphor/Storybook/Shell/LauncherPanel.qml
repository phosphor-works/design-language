// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import Phosphor.Design

// The launcher: one field, and the apps that match it. The panel has no title, no categories and no
// hint line. The list becomes shorter while the user types, and the panel follows it.
Column {
    id: root

    property alias query: field.text
    property int index: 0
    property var apps: [
        {
            "icon": "terminal",
            "name": "Afterglow"
        },
        {
            "icon": "globe",
            "name": "Firefox"
        },
        {
            "icon": "folder",
            "name": "Files"
        },
        {
            "icon": "edit",
            "name": "Kate"
        },
        {
            "icon": "tune",
            "name": "Facet"
        },
        {
            "icon": "zones",
            "name": "Layout editor"
        },
        {
            "icon": "music",
            "name": "Music"
        },
        {
            "icon": "chat",
            "name": "Messages"
        }
    ]
    readonly property var matches: {
        const wanted = query.trim().toLowerCase();
        return apps.filter(app => app.name.toLowerCase().includes(wanted)).slice(0, 6);
    }

    signal launched(string name)

    function takeFocus() {
        field.forceActiveFocus();
    }

    width: 430
    padding: Metrics.pad
    topPadding: Metrics.space8
    spacing: Metrics.gap

    TextField {
        id: field

        width: root.width - 2 * Metrics.pad
        leftPadding: Metrics.space12 + Metrics.iconSize + Metrics.iconGap
        placeholderText: "Search"
        onTextEdited: root.index = 0

        Keys.onDownPressed: root.index = Math.min(root.index + 1, root.matches.length - 1)
        Keys.onUpPressed: root.index = Math.max(root.index - 1, 0)
        Keys.onReturnPressed: if (root.matches.length > 0)
            root.launched(root.matches[root.index].name)

        Icon {
            x: Metrics.space12
            anchors.verticalCenter: parent.verticalCenter
            name: "search"
            color: field.activeFocus ? Theme.focus : Theme.muted

            Behavior on color {
                Tint {}
            }
        }
    }

    Column {
        width: field.width

        Repeater {
            model: root.matches

            ListRow {
                required property var modelData
                required property int index

                icon: modelData.icon
                text: modelData.name
                highlighted: index === root.index
                onClicked: root.launched(modelData.name)
            }
        }
    }

    // No app matches. The list is empty, and a dim icon shows that the search found nothing.
    Item {
        width: field.width
        height: Metrics.rowHeight
        visible: root.matches.length === 0

        Icon {
            anchors.centerIn: parent
            name: "search"
            size: Metrics.iconLarge
            color: Theme.muted
            opacity: 0.5
        }
    }
}
