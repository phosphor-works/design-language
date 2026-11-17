// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import Phosphor.Design
import Phosphor.Storybook
import Phosphor.Storybook.Apps

Story {
    Variant {
        name: "Style"

        SettingsWindow {}
    }

    Variant {
        name: "Wallpaper, with a change to apply"

        SettingsWindow {
            page: "wallpaper"
            Component.onCompleted: set("wallpaper", "After hours")
        }
    }

    Variant {
        name: "Bar"

        SettingsWindow {
            page: "bar"
            focused: false
        }
    }

    Variant {
        name: "Presets"

        SettingsWindow {
            page: "presets"
        }
    }
}
