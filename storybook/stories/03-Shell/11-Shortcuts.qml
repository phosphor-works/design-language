// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import Phosphor.Design
import Phosphor.Storybook
import Phosphor.Storybook.Shell

Story {
    Variant {
        name: "One mode"

        ShortcutsSheet {}
    }

    Variant {
        name: "A search in all modes"

        ShortcutsSheet {
            query: "focus"
        }
    }

    Variant {
        name: "No match"

        ShortcutsSheet {
            query: "zed"
        }
    }
}
