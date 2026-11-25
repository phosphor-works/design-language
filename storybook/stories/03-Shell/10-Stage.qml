// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import Phosphor.Design
import Phosphor.Storybook
import Phosphor.Storybook.Shell

Story {
    Variant {
        name: "Tiling"

        Stage {
            width: 900
            height: 520
            onPicked: index => current = index
        }
    }

    Variant {
        name: "Scrolling: the strip is wider than the screen"

        Stage {
            width: 900
            height: 520
            onPicked: index => current = index
            current: 3
            selected: 2
            mode: "scrolling"
        }
    }

    Variant {
        name: "Snapping"

        Stage {
            width: 900
            height: 520
            onPicked: index => current = index
            current: 3
            mode: "snapping"
        }
    }
}
