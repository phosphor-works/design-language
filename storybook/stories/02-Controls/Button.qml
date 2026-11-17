// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

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
