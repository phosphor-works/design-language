// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import Phosphor.Design
import Phosphor.Storybook
import Phosphor.Storybook.Shell

Story {
    Variant {
        name: "Three notifications"

        PanelFrame {
            InboxPanel {}
        }
    }

    Variant {
        name: "No notifications"

        PanelFrame {
            InboxPanel {
                items: []
            }
        }
    }

    Variant {
        name: "No notifications, do not disturb"

        PanelFrame {
            InboxPanel {
                items: []
                quiet: true
            }
        }
    }
}
