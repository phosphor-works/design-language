// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

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
