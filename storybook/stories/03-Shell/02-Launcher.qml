// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import Phosphor.Design
import Phosphor.Storybook
import Phosphor.Storybook.Shell

Story {
    Variant {
        name: "No query"

        PanelFrame {
            LauncherPanel {}
        }
    }

    Variant {
        name: "A query, with the second match current"

        PanelFrame {
            LauncherPanel {
                query: "f"
                index: 1
            }
        }
    }

    Variant {
        name: "No match"

        PanelFrame {
            LauncherPanel {
                query: "zed"
            }
        }
    }
}
