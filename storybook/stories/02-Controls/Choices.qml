// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls
import Phosphor.Storybook

Story {
    Variant {
        name: "Check boxes"

        Column {
            spacing: 10

            CheckBox {
                text: "Show zones on all screens"
                checked: true
            }
            CheckBox {
                text: "Restore size on unsnap"
            }
            CheckBox {
                text: "Some windows"
                checkState: Qt.PartiallyChecked
                tristate: true
            }
        }
    }

    Variant {
        name: "Radio buttons"

        Column {
            spacing: 10

            RadioButton {
                text: "Block"
                checked: true
            }
            RadioButton {
                text: "Beam"
            }
            RadioButton {
                text: "Underline"
            }
        }
    }

    Variant {
        name: "Combo box"

        ComboBox {
            width: 190
            model: ["Master stack", "Spiral", "Columns", "Monocle", "Dwindle", "Grid"]
        }
    }
}
