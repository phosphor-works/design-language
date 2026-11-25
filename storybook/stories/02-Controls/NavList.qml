// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

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

    // A sidebar with drill parents: each placement mode has a list of its own.
    readonly property var deep: [
        {
            "id": "overview",
            "text": "Overview",
            "icon": "phosphor"
        },
        {
            "text": "Snapping",
            "icon": "zones",
            "drill": true,
            "children": [
                {
                    "id": "zones",
                    "text": "Zones",
                    "icon": "zones"
                },
                {
                    "id": "snap-keys",
                    "text": "Shortcuts",
                    "icon": "keyboard"
                },
                {
                    "text": "Library",
                    "children": [
                        {
                            "id": "layouts",
                            "text": "Layouts",
                            "icon": "tiling"
                        }
                    ]
                }
            ]
        },
        {
            "text": "Tiling",
            "icon": "tiling",
            "drill": true,
            "count": 2,
            "children": [
                {
                    "id": "algorithms",
                    "text": "Algorithms",
                    "icon": "tune"
                },
                {
                    "id": "gaps",
                    "text": "Gaps",
                    "icon": "tiling"
                }
            ]
        },
        {
            "divider": true
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

    Variant {
        name: "Counts and a divider"
        surface: true

        NavList {
            width: 220
            model: [
                {
                    "id": "inbox",
                    "text": "Notifications",
                    "icon": "bell",
                    "count": 3
                },
                {
                    "id": "updates",
                    "text": "Updates",
                    "icon": "download",
                    "count": 12
                },
                {
                    "divider": true
                },
                {
                    "id": "about",
                    "text": "About",
                    "icon": "phosphor"
                }
            ]
            current: "inbox"
            onPicked: id => current = id
        }
    }

    Variant {
        name: "Drill parents: a row opens a list of its own"
        surface: true

        NavList {
            width: 220
            model: story.deep
            current: "overview"
            onPicked: id => current = id
        }
    }

    Variant {
        name: "In a drill parent, with the row that goes back"
        surface: true

        NavList {
            width: 220
            model: story.deep
            current: "zones"
            onPicked: id => current = id
        }
    }

    Variant {
        name: "The top list shows which parent holds the current page"
        surface: true

        NavList {
            width: 220
            model: story.deep
            current: "gaps"
            // The user went back. The current page stays in Tiling.
            Component.onCompleted: scope = ""
            onPicked: id => current = id
        }
    }

    Variant {
        name: "A filter searches each list"
        surface: true

        NavList {
            width: 220
            model: story.deep
            current: "zones"
            filter: "s"
            onPicked: id => current = id
        }
    }

    Variant {
        name: "Compact: only the pages, as icons"
        surface: true

        NavList {
            compact: true
            model: story.pages.concat([
                {
                    "divider": true
                },
                {
                    "id": "updates",
                    "text": "Updates",
                    "count": 12
                }
            ])
            current: "tiling"
            onPicked: id => current = id
        }
    }
}
