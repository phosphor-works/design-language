// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import Phosphor.Design

// The bar and its drawer as one shape. Press a chip, and the drawer opens from it. Press a
// different chip while the drawer is open, and the same drawer moves and changes size.
//
// The panels here use library components, so that the shell body has real content. They are
// compositions for this story, and not components.
Item {
    id: scene

    property bool fill: true
    // In a capture, no user presses a chip, so the story opens the quick settings.
    property string panel: Session.capture ? "quick" : ""

    readonly property var _panels: ({
            "quick": [statusChip, quick],
            "inbox": [bellChip, inbox],
            "power": [powerChip, power]
        })

    function toggle(name: string) {
        panel = panel === name ? "" : name;
    }

    component Chip: T.AbstractButton {
        id: chip

        property string panelName
        default property alias glyphs: glyphRow.data

        width: glyphRow.width + 18
        height: Metrics.barHeight - 12
        anchors.verticalCenter: parent ? parent.verticalCenter : undefined
        scale: down ? 0.94 : 1
        onClicked: scene.toggle(panelName)

        Behavior on scale {
            SnapSpring {
                epsilon: 0.002
            }
        }

        contentItem: Item {
            Row {
                id: glyphRow

                anchors.centerIn: parent
                spacing: 10
            }
        }

        background: Rectangle {
            radius: Metrics.radiusControl
            color: chip.hovered ? Theme.hover : "transparent"

            Behavior on color {
                Tint {}
            }

            FocusRing {
                target: chip
            }
        }
    }

    component ChipIcon: Icon {
        property string panelName

        color: scene.panel === panelName && panelName !== "" ? Theme.accent : Theme.text

        Behavior on color {
            Tint {}
        }
    }

    // A wallpaper: a brand color on the desktop ground.
    Rectangle {
        anchors.fill: parent
        color: Theme.desktop

        Rectangle {
            x: parent.width * 0.5
            y: -parent.height * 0.2
            width: parent.width * 0.7
            height: width
            radius: width / 2
            opacity: 0.16
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: Theme.blue
                }
                GradientStop {
                    position: 1
                    color: "transparent"
                }
            }
        }

        TapHandler {
            onTapped: scene.panel = ""
        }
    }

    ShellBody {
        id: body

        readonly property var active: scene._panels[scene.panel] ?? null
        // The drawer keeps the size of its last panel while it closes.
        property Item shown: null

        anchors.fill: parent
        fused: fusedChoice.value === "fused"
        open: active !== null
        source: active ? active[0] : (shown ? scene._panels[shown.objectName][0] : statusChip)
        contentWidth: shown ? shown.width : 0
        contentHeight: shown ? shown.implicitHeight : 0
        onActiveChanged: if (active)
            shown = active[1]

        barContent: [
            Row {
                x: 8
                height: parent.height
                spacing: 4

                Chip {
                    ChipIcon {
                        name: "phosphor"
                        size: 20
                        color: Theme.cyan
                    }
                }
            },
            Text {
                anchors.centerIn: parent
                text: Qt.formatTime(new Date(), "HH:mm")
                color: Theme.text
                font.family: Metrics.fontUi
                font.pixelSize: Metrics.textBody
                font.weight: Metrics.weightStrong
            },
            Row {
                anchors.right: parent.right
                anchors.rightMargin: 8
                height: parent.height
                spacing: 4

                Chip {
                    id: statusChip

                    panelName: "quick"
                    Accessible.name: "Quick settings"

                    ChipIcon {
                        name: wifi.checked ? "wifi" : "wifiOff"
                        panelName: "quick"
                    }
                    ChipIcon {
                        name: volume.value === 0 ? "volumeMute" : volume.value < 0.5 ? "volumeLow" : "volume"
                        panelName: "quick"
                    }
                    ChipIcon {
                        name: "battery"
                        panelName: "quick"
                    }
                }

                Chip {
                    id: bellChip

                    panelName: "inbox"
                    Accessible.name: "Notifications"

                    ChipIcon {
                        name: quiet.checked ? "bellOff" : "bell"
                        panelName: "inbox"
                    }
                }

                Chip {
                    id: powerChip

                    panelName: "power"
                    Accessible.name: "Power"

                    ChipIcon {
                        name: "power"
                        panelName: "power"
                    }
                }
            }
        ]

        Column {
            id: quick

            objectName: "quick"
            width: 400
            padding: Metrics.pad
            topPadding: 8
            spacing: Metrics.gap
            opacity: body.shown === quick && body.open ? 1 : 0
            visible: opacity > 0

            Behavior on opacity {
                Fade {}
            }

            Grid {
                columns: 2
                spacing: Metrics.gap

                Tile {
                    id: wifi

                    width: (quick.width - 2 * Metrics.pad - Metrics.gap) / 2
                    icon: checked ? "wifi" : "wifiOff"
                    text: checked ? "Home network" : "Wi-Fi"
                    checked: true
                    hasMore: true
                    moreLabel: "Networks"
                    onToggled: checked = !checked
                }
                Tile {
                    width: wifi.width
                    icon: "bluetooth"
                    text: checked ? "Buds" : "Bluetooth"
                    checked: true
                    hasMore: true
                    moreLabel: "Devices"
                    onToggled: checked = !checked
                }
                Tile {
                    id: quiet

                    width: wifi.width
                    icon: "moon"
                    text: "Do not disturb"
                    onToggled: checked = !checked
                }
                Tile {
                    width: wifi.width
                    icon: "bulb"
                    text: "Night light"
                    onToggled: checked = !checked
                }
            }

            BigSlider {
                id: volume

                width: quick.width - 2 * Metrics.pad
                iconName: value === 0 ? "volumeMute" : value < 0.5 ? "volumeLow" : "volume"
                label: ""
                value: 0.62

                Accessible.name: "Volume"
            }

            BigSlider {
                width: volume.width
                iconName: "sun"
                label: ""
                value: 0.8

                Accessible.name: "Brightness"
            }
        }

        Column {
            id: inbox

            objectName: "inbox"
            width: 344
            padding: Metrics.pad
            topPadding: 8
            spacing: Metrics.gap
            opacity: body.shown === inbox && body.open ? 1 : 0
            visible: opacity > 0

            Behavior on opacity {
                Fade {}
            }

            NotificationCard {
                width: inbox.width - 2 * Metrics.pad
                icon: "chat"
                tone: Theme.purple
                title: "Maya"
                body: "Left notes on the lock screen spacing"
                time: "2m"
                count: 3
                onPressed: expanded = !expanded
                onDismissed: visible = false
            }
            NotificationCard {
                width: inbox.width - 2 * Metrics.pad
                icon: "image"
                tone: Theme.blue
                title: "Screenshot"
                body: "Saved to Pictures"
                time: "18m"
                picture: true
                onPressed: expanded = !expanded
                onDismissed: visible = false
            }
            NotificationCard {
                width: inbox.width - 2 * Metrics.pad
                icon: "lock"
                tone: Theme.danger
                title: "Backup"
                body: "Archive drive disconnected. Reconnect it to finish the backup that started at 14:02."
                time: "1h"
                onPressed: expanded = !expanded
                onDismissed: visible = false
            }
        }

        Column {
            id: power

            objectName: "power"
            width: 190
            padding: 8
            topPadding: 6
            opacity: body.shown === power && body.open ? 1 : 0
            visible: opacity > 0

            Behavior on opacity {
                Fade {}
            }

            Repeater {
                model: [["lock", "Lock"], ["sleep", "Sleep"], ["logout", "Log out"], ["restart", "Restart"], ["power", "Shut down"]]

                ListRow {
                    required property var modelData

                    width: power.width - 16
                    icon: modelData[0]
                    text: modelData[1]
                    onClicked: scene.panel = ""
                }
            }
        }
    }

    Segmented {
        id: fusedChoice

        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 20
        label: "Panels"
        options: [
            {
                "value": "fused",
                "text": "Fused"
            },
            {
                "value": "detached",
                "text": "Detached"
            }
        ]
        value: "fused"
    }
}
