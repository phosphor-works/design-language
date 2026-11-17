// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import Phosphor.Storybook

Story {
    Variant {
        name: "Actions, a check and a submenu"
        surface: true

        Column {
            width: 220

            MenuItem {
                width: parent.width
                text: "Library"
            }
            MenuItem {
                width: parent.width
                text: "Friends"
            }
            MenuItem {
                width: parent.width
                text: "Mute notifications"
                checkable: true
                checked: true
            }
            MenuSeparator {
                width: parent.width
            }
            MenuItem {
                width: parent.width
                text: "Quit"
            }
        }
    }

    Variant {
        name: "Opens from its button"

        Button {
            text: "Steam"
            onClicked: menu.open()

            Menu {
                id: menu

                y: parent.height + 6

                MenuItem {
                    text: "Library"
                }
                MenuItem {
                    text: "Store"
                }
                Menu {
                    title: "Status"

                    MenuItem {
                        text: "Online"
                        checkable: true
                        checked: true
                    }
                    MenuItem {
                        text: "Away"
                        checkable: true
                    }
                }
                MenuItem {
                    text: "Quit"
                }
            }
        }
    }
}
