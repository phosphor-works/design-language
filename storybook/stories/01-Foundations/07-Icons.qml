// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import Phosphor.Design
import Phosphor.Storybook

Doc {
    Para {
        text: "There is one set of symbolic icons. An icon is a stroke drawing and has the color of the text next to it. When the item that the icon names is active, the icon has the accent color."
    }

    Heading {
        text: "Drawing"
    }
    Spec {
        columns: [
            {
                "title": "",
                "width": 150
            },
            {
                "title": "",
                "width": 600
            }
        ]
        rows: [["Grid", "A square of 24 units. Keep 2 units empty at each edge."], ["Stroke", Metrics.iconStroke + " units, with round caps and round joins. Do not fill a shape. The exceptions are the media buttons and the three logos."], ["Corners", "A rounded rectangle in an icon has a radius of 2 to 3 units."], ["Detail", "Do not draw a detail that is not visible at 16 px. That is the smallest icon size."]]
    }

    Heading {
        text: "Sizes"
    }
    Row {
        spacing: Metrics.space32

        Repeater {
            model: [["iconSmall", Metrics.iconSmall, "In a control or a row of settings"], ["iconSize", Metrics.iconSize, "The bar, tiles, shell lists"], ["iconLarge", Metrics.iconLarge, "A logo, an empty state"]]

            Row {
                required property var modelData

                spacing: Metrics.space12

                Icon {
                    anchors.verticalCenter: parent.verticalCenter
                    name: "wifi"
                    size: parent.modelData[1]
                }
                Column {
                    Text {
                        text: parent.parent.modelData[0] + " " + parent.parent.modelData[1]
                        color: Theme.text
                        font.family: Metrics.fontMono
                        font.pixelSize: Metrics.textLabel
                    }
                    Text {
                        text: parent.parent.modelData[2]
                        color: Theme.muted
                        font.family: Metrics.fontUi
                        font.pixelSize: Metrics.textLabel
                    }
                }
            }
        }
    }
    Para {
        text: "Do not scale an icon to a size between these sizes. The stroke scales with the icon, so the proportion stays the same."
    }

    Heading {
        text: "Using an icon"
    }
    Para {
        text: "An icon names an item, and the text next to it gives the value. For example, use the Wi-Fi icon with \"Home network\". Do not use the icon with \"Wi-Fi\" and a second line below it."
    }
    Para {
        text: "An icon changes with the state that it shows. The volume icon has three forms: loud, quiet and muted. The icon for Wi-Fi that is off has a line through it. Use a different icon, and do not write a status line."
    }
    Para {
        text: "Use an icon without text as a button only when its meaning is known. Examples are close, back, a chevron and the media buttons. Give such a button a name for a screen reader, and a tooltip."
    }
    Para {
        text: "iconGap, " + Metrics.iconGap + " px, is the distance between an icon and its text."
    }

    Heading {
        text: "The set"
    }
    Flow {
        width: parent.width
        spacing: Metrics.space6

        Repeater {
            model: Object.keys(Icons.set)

            Column {
                required property string modelData

                width: 104
                spacing: Metrics.space8
                topPadding: Metrics.space12
                bottomPadding: Metrics.space8

                Icon {
                    anchors.horizontalCenter: parent.horizontalCenter
                    name: parent.modelData
                    size: Metrics.iconLarge
                }
                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight
                    text: parent.modelData
                    color: Theme.muted
                    font.family: Metrics.fontMono
                    font.pixelSize: Metrics.textCaption
                }
            }
        }
    }
}
