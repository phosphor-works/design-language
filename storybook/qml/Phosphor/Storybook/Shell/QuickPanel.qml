// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls
import Phosphor.Design

// The quick settings, with the pages for Wi-Fi, Bluetooth and sound.
//
// A detail page is a page of the same panel. It comes in from the right, and the panel changes size
// to fit it. A page has one header with its name and its main control. It has no line above the
// name and no sentence that explains the page.
Item {
    id: root

    property string page: "main" // main, wifi, bluetooth, sound

    property bool wifiOn: true
    property string network: "Home network"
    property string connecting // the network that connects at this time
    property string asking // the network that asks for its password
    property var networks: [
        {
            "name": "Home network",
            "strength": 1,
            "secure": true
        },
        {
            "name": "Studio",
            "strength": 0.75,
            "secure": true
        },
        {
            "name": "Cafe guest",
            "strength": 0.5,
            "secure": false
        },
        {
            "name": "Printer 4F",
            "strength": 0.3,
            "secure": true
        }
    ]

    property bool bluetoothOn: true
    property string pairing // the device that pairs at this time
    property string pairingCode: "482913"
    property var devices: [
        {
            "name": "Buds",
            "icon": "headphones",
            "battery": 80,
            "connected": true
        },
        {
            "name": "Keyboard",
            "icon": "keyboard",
            "battery": 55,
            "connected": true
        },
        {
            "name": "Mouse",
            "icon": "mouse",
            "battery": 0,
            "connected": false
        },
        {
            "name": "Phone",
            "icon": "phone",
            "battery": 0,
            "connected": false
        }
    ]

    property string soundTab: "output" // output, input, apps
    property string output: "Buds"
    property string input: "Webcam microphone"
    property real inputLevel: 0.42

    property alias volume: volumeSlider.value
    property alias brightness: brightnessSlider.value
    property alias quiet: quietTile.checked
    property alias nightLight: nightTile.checked

    readonly property real _inner: width - 2 * Metrics.pad
    readonly property Item _current: page === "wifi" ? wifiPage : page === "bluetooth" ? bluetoothPage : page === "sound" ? soundPage : mainPage

    width: 400
    implicitHeight: _current.implicitHeight
    clip: true

    component Page: PanelPage {
        width: root.width
        padding: Metrics.pad
        topPadding: Metrics.space8
        spacing: Metrics.gap
    }

    // The content of a page when its radio or its list is off.
    component Off: Item {
        property string icon

        width: root._inner
        height: Metrics.rowHeight

        Icon {
            anchors.centerIn: parent
            name: parent.icon
            size: Metrics.iconLarge
            color: Theme.muted
            opacity: 0.5
        }
    }

    Page {
        id: mainPage

        active: root.page === "main"
        deeper: false

        Grid {
            columns: 2
            spacing: Metrics.gap

            Tile {
                width: (root._inner - Metrics.gap) / 2
                icon: root.wifiOn ? "wifi" : "wifiOff"
                text: root.wifiOn && root.network !== "" ? root.network : "Wi-Fi"
                checked: root.wifiOn
                hasMore: true
                moreLabel: "Networks"
                onToggled: root.wifiOn = !root.wifiOn
                onMoreClicked: root.page = "wifi"
            }
            Tile {
                width: (root._inner - Metrics.gap) / 2
                icon: "bluetooth"
                text: root.bluetoothOn ? root.devices[0].name : "Bluetooth"
                checked: root.bluetoothOn
                hasMore: true
                moreLabel: "Devices"
                onToggled: root.bluetoothOn = !root.bluetoothOn
                onMoreClicked: root.page = "bluetooth"
            }
            Tile {
                id: quietTile

                width: (root._inner - Metrics.gap) / 2
                icon: "moon"
                text: "Do not disturb"
                onToggled: checked = !checked
            }
            Tile {
                id: nightTile

                width: (root._inner - Metrics.gap) / 2
                icon: "bulb"
                text: "Night light"
                onToggled: checked = !checked
            }
        }

        Row {
            spacing: Metrics.space4

            BigSlider {
                id: volumeSlider

                width: root._inner - soundMore.width - parent.spacing
                iconName: value === 0 ? "volumeMute" : value < 0.5 ? "volumeLow" : "volume"
                value: 0.62

                Accessible.name: "Volume"
            }
            IconButton {
                id: soundMore

                anchors.verticalCenter: parent.verticalCenter
                iconName: "chevronRight"
                text: "Sound"
                onClicked: root.page = "sound"
            }
        }

        BigSlider {
            id: brightnessSlider

            width: volumeSlider.width
            iconName: "sun"
            value: 0.8

            Accessible.name: "Brightness"
        }
    }

    Page {
        id: wifiPage

        active: root.page === "wifi"

        PanelHeader {
            width: root._inner
            text: "Wi-Fi"
            onBack: root.page = "main"

            Switch {
                checked: root.wifiOn
                onToggled: root.wifiOn = checked

                Accessible.name: "Wi-Fi"
            }
        }

        Column {
            width: root._inner
            visible: root.wifiOn

            Repeater {
                model: root.networks

                ListRow {
                    id: net

                    required property var modelData

                    icon: "wifi"
                    iconOpacity: 0.3 + 0.7 * modelData.strength
                    text: modelData.name
                    secure: modelData.secure && modelData.name !== root.network
                    selected: modelData.name === root.network
                    busy: modelData.name === root.connecting
                    onClicked: {
                        if (selected)
                            return;
                        if (modelData.secure)
                            root.asking = root.asking === modelData.name ? "" : modelData.name;
                        else
                            root.connecting = modelData.name;
                    }

                    // The password field opens inside the row of its network.
                    Row {
                        x: Metrics.padRow
                        height: visible ? implicitHeight + Metrics.space8 : 0
                        spacing: Metrics.space8
                        visible: net.modelData.name === root.asking

                        TextField {
                            id: password

                            width: root._inner - 2 * Metrics.padRow - join.width - parent.spacing
                            anchors.verticalCenter: parent.verticalCenter
                            placeholderText: "Password"
                            echoMode: TextInput.Password
                            onAccepted: join.clicked()
                        }
                        Button {
                            id: join

                            anchors.verticalCenter: parent.verticalCenter
                            highlighted: true
                            text: "Join"
                            enabled: password.length >= 8
                            onClicked: {
                                root.connecting = net.modelData.name;
                                root.asking = "";
                            }
                        }
                    }
                }
            }
        }

        Off {
            icon: "wifiOff"
            visible: !root.wifiOn
        }
    }

    Page {
        id: bluetoothPage

        active: root.page === "bluetooth"

        PanelHeader {
            width: root._inner
            text: "Bluetooth"
            onBack: root.page = "main"

            Switch {
                checked: root.bluetoothOn
                onToggled: root.bluetoothOn = checked

                Accessible.name: "Bluetooth"
            }
        }

        Column {
            width: root._inner
            visible: root.bluetoothOn

            Repeater {
                model: root.devices

                ListRow {
                    id: device

                    required property var modelData

                    icon: modelData.icon
                    text: modelData.name
                    value: modelData.battery > 0 ? modelData.battery + "%" : ""
                    selected: modelData.connected
                    busy: modelData.name === root.pairing
                    onClicked: if (!modelData.connected)
                        root.pairing = root.pairing === modelData.name ? "" : modelData.name

                    // The code to compare with the code on the device.
                    Row {
                        x: Metrics.padRow
                        height: visible ? implicitHeight + Metrics.space8 : 0
                        spacing: Metrics.space4
                        visible: device.modelData.name === root.pairing

                        Repeater {
                            model: root.pairingCode.split("")

                            Keycap {
                                required property string modelData

                                anchors.verticalCenter: parent.verticalCenter
                                text: modelData
                            }
                        }

                        Item {
                            width: Metrics.space8
                            height: 1
                        }

                        Button {
                            highlighted: true
                            text: "Pair"
                            onClicked: root.pairing = ""
                        }
                    }
                }
            }
        }

        Off {
            icon: "bluetooth"
            visible: !root.bluetoothOn
        }
    }

    Page {
        id: soundPage

        active: root.page === "sound"

        PanelHeader {
            width: root._inner
            text: "Sound"
            onBack: root.page = "main"
        }

        Segmented {
            label: "Sound"
            options: [
                {
                    "value": "output",
                    "text": "Output"
                },
                {
                    "value": "input",
                    "text": "Input"
                },
                {
                    "value": "apps",
                    "text": "Apps"
                }
            ]
            value: root.soundTab
            onPicked: value => root.soundTab = value
        }

        Column {
            width: root._inner
            visible: root.soundTab === "output"

            Repeater {
                model: [["headphones", "Buds"], ["screen", "Display"], ["volume", "Speakers"]]

                ListRow {
                    required property var modelData

                    icon: modelData[0]
                    text: modelData[1]
                    selected: modelData[1] === root.output
                    onClicked: root.output = modelData[1]
                }
            }
        }

        Column {
            width: root._inner
            spacing: Metrics.gap
            visible: root.soundTab === "input"

            Column {
                width: parent.width

                Repeater {
                    model: ["Webcam microphone", "Buds"]

                    ListRow {
                        required property string modelData

                        icon: "microphone"
                        text: modelData
                        selected: modelData === root.input
                        onClicked: root.input = modelData
                    }
                }
            }

            // The level of the input at this time.
            Meter {
                x: Metrics.padRow
                width: parent.width - 2 * Metrics.padRow
                value: root.inputLevel
                color: Theme.success
            }
        }

        Column {
            width: root._inner
            spacing: Metrics.gap
            visible: root.soundTab === "apps"

            Repeater {
                model: [["music", "Music", 0.84], ["globe", "Firefox", 0.45], ["chat", "Messages", 0.6]]

                BigSlider {
                    required property var modelData

                    width: root._inner
                    iconName: modelData[0]
                    label: modelData[1]
                    value: modelData[2]
                }
            }
        }
    }
}
