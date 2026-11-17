// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import Phosphor.Design
import Phosphor.Storybook

Doc {
    id: doc

    component Cell: Column {
        property string name
        default property alias content: slot.data

        width: 150
        spacing: Metrics.space8

        Item {
            id: slot

            width: parent.width
            height: 40
        }
        Text {
            text: parent.name
            color: Theme.muted
            font.family: Metrics.fontUi
            font.pixelSize: Metrics.textLabel
        }
    }

    Para {
        text: "Each control shows the same state in the same way. A control uses the states that apply to it. Draw each state as this page tells you."
    }

    Heading {
        text: "The states"
    }
    Spec {
        columns: [
            {
                "title": "State",
                "width": 110
            },
            {
                "title": "Drawn as",
                "width": 420
            },
            {
                "title": "From",
                "width": 280,
                "mono": true
            }
        ]
        rows: [["Rest", "The ground of the control: field for a button, track for a switch or a slider. There is no outline.", "Theme.field  Theme.track"], ["Hover", "The ground becomes one step lighter, or Theme.hover covers it. Muted text changes to the text color.", "Theme.hover"], ["Pressed", "The control is smaller while the user holds it. Its color does not change.", "Metrics.pressScale  SnapSpring"], ["Focus", "A ring in the focus color, around the control. Only the keyboard causes it.", "FocusRing"], ["On", "The fill is the accent and its content is ink. If possible, the shape becomes rounder.", "Theme.accent  Theme.ink"], ["Current", "A row in a list has the selected tint and keeps its text color. Its icon has the accent color.", "Theme.selected"], ["Chosen", "The option that applies, in a list of options. The row has a check at its end. Its text and its icon have the accent color.", "ListRow.selected"], ["Busy", "A spinner is in the position of the result: the position of the check, or the label of the button.", "Spinner"], ["Disabled", "The whole control at " + Theme.disabled * 100 + "% opacity. The control ignores the pointer and does not get focus.", "Theme.disabled"], ["Error", "The message and its icon are rose. The control keeps its shape and its ground.", "Theme.danger"]]
    }

    Heading {
        text: "A button"
    }
    Row {
        Cell {
            name: "Rest"

            Button {
                text: "Discard"
            }
        }
        Cell {
            name: "Pressed"

            Button {
                text: "Discard"
                down: true
            }
        }
        Cell {
            name: "Accent"

            Button {
                text: "Apply"
                highlighted: true
            }
        }
        Cell {
            name: "Accent, pressed"

            Button {
                text: "Apply"
                highlighted: true
                down: true
            }
        }
        Cell {
            name: "Disabled"

            Button {
                text: "Apply"
                highlighted: true
                enabled: false
            }
        }
    }

    Heading {
        text: "A switch and a tile"
    }
    Row {
        Cell {
            name: "Off"

            Switch {
                Accessible.name: "Off"
            }
        }
        Cell {
            name: "Held"

            Switch {
                down: true
                Accessible.name: "Held"
            }
        }
        Cell {
            name: "On"

            Switch {
                checked: true
                Accessible.name: "On"
            }
        }
        Cell {
            name: "Disabled"

            Switch {
                checked: true
                enabled: false
                Accessible.name: "Disabled"
            }
        }
    }
    Row {
        spacing: Metrics.gap

        Tile {
            width: 170
            icon: "moon"
            text: "Do not disturb"
        }
        Tile {
            width: 170
            icon: "moon"
            text: "Do not disturb"
            checked: true
        }
    }

    Heading {
        text: "A row in a list"
    }
    Column {
        width: 340

        ListRow {
            icon: "wifi"
            text: "Guest"
        }
        ListRow {
            icon: "wifi"
            text: "Highlighted by the keyboard"
            highlighted: true
        }
        ListRow {
            icon: "wifi"
            text: "Connecting"
            secure: true
            busy: true
        }
        ListRow {
            icon: "wifi"
            text: "Connected"
            secure: true
            selected: true
        }
    }

    Heading {
        text: "Rules"
    }
    Para {
        text: "Hover and focus are different states, and two different controls can have them at the same time. Hover follows the pointer and is not bright. Focus follows the keyboard and is the brightest item on the surface."
    }
    Para {
        text: "Show the pressed state with shape and not with color. A control that becomes darker looks disabled."
    }
    Para {
        text: "On, current and chosen are three different states. On is a setting that is active, and its fill is the accent. Current is the position of the user in a list, and it has a tint. Chosen is the option that applies, for example the connected network, and it has a check. Do not fill a row of a list with the accent."
    }
    Para {
        text: "A disabled control keeps its position and its size. If a control never applies, remove it."
    }
    Para {
        text: "This page cannot show hover, because the pointer can be on only one control. Move the pointer across the examples to see hover."
    }
}
