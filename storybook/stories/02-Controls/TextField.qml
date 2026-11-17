// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import Phosphor.Storybook

Story {
    Variant {
        name: "Empty"

        TextField {
            width: 260
            placeholderText: "Search"
        }
    }

    Variant {
        name: "Filled"

        TextField {
            width: 260
            text: "Master stack"
        }
    }

    Variant {
        name: "Password"

        TextField {
            width: 260
            echoMode: TextInput.Password
            text: "phosphor"
        }
    }

    Variant {
        name: "Disabled"

        TextField {
            width: 260
            placeholderText: "Search"
            enabled: false
        }
    }
}
