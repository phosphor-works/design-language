// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

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
