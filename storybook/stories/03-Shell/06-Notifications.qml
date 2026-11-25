// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

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
