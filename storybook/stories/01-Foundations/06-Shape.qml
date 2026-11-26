// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import Phosphor.Design
import Phosphor.Storybook

Doc {
    component Corner: Column {
        property real radius
        property string name

        spacing: Metrics.space6

        Rectangle {
            width: 76
            height: 76
            radius: parent.radius
            color: Theme.field
            border.width: Metrics.lineWidth
            border.color: Theme.line
        }
        Text {
            text: parent.name + " " + Math.round(parent.radius)
            color: Theme.muted
            font.family: Metrics.fontMono
            font.pixelSize: Metrics.textLabel
        }
    }

    Para {
        text: "There are four radii, and one setting scales all four. Move the corner slider in the toolbar to change them."
    }

    Heading {
        text: "Radii"
    }
    Row {
        spacing: Metrics.space20

        Corner {
            radius: Metrics.radiusInner
            name: "Inner"
        }
        Corner {
            radius: Metrics.radiusControl
            name: "Control"
        }
        Corner {
            radius: Metrics.radiusCard
            name: "Card"
        }
        Corner {
            radius: Metrics.radiusSurface
            name: "Surface"
        }
    }
    Spec {
        columns: [
            {
                "title": "Token",
                "width": 150
            },
            {
                "title": "Now",
                "width": 70,
                "mono": true
            },
            {
                "title": "At 16",
                "width": 70,
                "mono": true
            },
            {
                "title": "The corner of",
                "width": 520
            }
        ]
        rows: [["radiusInner", Math.round(Metrics.radiusInner), 6, "An item inside a control: the indicator of a segment, a key, a check box."], ["radiusControl", Math.round(Metrics.radiusControl), 10, "A control: a button, a field, a row in a list, a chip in the bar."], ["radiusCard", Math.round(Metrics.radiusCard), 14, "A card, a tile that is off, a window."], ["radiusSurface", Math.round(Metrics.radiusSurface), 20, "A surface of the shell: the drawer of the shell body, a popup, a dialog."]]
    }

    Heading {
        text: "A radius inside a radius"
    }
    Para {
        text: "When one shape is immediately inside a second shape, the inner radius is the outer radius minus the padding. Then the band between the two edges has the same width around the corner. A surface with a radius of 20 and a padding of 6 contains a card with a radius of 14. Thus the steps are 6, 10, 14 and 20."
    }
    Rectangle {
        width: 220
        height: 96
        radius: Metrics.radiusSurface
        color: Theme.field
        border.width: Metrics.lineWidth
        border.color: Theme.line

        Rectangle {
            anchors.fill: parent
            anchors.margins: Metrics.space6
            radius: Metrics.radiusCard
            color: Theme.card
        }
    }
    Para {
        text: "The rule applies when the padding is smaller than the outer radius. When the padding is larger, a shape uses the radius of its role."
    }

    Heading {
        text: "Shape shows a state"
    }
    Para {
        text: "A control that is on is rounder than the same control when it is off. A tile changes from a rounded rectangle to a pill. A chosen swatch changes from a circle to a rounded square. The radius moves on a spring."
    }
    Row {
        spacing: Metrics.gap

        Tile {
            icon: "bulb"
            text: "Night light"
            onToggled: checked = !checked
        }
        Tile {
            icon: "bulb"
            text: "Night light"
            checked: true
            onToggled: checked = !checked
        }
    }

    Heading {
        text: "Lines"
    }
    Spec {
        columns: [
            {
                "title": "Token",
                "width": 150
            },
            {
                "title": "Value",
                "width": 70,
                "mono": true
            },
            {
                "title": "Used for",
                "width": 520
            }
        ]
        rows: [["lineWidth", Metrics.lineWidth, "The edge between two grounds, in Theme.line: around a popup, between the rows of a group."], ["focusWidth", Metrics.focusWidth, "The focus ring, in Theme.focus."], ["focusOffset", Metrics.focusOffset, "The distance between the ring and its control."], ["iconStroke", Metrics.iconStroke, "An icon's stroke, on the 24 unit grid."], ["rimWidth", Metrics.rimWidth, "The spectrum edge of the shell body."]]
    }
    Para {
        text: "A control that the user does not touch has no outline. Its ground separates it from the area around it. Use a line only where two grounds have almost the same value, and around the control that has focus."
    }

    Heading {
        text: "Depth"
    }
    Para {
        text: "Do not use a drop shadow. An item in front is one ground lighter than the item behind it. A surface that floats has a 1 px line. A modal surface puts Theme.shade over all other items."
    }
    Para {
        text: "Surfaces that touch become one shape. A panel connects to the bar with a fillet. Surfaces that do not touch keep surfaceGap, " + Metrics.surfaceGap + " px, between them."
    }
}
