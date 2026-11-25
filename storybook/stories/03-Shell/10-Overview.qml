// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import Phosphor.Design
import Phosphor.Storybook
import Phosphor.Storybook.Shell

Story {
    Variant {
        name: "Tiling, the first workspace is current"

        PanelFrame {
            OverviewPanel {
                onPicked: index => current = index
            }
        }
    }

    Variant {
        name: "Scrolling"

        PanelFrame {
            OverviewPanel {
                mode: "scrolling"
                onPicked: index => current = index
            }
        }
    }

    Variant {
        name: "Snapping, a different workspace is current"

        PanelFrame {
            OverviewPanel {
                current: 1
                mode: "snapping"
                onPicked: index => current = index
            }
        }
    }

    Variant {
        name: "Workspaces with no names"

        PanelFrame {
            OverviewPanel {
                workspaces: [
                    {
                        "name": "",
                        "windows": [
                            {
                                "icon": "globe",
                                "focused": true
                            }
                        ]
                    },
                    {
                        "name": "",
                        "windows": []
                    }
                ]
                onPicked: index => current = index
            }
        }
    }
}
