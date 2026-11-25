// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

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
