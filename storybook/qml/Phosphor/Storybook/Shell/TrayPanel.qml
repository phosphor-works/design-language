// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import Phosphor.Design

// The apps that run in the background. A press on an app shows its menu as a page of the same
// panel, and a submenu is one more page. No second popup opens next to the panel.
//
// A badge shows an app that needs the user. When there are more apps than the grid shows, the last
// cell opens the full grid. The menu of each app ends with the switch that puts the app in the bar.
// The panel has no title, no count line and no "arrange" link.
Item {
    id: root

    property string open // the app whose menu shows
    property string submenu // the entry of that menu whose entries show
    property bool expanded: false
    property int limit: 9 // the cells of the grid before the user opens it
    // Each app: { icon, name, attention, pinned, menu }. A menu entry is [icon, name], or
    // [icon, name, entries] for a submenu. An empty entry is a gap between two groups.
    property var apps: [
        {
            "icon": "cloud",
            "name": "Nextcloud",
            "attention": false,
            "pinned": true,
            "menu": [["folder", "Open sync folder"], ["pause", "Pause syncing", [["clock", "For one hour"], ["clock", "Until tomorrow"], ["pause", "Until I resume"]]], ["sync", "Sync now"], [], ["tune", "Settings"], ["power", "Quit"]]
        },
        {
            "icon": "phone",
            "name": "KDE Connect",
            "attention": true,
            "pinned": true,
            "menu": [["phone", "Ring phone"], ["send", "Send file"], [], ["power", "Quit"]]
        },
        {
            "icon": "record",
            "name": "OBS Studio",
            "attention": false,
            "pinned": false,
            "menu": [["record", "Start recording"], [], ["power", "Quit"]]
        },
        {
            "icon": "key",
            "name": "KeePassXC",
            "attention": false,
            "pinned": false,
            "menu": [["lock", "Lock database"], [], ["power", "Quit"]]
        },
        {
            "icon": "sync",
            "name": "Syncthing",
            "attention": false,
            "pinned": false,
            "menu": [["globe", "Open web interface"], ["pause", "Pause"], [], ["power", "Quit"]]
        },
        {
            "icon": "download",
            "name": "qBittorrent",
            "attention": false,
            "pinned": false,
            "menu": [["pause", "Pause all"], [], ["power", "Quit"]]
        }
    ]

    readonly property var _app: apps.find(app => app.name === open) ?? null
    readonly property var _parent: _app && submenu !== "" ? (_app.menu.find(entry => entry[1] === submenu) ?? null) : null
    readonly property int _columns: Math.min(3, Math.max(1, apps.length))
    readonly property real _cell: 92
    // The cells of the grid: the apps, or the first apps and one cell for the others.
    readonly property var _cells: expanded || apps.length <= limit ? apps : apps.slice(0, limit - 1).concat([
        {
            "more": apps.length - limit + 1
        }
    ])
    readonly property real _inner: width - 2 * Metrics.pad

    signal chosen(string app, string action)
    signal pinned(string app, bool pinned)

    width: Math.max(_columns * _cell + 2 * Metrics.pad, open !== "" ? 264 : 0)
    implicitHeight: submenu !== "" ? subPage.implicitHeight : open !== "" ? menuPage.implicitHeight : gridPage.implicitHeight
    clip: true

    component Entries: Column {
        id: list

        property var entries: []

        width: root._inner

        Repeater {
            model: list.entries

            Loader {
                id: entry

                required property var modelData

                width: list.width
                sourceComponent: modelData.length === 0 ? gap : action

                // An entry that opens a submenu shows where the press goes.
                Icon {
                    anchors.right: parent.right
                    anchors.rightMargin: Metrics.space10
                    anchors.verticalCenter: parent.verticalCenter
                    visible: entry.modelData.length > 2
                    name: "chevronRight"
                    size: Metrics.iconSmall
                    color: Theme.muted
                }

                Component {
                    id: gap

                    Item {
                        height: Metrics.space8
                    }
                }

                Component {
                    id: action

                    ListRow {
                        readonly property bool opens: entry.modelData.length > 2

                        icon: entry.modelData[0]
                        text: entry.modelData[1]
                        onClicked: {
                            if (opens) {
                                root.submenu = text;
                                return;
                            }
                            root.chosen(root.open, text);
                            root.submenu = "";
                            root.open = "";
                        }
                    }
                }
            }
        }
    }

    PanelPage {
        id: gridPage

        active: root.open === ""
        deeper: false
        width: root.width
        padding: Metrics.pad
        topPadding: Metrics.space8

        Grid {
            anchors.horizontalCenter: parent.horizontalCenter
            columns: root._columns
            visible: root.apps.length > 0

            Repeater {
                model: root._cells

                T.AbstractButton {
                    id: cell

                    required property var modelData
                    readonly property bool isMore: modelData.more !== undefined

                    width: root._cell
                    height: 76
                    scale: down ? Metrics.pressScale : 1
                    onClicked: {
                        if (isMore)
                            root.expanded = true;
                        else
                            root.open = modelData.name;
                    }

                    Accessible.name: isMore ? modelData.more + " more apps" : modelData.name

                    Behavior on scale {
                        SnapSpring {
                            epsilon: 0.002
                        }
                    }

                    contentItem: Item {
                        Icon {
                            id: glyph

                            anchors.horizontalCenter: parent.horizontalCenter
                            y: Metrics.space12
                            name: cell.isMore ? "chevronDown" : cell.modelData.icon
                            size: Metrics.iconLarge
                            color: cell.isMore ? Theme.muted : Theme.text
                        }

                        Badge {
                            anchors.left: glyph.right
                            anchors.leftMargin: -Metrics.space4
                            anchors.top: glyph.top
                            anchors.topMargin: -Metrics.space2
                            shown: cell.modelData.attention === true
                        }

                        Text {
                            anchors.top: glyph.bottom
                            anchors.topMargin: Metrics.space8
                            width: parent.width - Metrics.space8
                            x: Metrics.space4
                            horizontalAlignment: Text.AlignHCenter
                            text: cell.isMore ? cell.modelData.more + " more" : cell.modelData.name
                            elide: Text.ElideRight
                            color: Theme.muted
                            font.family: Metrics.fontUi
                            font.pixelSize: Metrics.textCaption
                            font.weight: Metrics.weightBody
                        }
                    }

                    background: Rectangle {
                        radius: Metrics.radiusCard
                        color: cell.hovered ? Theme.hover : "transparent"

                        Behavior on color {
                            Tint {}
                        }

                        FocusRing {
                            target: cell
                            around: parent.radius
                        }
                    }
                }
            }
        }

        // No app runs in the background.
        Item {
            width: root._inner
            height: Metrics.rowHeight
            visible: root.apps.length === 0

            Icon {
                anchors.centerIn: parent
                name: "tray"
                size: Metrics.iconLarge
                color: Theme.muted
                opacity: 0.5
            }
        }
    }

    PanelPage {
        id: menuPage

        active: root.open !== "" && root.submenu === ""
        // When a submenu opens, this page goes to the left.
        deeper: root.submenu === ""
        width: root.width
        padding: Metrics.pad
        topPadding: Metrics.space8
        spacing: Metrics.space4

        PanelHeader {
            width: root._inner
            text: root._app ? root._app.name : ""
            onBack: root.open = ""
        }

        Entries {
            entries: root._app ? root._app.menu : []
        }

        Item {
            width: root._inner
            height: Metrics.space8
        }

        SettingRow {
            width: root._inner
            text: "Show in the bar"

            Switch {
                checked: root._app ? root._app.pinned : false
                onToggled: root.pinned(root.open, checked)
            }
        }
    }

    PanelPage {
        id: subPage

        active: root.submenu !== ""
        width: root.width
        padding: Metrics.pad
        topPadding: Metrics.space8
        spacing: Metrics.space4

        PanelHeader {
            width: root._inner
            text: root.submenu
            onBack: root.submenu = ""
        }

        Entries {
            entries: root._parent ? root._parent[2] : []
        }
    }
}
