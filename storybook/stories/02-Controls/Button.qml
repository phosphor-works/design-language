// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls
import Phosphor.Storybook

Story {
    Variant {
        name: "Default"

        Button {
            text: "Discard"
        }
    }

    Variant {
        name: "Lit"

        Button {
            text: "Apply"
            highlighted: true
        }
    }

    Variant {
        name: "Quiet"

        Button {
            text: "Cancel"
            flat: true
        }
    }

    Variant {
        name: "Disabled"

        Button {
            text: "Apply"
            highlighted: true
            enabled: false
        }
    }
}
