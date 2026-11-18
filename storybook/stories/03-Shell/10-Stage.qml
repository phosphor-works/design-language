// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

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
