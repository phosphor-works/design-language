// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Templates as T
import Phosphor.Design

// The overview: each workspace as a small picture of its windows, and the placement mode of the
// current workspace.
//
// A picture shows the real layout, so the user finds a window by its position. The current
// workspace has the selection tint. The focused window has the cyan edge. A workspace shows its
// name only when the user gave it a name. When the mode changes, the windows in the picture move
// to their new positions.
//
// The overview has no title, no second list of the same windows and no key hints.
Column {
    id: root

    property int current: 0
    property string mode: "tiling" // snapping, tiling, scrolling
    // Each workspace: { name, windows }. See LayoutPreview for a window.
    property var workspaces: SamplePlacement.workspaces

    signal picked(int index)

    readonly property real _card: 196

    // The positions of the windows in a mode, for a small picture.
    function arrange(windows: var, mode: string): var {
        return SamplePlacement.arrange(windows, mode);
    }

    width: workspaces.length * _card + (workspaces.length - 1) * Metrics.gapLoose + 2 * Metrics.padCard
    padding: Metrics.padCard
    topPadding: Metrics.pad
    spacing: Metrics.gapLoose

    Row {
        spacing: Metrics.gapLoose

        Repeater {
            model: root.workspaces

            T.AbstractButton {
                id: space

                required property var modelData
                required property int index
                readonly property bool isCurrent: index === root.current

                width: root._card
                height: picture.height + (label.visible ? label.height + Metrics.space8 : 0)
                scale: down ? Metrics.pressScale : 1
                onClicked: root.picked(index)

                Accessible.name: modelData.name !== "" ? modelData.name : "Workspace " + (index + 1)

                Behavior on scale {
                    SnapSpring {
                        epsilon: 0.002
                    }
                }

                contentItem: Item {
                    Rectangle {
                        id: picture

                        width: parent.width
                        height: Math.round(width * 10 / 16)
                        radius: Metrics.radiusCard
                        color: space.isCurrent ? Theme.selected : space.hovered ? Theme.hover : Theme.card
                        clip: true

                        Behavior on color {
                            Tint {}
                        }

                        FocusRing {
                            target: space
                            around: parent.radius
                        }

                        LayoutPreview {
                            anchors.fill: parent
                            anchors.margins: Metrics.space8
                            // Only the current workspace changes with the mode switch below.
                            windows: root.arrange(space.modelData.windows, space.isCurrent ? root.mode : "tiling")
                        }
                    }

                    Text {
                        id: label

                        anchors.top: picture.bottom
                        anchors.topMargin: Metrics.space8
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        visible: root.workspaces.some(workspace => workspace.name !== "")
                        text: space.modelData.name
                        elide: Text.ElideRight
                        color: space.isCurrent ? Theme.text : Theme.muted
                        font.family: Metrics.fontUi
                        font.pixelSize: Metrics.textLabel
                        font.weight: space.isCurrent ? Metrics.weightStrong : Metrics.weightBody
                    }
                }

                background: Item {}
            }
        }
    }

    Segmented {
        anchors.horizontalCenter: parent.horizontalCenter
        label: "Placement"
        options: [
            {
                "value": "snapping",
                "text": "Snapping"
            },
            {
                "value": "tiling",
                "text": "Tiling"
            },
            {
                "value": "scrolling",
                "text": "Scrolling"
            }
        ]
        value: root.mode
        onPicked: value => root.mode = value
    }
}
