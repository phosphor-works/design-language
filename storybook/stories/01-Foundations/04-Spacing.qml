// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import Phosphor.Design
import Phosphor.Storybook

Doc {
    id: doc

    // A band that shows a distance in the drawing below.
    component Band: Rectangle {
        color: Theme.tint(Theme.purple, 0.45)
    }

    Para {
        text: "Each gap, inset and margin is a step of one ramp. Items that are related are nearer to each other than items that are not related."
    }

    Heading {
        text: "The ramp"
    }
    Column {
        spacing: Metrics.space6

        Repeater {
            model: Metrics.spaceRamp

            Row {
                required property int modelData

                spacing: Metrics.space12

                Text {
                    width: 70
                    anchors.verticalCenter: parent.verticalCenter
                    text: "space" + parent.modelData
                    color: Theme.text
                    font.family: Metrics.fontMono
                    font.pixelSize: Metrics.textLabel
                }
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.modelData
                    height: Metrics.space12
                    radius: Metrics.space2
                    color: Theme.accent
                }
            }
        }
    }
    Para {
        text: "The steps increase by 2 up to 12, then by 4, then by 8, then by 16. Use the small steps inside a control and the large steps on a page. A distance that is not on the ramp is an error. The exception is a dimension of one component, for example the travel of a switch. Keep such a dimension inside the component."
    }

    Heading {
        text: "The use of each step"
    }
    Spec {
        columns: [
            {
                "title": "Token",
                "width": 130
            },
            {
                "title": "Value",
                "width": 70,
                "mono": true
            },
            {
                "title": "The distance between",
                "width": 560
            }
        ]
        rows: [["gap", Metrics.gap, "Siblings: two tiles, two buttons, two cards in a list, two notifications."], ["gapLoose", Metrics.gapLoose, "Groups: two cards on a page, the search field and the list under it."], ["gapSection", Metrics.gapSection, "Sections of a page, each with its own heading."], ["pad", Metrics.pad, "The edge of a surface and its content: a panel, a popup, a dialog."], ["padCard", Metrics.padCard, "The side of a card and its rows."], ["padControl", Metrics.padControl, "The side of a control and its label: a button, a segment, a field."], ["padRow", Metrics.padRow, "The side of a list row and its icon."], ["iconGap", Metrics.iconGap, "An icon and the text it belongs to."], ["pageMargin", Metrics.pageMargin, "The edge of a window and its content."], ["screenInset", Metrics.screenInset, "The edge of the screen and the bar."], ["surfaceGap", Metrics.surfaceGap, "Two surfaces that do not touch. Surfaces that touch become one shape."]]
    }
    Para {
        text: "Use the name when a name applies. A change to the scale then also changes your component. Use a step of the ramp directly only inside one component."
    }

    Heading {
        text: "In use"
    }
    Para {
        text: "This is a panel of quick settings. The purple bands show pad around the content. The cyan bands show gap between the tiles."
    }
    Rectangle {
        id: panel

        width: 2 * Metrics.pad + 2 * 170 + Metrics.gap
        height: 2 * Metrics.pad + 2 * Metrics.tileHeight + Metrics.gap
        radius: Metrics.radiusSurface
        color: Theme.surface
        border.width: Metrics.lineWidth
        border.color: Theme.line

        Grid {
            x: Metrics.pad
            y: Metrics.pad
            columns: 2
            spacing: Metrics.gap

            Tile {
                width: 170
                icon: "wifi"
                text: "Home network"
                checked: true
            }
            Tile {
                width: 170
                icon: "bluetooth"
                text: "Buds"
                checked: true
            }
            Tile {
                width: 170
                icon: "moon"
                text: "Do not disturb"
            }
            Tile {
                width: 170
                icon: "bulb"
                text: "Night light"
            }
        }

        Band {
            width: Metrics.pad
            height: parent.height
        }
        Band {
            x: parent.width - width
            width: Metrics.pad
            height: parent.height
        }
        Band {
            x: Metrics.pad
            width: parent.width - 2 * Metrics.pad
            height: Metrics.pad
        }
        Band {
            x: Metrics.pad
            y: parent.height - height
            width: parent.width - 2 * Metrics.pad
            height: Metrics.pad
        }
        Band {
            x: Metrics.pad + 170
            y: Metrics.pad
            width: Metrics.gap
            height: parent.height - 2 * Metrics.pad
            color: Theme.tint(Theme.cyan, 0.45)
        }
        Band {
            x: Metrics.pad
            y: Metrics.pad + Metrics.tileHeight
            width: parent.width - 2 * Metrics.pad
            height: Metrics.gap
            color: Theme.tint(Theme.cyan, 0.45)
        }
    }
    Row {
        spacing: Metrics.space16

        Repeater {
            model: [[Theme.purple, "pad " + Metrics.pad], [Theme.cyan, "gap " + Metrics.gap]]

            Row {
                required property var modelData

                spacing: Metrics.space6

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: Metrics.space12
                    height: Metrics.space12
                    radius: Metrics.space2
                    color: Theme.tint(parent.modelData[0], 0.45)
                }
                Text {
                    text: parent.modelData[1]
                    color: Theme.muted
                    font.family: Metrics.fontMono
                    font.pixelSize: Metrics.textLabel
                }
            }
        }
    }

    Heading {
        text: "Rules"
    }
    Para {
        text: "Related items are near each other. The gap inside a group is smaller than the gap around the group. Tiles are 8 apart, the tiles are 12 from the edge, and the next section is 24 away. If three levels are not sufficient, the layout has too many levels."
    }
    Para {
        text: "Use space to separate items. Use a line only between rows that are in the same card. Do not put a line below a heading, around a group, or between a sidebar and its page."
    }
    Para {
        text: "Padding and radius are related. Keep content away from an edge by the radius of that edge or more. Then a corner does not cut the content. The Shape page gives the rule for a radius inside a radius."
    }
    Para {
        text: "The compact density changes the heights on the Layout page. It does not change this ramp. Items become shorter, but the gaps stay the same."
    }
}
