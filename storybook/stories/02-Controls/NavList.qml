// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import Phosphor.Design
import Phosphor.Storybook

Story {
    id: story

    readonly property var pages: [
        {
            "text": "Placement",
            "children": [
                {
                    "id": "snapping",
                    "text": "Snapping",
                    "icon": "zones"
                },
                {
                    "id": "tiling",
                    "text": "Tiling",
                    "icon": "tiling"
                },
                {
                    "id": "scrolling",
                    "text": "Scrolling",
                    "icon": "scrolling"
                }
            ]
        },
        {
            "text": "Lambent",
            "children": [
                {
                    "id": "style",
                    "text": "Style",
                    "icon": "drop"
                },
                {
                    "id": "bar",
                    "text": "Bar",
                    "icon": "bar"
                }
            ]
        },
        {
            "id": "about",
            "text": "About",
            "icon": "phosphor"
        }
    ]

    Variant {
        name: "Open"
        surface: true

        NavList {
            width: 220
            model: story.pages
            current: "tiling"
            onPicked: id => current = id
        }
    }

    Variant {
        name: "A closed category holds the current page"
        surface: true

        NavList {
            width: 220
            model: story.pages
            current: "tiling"
            collapsed: ["Placement"]
            onPicked: id => current = id
        }
    }

    Variant {
        name: "Filtered by \"s\""
        surface: true

        NavList {
            width: 220
            model: story.pages
            current: "style"
            filter: "s"
            collapsed: ["Placement"]
            onPicked: id => current = id
        }
    }

    Variant {
        name: "Without icons"
        surface: true

        NavList {
            width: 220
            model: [
                {
                    "text": "Controls",
                    "children": [
                        {
                            "id": "button",
                            "text": "Button"
                        },
                        {
                            "id": "switch",
                            "text": "Switch"
                        }
                    ]
                },
                {
                    "text": "Shell",
                    "children": [
                        {
                            "id": "body",
                            "text": "Shell body"
                        }
                    ]
                }
            ]
            current: "switch"
            onPicked: id => current = id
        }
    }
}
