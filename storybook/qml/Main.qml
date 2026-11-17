// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtCore
import QtQuick
import QtQuick.Controls
import Phosphor.Design

// The window of the storybook. The stories are at the left. The toolbar that sets the design tokens
// is at the top. The story fills the remaining area.
//
// `Session` comes from the host. It stays during a reload. No object in this file stays.
Rectangle {
    id: window

    property string filter: ""
    readonly property var current: Session.stories.find(story => story.id === Session.story) ?? null
    // The stories in the structure that the sidebar uses: each group is a category that contains
    // its stories.
    readonly property var navModel: {
        const groups = [];
        for (const story of Session.stories) {
            let group = groups.find(g => g.text === story.group);
            if (!group) {
                group = {
                    "text": story.group,
                    "children": []
                };
                groups.push(group);
            }
            group.children.push({
                "id": story.id,
                "text": story.name
            });
        }
        return groups;
    }

    color: Theme.desktop

    // The closed categories. The value stays between reloads and runs.
    Settings {
        id: remembered

        category: "sidebar"
        property string collapsed
    }

    // The toolbar writes to Session, and Session sets the tokens. After a reload, the tokens get
    // their values from Session again. Thus the values of the toolbar stay.
    Binding {
        target: Theme
        property: "scheme"
        value: Session.globals.scheme
    }
    Binding {
        target: Theme
        property: "accentName"
        value: Session.globals.accent
    }
    Binding {
        target: Theme
        property: "glow"
        value: Session.globals.glow
    }
    Binding {
        target: Metrics
        property: "corners"
        value: Session.globals.corners
    }
    Binding {
        target: Metrics
        property: "density"
        value: Session.globals.density
    }
    Binding {
        target: Motion
        property: "preset"
        value: Session.globals.motion
    }
    Binding {
        target: Motion
        property: "slow"
        value: Session.globals.slow
    }

    Rectangle {
        id: side

        width: 236
        height: parent.height
        color: Theme.sidebar

        Row {
            id: brand

            x: 18
            y: 16
            spacing: 10

            Icon {
                name: "phosphor"
                size: 22
                color: Theme.cyan
            }

            Label {
                anchors.verticalCenter: parent.verticalCenter
                text: "Storybook"
                font.pixelSize: Metrics.textHeading
                font.weight: Metrics.weightStrong
            }
        }

        TextField {
            id: search

            anchors.top: brand.bottom
            anchors.topMargin: 14
            x: 12
            width: parent.width - 24
            implicitHeight: 34
            placeholderText: "Search"
            font.pixelSize: Metrics.textBody
            onTextChanged: window.filter = text.trim().toLowerCase()
        }

        Flickable {
            anchors.top: search.bottom
            anchors.topMargin: 10
            anchors.bottom: parent.bottom
            x: 12
            width: parent.width - 24
            contentHeight: nav.height + 12
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            ScrollBar.vertical: ScrollBar {}

            NavList {
                id: nav

                width: parent.width
                model: window.navModel
                current: Session.story
                filter: window.filter
                onPicked: id => Session.story = id
                // A capture gives the same picture each time, so it ignores the closed categories
                // of the last run.
                Component.onCompleted: if (!Session.capture && remembered.collapsed !== "")
                    collapsed = remembered.collapsed.split("|")
                onCollapsedChanged: if (!Session.capture)
                    remembered.collapsed = collapsed.join("|")
            }
        }
    }

    Flow {
        id: toolbar

        anchors.left: side.right
        anchors.right: parent.right
        anchors.leftMargin: 28
        anchors.rightMargin: 20
        y: 14
        spacing: 14

        Label {
            height: Metrics.controlHeight
            rightPadding: 14
            verticalAlignment: Text.AlignVCenter
            text: window.current ? window.current.name : ""
            font.pixelSize: Metrics.textTitle
            font.weight: Metrics.weightStrong
            font.letterSpacing: -0.3
        }

        Segmented {
            label: "Scheme"
            options: [
                {
                    "value": "dark",
                    "text": "Dark"
                },
                {
                    "value": "light",
                    "text": "Light"
                }
            ]
            value: Session.globals.scheme
            onPicked: value => Session.setGlobal("scheme", value)
        }

        SwatchPicker {
            height: Metrics.controlHeight
            topPadding: 2
            value: Session.globals.accent
            onPicked: value => Session.setGlobal("accent", value)
        }

        Slider {
            width: 110
            height: Metrics.controlHeight
            from: 0
            to: 24
            stepSize: 1
            value: Session.globals.corners
            onMoved: Session.setGlobal("corners", value)

            Accessible.name: "Corners"
            ToolTip.visible: hovered
            ToolTip.text: "Corners " + value
        }

        Segmented {
            label: "Density"
            options: [
                {
                    "value": "comfortable",
                    "text": "Comfortable"
                },
                {
                    "value": "compact",
                    "text": "Compact"
                }
            ]
            value: Session.globals.density
            onPicked: value => Session.setGlobal("density", value)
        }

        Segmented {
            label: "Motion"
            options: [
                {
                    "value": "calm",
                    "text": "Calm"
                },
                {
                    "value": "fluid",
                    "text": "Fluid"
                },
                {
                    "value": "lively",
                    "text": "Lively"
                }
            ]
            value: Session.globals.motion
            onPicked: value => Session.setGlobal("motion", value)
        }

        Segmented {
            label: "Speed"
            options: [
                {
                    "value": 1,
                    "text": "1×"
                },
                {
                    "value": 4,
                    "text": "¼×"
                }
            ]
            value: Session.globals.slow
            onPicked: value => Session.setGlobal("slow", value)
        }
    }

    Flickable {
        id: canvas

        anchors.left: side.right
        anchors.right: parent.right
        anchors.top: toolbar.bottom
        anchors.topMargin: 10
        anchors.bottom: parent.bottom
        contentHeight: loader.height
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        ScrollBar.vertical: ScrollBar {}

        Loader {
            id: loader

            readonly property bool fills: item !== null && item.fill === true

            width: canvas.width
            height: fills ? canvas.height : item ? Math.max(item.implicitHeight, 1) : 0
            source: Session.storyUrl(Session.story)
            // A large story takes time to make. The window continues to respond during that time.
            asynchronous: !Session.blocking
        }

        Spinner {
            anchors.horizontalCenter: parent.horizontalCenter
            y: 96
            size: 22
            visible: loader.status === Loader.Loading
        }

        Label {
            x: 28
            y: 28
            width: canvas.width - 56
            visible: loader.status === Loader.Error
            wrapMode: Text.Wrap
            color: Theme.danger
            text: "This story did not load. The terminal that started the storybook has the error."
        }
    }
}
