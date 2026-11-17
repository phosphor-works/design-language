// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick

// One notification: the sender, the message and the time. A press opens the card. An open card
// shows the full text, a larger picture and the actions that the owner put inside.
//
// With a `count` above 1, the card is the top of a stack. With `flat`, the card has no plate. Use
// `flat` for one card in a toast.
Item {
    id: root

    property string icon
    property color tone: Theme.accent
    property string title
    property string body
    property string time
    property bool picture: false
    property int count: 1
    property bool expanded: false
    property bool flat: false
    default property alias actions: actionRow.data

    signal dismissed
    signal pressed

    readonly property bool _stacked: count > 1 && !expanded

    implicitWidth: 316
    implicitHeight: column.height + (flat ? 12 : 20) + (_stacked ? 8 : 0)

    // The cards below, as two thin bands.
    Repeater {
        model: root._stacked ? 2 : 0

        Rectangle {
            required property int index

            x: 8 * (index + 1)
            y: plate.height - height + 4 * (index + 1)
            width: plate.width - 16 * (index + 1)
            height: 20
            radius: Metrics.radiusCard
            color: Theme.card
            opacity: index === 0 ? 0.7 : 0.4
            z: -1 - index
        }
    }

    Rectangle {
        id: plate

        width: parent.width
        height: column.height + (root.flat ? 12 : 20)
        radius: Metrics.radiusCard
        color: root.flat ? "transparent" : Theme.card

        HoverHandler {
            id: hover
        }

        TapHandler {
            onTapped: root.pressed()
        }

        Column {
            id: column

            x: root.flat ? 2 : 12
            y: root.flat ? 6 : 10
            width: parent.width - 2 * x
            spacing: Metrics.space8

            Item {
                width: parent.width
                height: Math.max(32, texts.height)

                Rectangle {
                    id: badge

                    width: 32
                    height: 32
                    radius: Metrics.radiusControl
                    color: Theme.tint(root.tone, 0.18)

                    Icon {
                        anchors.centerIn: parent
                        name: root.icon
                        color: root.tone
                    }
                }

                Column {
                    id: texts

                    anchors.left: badge.right
                    anchors.leftMargin: Metrics.space12
                    anchors.right: trailing.left
                    anchors.rightMargin: Metrics.space10

                    Text {
                        width: parent.width
                        text: root.title
                        elide: Text.ElideRight
                        color: Theme.text
                        font.family: Metrics.fontUi
                        font.pixelSize: Metrics.textBody
                        font.weight: Metrics.weightStrong
                    }

                    Text {
                        width: parent.width
                        text: root.body
                        elide: root.expanded ? Text.ElideNone : Text.ElideRight
                        wrapMode: root.expanded ? Text.Wrap : Text.NoWrap
                        color: Theme.muted
                        font.family: Metrics.fontUi
                        font.pixelSize: Metrics.textBody
                        font.weight: Metrics.weightBody
                    }
                }

                Row {
                    id: trailing

                    anchors.right: parent.right
                    spacing: Metrics.space10

                    Rectangle {
                        width: 40
                        height: 40
                        radius: Metrics.radiusInner + 2
                        visible: root.picture && !root.expanded
                        gradient: Gradient {
                            orientation: Gradient.Horizontal

                            GradientStop {
                                position: 0
                                color: Qt.tint(Theme.card, Theme.tint(Theme.cyan, 0.7))
                            }
                            GradientStop {
                                position: 0.6
                                color: Qt.tint(Theme.card, Theme.tint(Theme.purple, 0.7))
                            }
                            GradientStop {
                                position: 1
                                color: Qt.tint(Theme.card, Theme.tint(Theme.rose, 0.6))
                            }
                        }
                    }

                    // When the pointer is on the card, the dismiss button replaces the time.
                    Item {
                        width: Math.max(22, stamp.implicitWidth)
                        height: 22

                        Text {
                            id: stamp

                            anchors.right: parent.right
                            visible: !hover.hovered && !root._stacked
                            text: root.time
                            color: Theme.muted
                            font.family: Metrics.fontUi
                            font.pixelSize: Metrics.textCaption
                        }

                        Rectangle {
                            anchors.right: parent.right
                            width: Math.max(20, tally.implicitWidth + 12)
                            height: 18
                            radius: 9
                            color: Theme.track
                            visible: !hover.hovered && root._stacked

                            Text {
                                id: tally

                                anchors.centerIn: parent
                                text: root.count
                                color: Theme.text
                                font.family: Metrics.fontUi
                                font.pixelSize: Metrics.textCaption
                                font.weight: Metrics.weightStrong
                            }
                        }

                        IconButton {
                            anchors.right: parent.right
                            width: 22
                            height: 22
                            visible: hover.hovered || visualFocus
                            iconName: "close"
                            text: "Dismiss"
                            onClicked: root.dismissed()
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 128
                radius: Metrics.radiusControl
                visible: root.picture && root.expanded
                gradient: Gradient {
                    orientation: Gradient.Horizontal

                    GradientStop {
                        position: 0
                        color: Qt.tint(Theme.card, Theme.tint(Theme.cyan, 0.7))
                    }
                    GradientStop {
                        position: 0.6
                        color: Qt.tint(Theme.card, Theme.tint(Theme.purple, 0.7))
                    }
                    GradientStop {
                        position: 1
                        color: Qt.tint(Theme.card, Theme.tint(Theme.rose, 0.6))
                    }
                }
            }

            Row {
                id: actionRow

                spacing: Metrics.space6
                visible: root.expanded && children.length > 0
            }
        }
    }
}
