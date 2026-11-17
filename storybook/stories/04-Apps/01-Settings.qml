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
            start: ({
                    "wallpaper": "After hours"
                })
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

    Variant {
        name: "Bar, after the Ember preset: the bottom edge, no media"

        SettingsWindow {
            page: "bar"
            live: false
            start: ({
                    "preset": "ember"
                })
        }
    }
}
