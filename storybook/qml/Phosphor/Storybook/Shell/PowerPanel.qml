// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls
import Phosphor.Design

// The session actions. An action that stops work asks one time: its row opens and shows one
// button. The panel shows no question and no warning sentence.
Column {
    id: root

    property string asking // the action that waits for a second press
    property var actions: [
        {
            "icon": "lock",
            "name": "Lock",
            "confirm": false
        },
        {
            "icon": "sleep",
            "name": "Sleep",
            "confirm": false
        },
        {
            "icon": "logout",
            "name": "Log out",
            "confirm": true
        },
        {
            "icon": "restart",
            "name": "Restart",
            "confirm": true
        },
        {
            "icon": "power",
            "name": "Shut down",
            "confirm": true
        }
    ]

    signal chosen(string name)

    width: 200
    padding: Metrics.space8
    topPadding: Metrics.space6

    Repeater {
        model: root.actions

        ListRow {
            id: action

            required property var modelData

            width: root.width - 2 * Metrics.space8
            icon: modelData.icon
            text: modelData.name
            highlighted: modelData.name === root.asking
            onClicked: {
                if (!modelData.confirm)
                    root.chosen(modelData.name);
                else
                    root.asking = root.asking === modelData.name ? "" : modelData.name;
            }

            Item {
                width: action.width
                height: visible ? confirm.height + Metrics.space8 : 0
                visible: action.modelData.name === root.asking

                Button {
                    id: confirm

                    x: Metrics.padRow
                    width: parent.width - 2 * Metrics.padRow
                    highlighted: true
                    text: action.modelData.name
                    onClicked: root.chosen(action.modelData.name)
                }
            }
        }
    }
}
