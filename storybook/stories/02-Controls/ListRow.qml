// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls
import Phosphor.Design
import Phosphor.Storybook

Story {
    Variant {
        name: "Networks"
        surface: true

        Column {
            width: 340

            ListRow {
                icon: "wifi"
                text: "Home network"
                secure: true
                selected: true
            }
            ListRow {
                icon: "wifi"
                iconOpacity: 0.85
                text: "Studio 5G"
                secure: true
            }
            ListRow {
                icon: "wifi"
                iconOpacity: 0.6
                text: "Guest"
            }
        }
    }

    Variant {
        name: "Connecting"
        surface: true

        Column {
            width: 340

            ListRow {
                icon: "wifi"
                text: "Workshop"
                secure: true
                busy: true
            }
        }
    }

    Variant {
        name: "Asking for a password"
        surface: true

        Column {
            width: 340

            ListRow {
                icon: "wifi"
                text: "Studio 5G"
                secure: true

                Row {
                    x: 10
                    width: parent.width - 20
                    bottomPadding: 10
                    spacing: 8

                    TextField {
                        width: parent.width - connect.width - 8
                        implicitHeight: 34
                        echoMode: TextInput.Password
                        placeholderText: "Password"
                    }
                    Button {
                        id: connect

                        height: 34
                        text: "Connect"
                        highlighted: true
                    }
                }
            }
        }
    }

    Variant {
        name: "Devices"
        surface: true

        Column {
            width: 340

            ListRow {
                icon: "headphones"
                text: "Buds"
                value: "80%"
                selected: true
            }
            ListRow {
                icon: "keyboard"
                text: "Keychron K3"
            }
            ListRow {
                icon: "mouse"
                text: "MX Master"
            }
        }
    }
}
