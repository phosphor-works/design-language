// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls
import Phosphor.Design
import Phosphor.Storybook

// The parts that the shell surfaces use. They are the chip of the bar, the workspaces, the month,
// the header and the pages of a panel, and the small marks.
Story {
    Variant {
        name: "Bar chips: icons, a value, an unread item, an open panel"
        surface: true

        Row {
            spacing: Metrics.space4

            BarChip {
                text: "Quick settings"
                icons: ["wifi", "volume", "battery"]
            }
            BarChip {
                text: "System"
                icons: ["chip"]
                label: "28%"
            }
            BarChip {
                text: "Notifications"
                icons: ["bell"]
                alert: true
            }
            BarChip {
                text: "Calendar"
                label: "10:24"
                active: true
            }
            BarChip {
                id: mediaChip

                text: "Media"

                Bars {
                    anchors.verticalCenter: parent.verticalCenter
                    color: mediaChip.ink
                }
            }
        }
    }

    Variant {
        name: "Workspaces"
        surface: true

        WorkspaceStrip {
            count: 5
            current: 1
            occupied: [0, 1, 3]
            onPicked: index => current = index
        }
    }

    Variant {
        name: "Bars: playing, paused, real levels"
        surface: true

        Row {
            spacing: Metrics.gapSection

            Bars {}
            Bars {
                running: false
                color: Theme.muted
            }
            Bars {
                levels: [0.3, 1, 0.6, 0.15]
                color: Theme.purple
            }
        }
    }

    Variant {
        name: "Artwork: a picture, no picture, a small size"
        surface: true

        Row {
            spacing: Metrics.gapLoose

            Artwork {
                source: Qt.resolvedUrl("../../assets/cover-awake.jpg")
                asynchronous: !Session.capture
            }
            Artwork {
                tone: Theme.purple
            }
            Artwork {
                anchors.verticalCenter: parent.verticalCenter
                source: Qt.resolvedUrl("../../assets/cover-a-walk.jpg")
                asynchronous: !Session.capture
                size: 20
                radius: Metrics.radiusInner
            }
        }
    }

    Variant {
        name: "Visualizer: bars"
        surface: true

        Visualizer {
            animated: !Session.capture
        }
    }

    Variant {
        name: "Visualizer: ribbon"
        surface: true

        Visualizer {
            style: "ribbon"
            animated: !Session.capture
        }
    }

    Variant {
        name: "Visualizer: halo"
        surface: true

        Visualizer {
            width: 120
            height: 96
            style: "halo"
            count: 64
            animated: !Session.capture
        }
    }

    Variant {
        name: "Visualizer: paused, real levels"
        surface: true

        Row {
            spacing: Metrics.gapSection

            Visualizer {
                width: 110
                count: 16
                running: false
            }
            Visualizer {
                width: 110
                count: 8
                levels: [0.9, 0.7, 0.75, 0.4, 0.5, 0.3, 0.15, 0.1]
            }
        }
    }

    Variant {
        name: "Layout preview: three sizes of one layout"
        surface: true

        Row {
            id: layouts

            readonly property var windows: [
                {
                    "icon": "edit",
                    "x": 0,
                    "y": 0,
                    "w": 0.58,
                    "h": 1,
                    "focused": true
                },
                {
                    "icon": "globe",
                    "x": 0.58,
                    "y": 0,
                    "w": 0.42,
                    "h": 0.5
                },
                {
                    "icon": "terminal",
                    "x": 0.58,
                    "y": 0.5,
                    "w": 0.42,
                    "h": 0.5
                }
            ]

            spacing: Metrics.gapSection

            LayoutPreview {
                windows: layouts.windows
            }
            LayoutPreview {
                anchors.verticalCenter: parent.verticalCenter
                width: 64
                height: 40
                windows: layouts.windows
            }
            LayoutPreview {
                anchors.verticalCenter: parent.verticalCenter
                width: 28
                height: 18
                windowColor: Theme.text
                windows: layouts.windows
            }
        }
    }

    Variant {
        name: "Window frame: focused, not focused"

        Row {
            spacing: Metrics.gapLoose

            WindowFrame {
                width: 300
                height: 150
                icon: "globe"
                title: "Firefox"
                focused: true
            }
            WindowFrame {
                width: 300
                height: 150
                icon: "folder"
                title: "Files"
            }
        }
    }

    Variant {
        name: "Badges: a dot, a number, a large number"
        surface: true

        Row {
            spacing: Metrics.gapSection

            Badge {
                anchors.verticalCenter: parent.verticalCenter
            }
            Badge {
                anchors.verticalCenter: parent.verticalCenter
                count: 3
            }
            Badge {
                anchors.verticalCenter: parent.verticalCenter
                count: 128
            }
        }
    }

    Variant {
        name: "Avatars: a letter, an icon, a small size"
        surface: true

        Row {
            spacing: Metrics.gapLoose

            Avatar {
                name: "maya"
                tone: Theme.purple
            }
            Avatar {
                name: "Kate"
                icon: "edit"
                tone: Theme.cyan
            }
            Avatar {
                anchors.verticalCenter: parent.verticalCenter
                name: "Nextcloud"
                icon: "cloud"
                size: 28
            }
        }
    }

    Variant {
        name: "Month grid"
        surface: true

        MonthGrid {
            width: 7 * 38
            year: 2026
            month: 8
            today: new Date(2026, 8, 12)
            selected: new Date(2026, 8, 24)
            marked: [12, 17, 21]
            onPicked: date => selected = date
        }
    }

    Variant {
        name: "Panel header, with the control of the page"
        surface: true

        PanelHeader {
            width: 300
            text: "Wi-Fi"

            Switch {
                checked: true
            }
        }
    }

    Variant {
        name: "Panel header on a first page"
        surface: true

        PanelHeader {
            width: 300
            canGoBack: false
            text: "September 2026"

            IconButton {
                iconName: "chevronLeft"
                text: "Previous month"
            }
            IconButton {
                iconName: "chevronRight"
                text: "Next month"
            }
        }
    }

    Variant {
        name: "Panel pages: press a row, then press back"
        surface: true

        Item {
            id: pages

            property string page: "main"

            width: 300
            height: page === "main" ? main.implicitHeight : detail.implicitHeight
            clip: true

            Behavior on height {
                enabled: !Session.capture

                FlowSpring {}
            }

            PanelPage {
                id: main

                width: parent.width
                active: pages.page === "main"
                deeper: false

                ListRow {
                    icon: "wifi"
                    text: "Wi-Fi"
                    onClicked: pages.page = "detail"
                }
                ListRow {
                    icon: "bluetooth"
                    text: "Bluetooth"
                    onClicked: pages.page = "detail"
                }
            }

            PanelPage {
                id: detail

                width: parent.width
                active: pages.page === "detail"
                spacing: Metrics.gap

                PanelHeader {
                    width: parent.width
                    text: "Wi-Fi"
                    onBack: pages.page = "main"
                }
                ListRow {
                    icon: "wifi"
                    text: "Home network"
                    selected: true
                }
                ListRow {
                    icon: "wifi"
                    text: "Studio"
                    secure: true
                }
                ListRow {
                    icon: "wifi"
                    text: "Cafe guest"
                }
            }
        }
    }
}
