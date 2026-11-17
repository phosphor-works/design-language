// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import Phosphor.Design

// The media panel: the cover, the track, a picture of the sound, the position and three buttons.
//
// The play button is a circle while the track plays and a rounded square while the track is paused.
// The visualizer also becomes low and stops. Thus no word tells the state. A press on the
// visualizer changes its style.
Column {
    id: root

    property string title: "Awake"
    property string artist: "Tycho"
    property bool playing: true
    property real position: 0.34
    property bool hasMedia: true
    property color tone: Theme.purple
    property url art: Qt.resolvedUrl("../../../../assets/cover-awake.jpg")
    property string visualizer: "bars" // bars, ribbon, halo, or off
    property var levels: [] // the spectrum of the audio. When it is empty, the visualizer makes a signal

    signal toggled

    width: 316
    padding: Metrics.pad
    topPadding: Metrics.space8
    spacing: Metrics.gapLoose

    Row {
        width: root.width - 2 * Metrics.pad
        spacing: Metrics.gapLoose
        visible: root.hasMedia

        Artwork {
            id: art

            size: 56
            source: root.art
            asynchronous: !Session.capture
            tone: root.tone
        }

        Column {
            width: parent.width - art.width - bars.width - 2 * parent.spacing
            anchors.verticalCenter: parent.verticalCenter
            spacing: Metrics.space2

            Text {
                width: parent.width
                text: root.title
                elide: Text.ElideRight
                color: Theme.text
                font.family: Metrics.fontUi
                font.pixelSize: Metrics.textRow
                font.weight: Metrics.weightStrong
            }
            Text {
                width: parent.width
                text: root.artist
                elide: Text.ElideRight
                color: Theme.muted
                font.family: Metrics.fontUi
                font.pixelSize: Metrics.textLabel
                font.weight: Metrics.weightBody
            }
        }

        // With no visualizer, the small bars show that the track plays.
        Bars {
            id: bars

            anchors.verticalCenter: parent.verticalCenter
            visible: root.visualizer === "off"
            width: visible ? implicitWidth : 0
            running: root.playing
            color: root.playing ? Theme.accent : Theme.muted
        }
    }

    Visualizer {
        id: picture

        width: root.width - 2 * Metrics.pad
        height: root.visualizer === "halo" ? 96 : 56
        visible: root.hasMedia && root.visualizer !== "off"
        style: root.visualizer
        count: root.visualizer === "halo" ? 64 : 40
        running: root.playing
        animated: !Session.capture
        levels: root.levels

        Accessible.name: "Visualizer"

        TapHandler {
            onTapped: {
                const styles = ["bars", "ribbon", "halo"];
                root.visualizer = styles[(styles.indexOf(root.visualizer) + 1) % styles.length];
            }
        }
    }

    Slider {
        width: root.width - 2 * Metrics.pad
        visible: root.hasMedia
        value: root.position
        onMoved: root.position = value

        Accessible.name: "Position"
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: Metrics.gapLoose
        visible: root.hasMedia

        IconButton {
            anchors.verticalCenter: parent.verticalCenter
            iconName: "previous"
            text: "Previous"
        }

        T.AbstractButton {
            id: play

            width: 44
            height: 44
            scale: down ? Metrics.pressScale : 1
            onClicked: root.toggled()

            Accessible.name: root.playing ? "Pause" : "Play"

            Behavior on scale {
                SnapSpring {
                    epsilon: 0.002
                }
            }

            contentItem: Item {
                Icon {
                    anchors.centerIn: parent
                    name: root.playing ? "pause" : "play"
                    color: Theme.ink
                }
            }

            background: Rectangle {
                // A fixed value, so that the radius does not move when the button gets its size.
                radius: root.playing ? 22 : Metrics.radiusCard
                color: Theme.accent

                Behavior on radius {
                    FlowSpring {}
                }

                FocusRing {
                    target: play
                    around: parent.radius
                }
            }
        }

        IconButton {
            anchors.verticalCenter: parent.verticalCenter
            iconName: "next"
            text: "Next"
        }
    }

    // Nothing plays. A dim icon is the full content.
    Item {
        width: root.width - 2 * Metrics.pad
        height: Metrics.rowHeight
        visible: !root.hasMedia

        Icon {
            anchors.centerIn: parent
            name: "music"
            size: Metrics.iconLarge
            color: Theme.muted
            opacity: 0.5
        }
    }
}
