// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

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
        name: "Wallpaper, the shell follows its colors"

        SettingsWindow {
            page: "wallpaper"
            live: false
            start: ({
                    "wallpaper": "After hours",
                    "follow": true
                })
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
