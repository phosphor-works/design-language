// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import Phosphor.Design

// The lock screen: the time, the date, the account and one field.
//
// There are two layouts. `centered` puts the time above the field. `split` puts the time at the
// left and the field at the right, for a wide screen. The screen can show the track that plays and
// the senders of the notifications. It does not show the text of a notification.
//
// The screen shows states with icons and values: the battery level, the keyboard layout, the number
// of notifications. It does not tell the user that the session is locked, and it has no greeting
// and no key hints. A wrong password makes the field rose and moves it.
Item {
    id: root

    property date now: new Date()
    property string user: "maya"
    property string phase: "idle" // idle, checking, error
    property string layout: "centered" // centered, split
    property int notifications: 3
    // The senders to show: { icon, tone, title }. Empty shows only the number.
    property var senders: []
    // The track that plays: { title, artist, art, playing }. Null shows no media.
    property var media: null
    property int battery: 82
    property string keyboard: "US"
    property bool capsLock: false

    signal accepted(string password)
    signal mediaToggled

    readonly property bool _split: layout === "split"
    property real _shake: 0
    property bool _jump: false

    implicitWidth: 960
    implicitHeight: 600
    clip: true

    onPhaseChanged: if (phase === "error") {
        _jump = true;
        _shake = Metrics.space12;
        _jump = false;
        _shake = 0;
        field.selectAll();
    }

    Behavior on _shake {
        enabled: !root._jump

        SpringAnimation {
            spring: Motion.springFor(Motion.snapOmega, 0.25)
            damping: Motion.dampingFor(Motion.snapOmega, 0.25)
            epsilon: 0.05
        }
    }

    // The wallpaper of the lock screen: two brand colors on the desktop ground.
    Rectangle {
        anchors.fill: parent
        color: Theme.desktop
    }

    component Light: ShapePath {
        id: light

        property real cx: 0
        property real cy: 0
        property real reach: 0
        property color tone: Theme.accent

        strokeColor: "transparent"
        fillGradient: RadialGradient {
            centerX: light.cx
            centerY: light.cy
            centerRadius: light.reach
            focalX: light.cx
            focalY: light.cy

            GradientStop {
                position: 0
                color: Theme.tint(light.tone, 0.2)
            }
            GradientStop {
                position: 1
                color: Theme.tint(light.tone, 0)
            }
        }

        PathSvg {
            path: `M0 0H${root.width}V${root.height}H0Z`
        }
    }

    Shape {
        anchors.fill: parent

        Light {
            cx: root.width * 0.3
            cy: root.height * 0.35
            reach: root.height * 0.75
            tone: Theme.cyan
        }
        Light {
            cx: root.width * 0.8
            cy: root.height * 0.75
            reach: root.height * 0.8
            tone: Theme.purple
        }
    }

    Column {
        id: clock

        x: root._split ? root.width * 0.12 : (root.width - width) / 2
        y: root._split ? (root.height - height) / 2 : root.height / 2 - height - Metrics.space16
        spacing: Metrics.space8

        Text {
            anchors.horizontalCenter: root._split ? undefined : parent.horizontalCenter
            text: Qt.formatTime(root.now, "HH:mm")
            color: Theme.text
            font.family: Metrics.fontUi
            font.pixelSize: Metrics.textDisplay
            font.weight: Metrics.weightBody
            font.features: {
                "tnum": 1
            }
        }

        Text {
            anchors.horizontalCenter: root._split ? undefined : parent.horizontalCenter
            text: root.now.toLocaleDateString(Qt.locale(), "dddd, d MMMM")
            color: Theme.muted
            font.family: Metrics.fontUi
            font.pixelSize: Metrics.textHeading
            font.weight: Metrics.weightBody
        }
    }

    Column {
        id: account

        x: root._split ? root.width * 0.88 - width : (root.width - width) / 2
        y: root._split ? (root.height - height) / 2 : root.height / 2 + Metrics.space16
        spacing: Metrics.gapLoose

        Row {
            spacing: Metrics.gap

            Avatar {
                name: root.user
                size: Metrics.fieldHeight
                tone: Theme.purple
            }

            TextField {
                id: field

                width: 260
                placeholderText: "Password for " + root.user
                echoMode: TextInput.Password
                enabled: root.phase !== "checking"
                rightPadding: Metrics.space12 + Metrics.iconSize + Metrics.space8
                onAccepted: root.accepted(text)

                transform: Translate {
                    x: root._shake
                }

                Rectangle {
                    anchors.fill: parent
                    radius: Metrics.radiusControl + 2
                    color: "transparent"
                    border.width: Metrics.focusWidth
                    border.color: Theme.danger
                    opacity: root.phase === "error" ? 1 : 0

                    Behavior on opacity {
                        Fade {}
                    }
                }

                // Caps Lock changes what the user types, so the field shows it.
                Icon {
                    anchors.right: parent.right
                    anchors.rightMargin: Metrics.space12
                    anchors.verticalCenter: parent.verticalCenter
                    name: "capsLock"
                    color: Theme.warning
                    visible: root.capsLock && root.phase !== "checking"
                }
                Spinner {
                    anchors.right: parent.right
                    anchors.rightMargin: Metrics.space12
                    anchors.verticalCenter: parent.verticalCenter
                    visible: root.phase === "checking"
                }
            }
        }

        // The track that plays, with one button. The user can stop the sound and not unlock.
        Row {
            spacing: Metrics.gap
            visible: root.media !== null

            Artwork {
                id: cover

                size: Metrics.fieldHeight
                source: root.media ? root.media.art : ""
                asynchronous: !Session.capture
            }
            Column {
                anchors.verticalCenter: parent.verticalCenter
                width: 260 - toggle.width - parent.spacing

                Text {
                    width: parent.width
                    text: root.media ? root.media.title : ""
                    elide: Text.ElideRight
                    color: Theme.text
                    font.family: Metrics.fontUi
                    font.pixelSize: Metrics.textBody
                    font.weight: Metrics.weightStrong
                }
                Text {
                    width: parent.width
                    text: root.media ? root.media.artist : ""
                    elide: Text.ElideRight
                    color: Theme.muted
                    font.family: Metrics.fontUi
                    font.pixelSize: Metrics.textLabel
                    font.weight: Metrics.weightBody
                }
            }
            IconButton {
                id: toggle

                anchors.verticalCenter: parent.verticalCenter
                iconName: root.media && root.media.playing ? "pause" : "play"
                text: root.media && root.media.playing ? "Pause" : "Play"
                onClicked: root.mediaToggled()
            }
        }
    }

    Column {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: Metrics.pageMargin
        spacing: Metrics.gap
        visible: root.notifications > 0

        // The senders, without the text of their messages.
        Repeater {
            model: root.senders

            Row {
                required property var modelData

                spacing: Metrics.space8

                Avatar {
                    icon: modelData.icon
                    name: modelData.title
                    tone: Theme[modelData.tone] ?? Theme.accent
                    size: 24
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: modelData.title
                    color: Theme.text
                    font.family: Metrics.fontUi
                    font.pixelSize: Metrics.textBody
                    font.weight: Metrics.weightBody
                }
            }
        }

        Row {
            spacing: Metrics.space8

            Icon {
                anchors.verticalCenter: parent.verticalCenter
                name: "bell"
                color: Theme.muted
            }
            Badge {
                anchors.verticalCenter: parent.verticalCenter
                count: root.notifications
            }
        }
    }

    Row {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: Metrics.pageMargin
        spacing: Metrics.gapSection

        Repeater {
            model: [["keyboard", root.keyboard], ["battery", root.battery + "%"]]

            Row {
                required property var modelData
                // A battery that is almost empty is an error state.
                readonly property bool low: modelData[0] === "battery" && root.battery < 15

                anchors.verticalCenter: parent.verticalCenter
                spacing: Metrics.space8

                Icon {
                    anchors.verticalCenter: parent.verticalCenter
                    name: modelData[0]
                    color: parent.low ? Theme.danger : Theme.muted
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: modelData[1]
                    color: Theme.muted
                    font.family: Metrics.fontMono
                    font.pixelSize: Metrics.textLabel
                }
            }
        }

        IconButton {
            anchors.verticalCenter: parent.verticalCenter
            iconName: "power"
            text: "Power"
        }
    }
}
