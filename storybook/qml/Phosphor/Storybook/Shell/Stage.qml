// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Templates as T
import Phosphor.Design

// The stage: the desktop becomes smaller, and the workspaces are at its side.
//
// The windows in the middle are the real windows of the current workspace. A press selects a
// window, and the selected window has the cyan edge. When the mode changes, the windows move to
// their new positions. In the scrolling mode the strip is wider than the screen. The user moves
// the strip, and the bar below the stage shows the part of the strip that the screen shows.
//
// The stage has no title, no inspector column and no key hints. The pictures at the side are the
// same pictures as in the overview.
Item {
    id: root

    property int current: 0
    property int selected: 0 // the window that has the focus
    property string mode: "tiling" // snapping, tiling, scrolling
    property var workspaces: SamplePlacement.workspaces

    signal picked(int index)

    readonly property var _windows: SamplePlacement.arrange(workspaces[current].windows, mode, false)
    readonly property real _gap: Metrics.surfaceGap
    property bool _ready: false

    implicitWidth: 960
    implicitHeight: 560

    property bool _started: false

    // Shows the selected window when it is outside the screen.
    function _reveal() {
        if (mode !== "scrolling" || selected >= _windows.length)
            return;
        const box = _windows[selected];
        const left = box.x * screen.width, right = (box.x + box.w) * screen.width;
        if (left < strip.contentX)
            strip.contentX = left;
        else if (right > strip.contentX + screen.width)
            strip.contentX = right - screen.width;
    }

    Component.onCompleted: {
        _started = true;
        _reveal();
        Qt.callLater(() => root._ready = !Session.capture);
    }
    // A different workspace starts with its first window. The values that the owner sets at the
    // start stay.
    onCurrentChanged: if (_started)
        selected = 0
    onSelectedChanged: _reveal()
    onModeChanged: _reveal()

    Rectangle {
        anchors.fill: parent
        color: Theme.desktop
    }

    Column {
        id: side

        x: Metrics.pageMargin
        anchors.verticalCenter: parent.verticalCenter
        spacing: Metrics.gapLoose

        Repeater {
            model: root.workspaces

            T.AbstractButton {
                id: space

                required property var modelData
                required property int index
                readonly property bool isCurrent: index === root.current

                width: 132
                height: 82
                scale: down ? Metrics.pressScale : 1
                onClicked: root.picked(index)

                Accessible.name: modelData.name !== "" ? modelData.name : "Workspace " + (index + 1)

                Behavior on scale {
                    SnapSpring {
                        epsilon: 0.002
                    }
                }

                contentItem: LayoutPreview {
                    windows: SamplePlacement.arrange(space.modelData.windows, space.isCurrent ? root.mode : "tiling")
                }

                background: Rectangle {
                    radius: Metrics.radiusCard
                    color: space.isCurrent ? Theme.selected : space.hovered ? Theme.hover : Theme.card

                    Behavior on color {
                        Tint {}
                    }

                    FocusRing {
                        target: space
                        around: parent.radius
                    }
                }

                padding: Metrics.space6
            }
        }
    }

    // The desktop of the current workspace, smaller.
    Item {
        id: screen

        x: side.x + side.width + Metrics.pageMargin
        width: root.width - x - Metrics.pageMargin
        height: Math.min(root.height - 2 * Metrics.pageMargin - footer.height - Metrics.gapSection, width * 10 / 16)
        y: (root.height - height - footer.height - Metrics.gapSection) / 2

        Flickable {
            id: strip

            anchors.fill: parent
            contentWidth: Math.max(1, ...root._windows.map(box => box.x + box.w)) * screen.width
            contentHeight: height
            interactive: contentWidth > width + 1
            boundsBehavior: Flickable.StopAtBounds
            clip: true

            Behavior on contentX {
                enabled: root._ready && !strip.dragging && !strip.flicking

                FlowSpring {}
            }

            Repeater {
                model: root._windows

                WindowFrame {
                    id: frame

                    required property var modelData
                    required property int index

                    x: modelData.x * screen.width + root._gap / 2
                    y: modelData.y * screen.height + root._gap / 2
                    width: modelData.w * screen.width - root._gap
                    height: modelData.h * screen.height - root._gap
                    icon: modelData.icon
                    title: modelData.title
                    focused: index === root.selected
                    buttons: width > 220

                    Behavior on x {
                        enabled: root._ready

                        FlowSpring {}
                    }
                    Behavior on y {
                        enabled: root._ready

                        FlowSpring {}
                    }
                    Behavior on width {
                        enabled: root._ready

                        FlowSpring {}
                    }
                    Behavior on height {
                        enabled: root._ready

                        FlowSpring {}
                    }

                    TapHandler {
                        onTapped: root.selected = frame.index
                    }
                }
            }
        }
    }

    Column {
        id: footer

        anchors.horizontalCenter: screen.horizontalCenter
        y: screen.y + screen.height + Metrics.gapSection
        spacing: Metrics.gapLoose

        // The part of the strip that the screen shows.
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 200
            height: 4
            radius: 2
            color: Theme.track
            opacity: strip.interactive ? 1 : 0

            Behavior on opacity {
                Fade {}
            }

            Rectangle {
                x: parent.width * strip.contentX / Math.max(1, strip.contentWidth)
                width: parent.width * strip.width / Math.max(1, strip.contentWidth)
                height: parent.height
                radius: 2
                color: Theme.accent
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
}
