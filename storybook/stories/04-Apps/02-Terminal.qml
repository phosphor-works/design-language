// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import Phosphor.Design
import Phosphor.Storybook
import Phosphor.Storybook.Apps

Story {
    Variant {
        name: "Focused, three tabs"

        TerminalWindow {
            focused: true
            onTabPicked: index => tab = index
        }
    }

    Variant {
        name: "Not focused, one tab"

        TerminalWindow {
            tabs: ["shell-design"]
        }
    }
}
