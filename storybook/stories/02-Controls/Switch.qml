// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import Phosphor.Storybook

Story {
    Variant {
        name: "Off"

        Switch {}
    }

    Variant {
        name: "On"

        Switch {
            checked: true
        }
    }

    Variant {
        name: "With a name"

        Switch {
            text: "Smart gaps"
            checked: true
        }
    }

    Variant {
        name: "Disabled"

        Switch {
            checked: true
            enabled: false
        }
    }
}
