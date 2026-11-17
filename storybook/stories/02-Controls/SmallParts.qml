// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import Phosphor.Design
import Phosphor.Storybook

Story {
    Variant {
        name: "Icon buttons"
        surface: true

        Row {
            spacing: 4

            IconButton {
                iconName: "back"
                text: "Back"
            }
            IconButton {
                iconName: "minimize"
                text: "Minimize"
            }
            IconButton {
                iconName: "maximize"
                text: "Maximize"
            }
            IconButton {
                iconName: "close"
                text: "Close"
            }
        }
    }

    Variant {
        name: "Shortcut"

        Row {
            spacing: 4

            Keycap {
                text: "Meta"
            }
            Keycap {
                text: "Shift"
            }
            Keycap {
                text: "M"
            }
        }
    }

    Variant {
        name: "Meter"

        Column {
            spacing: 12

            Meter {
                value: 0.29
            }
            Meter {
                value: 0.92
                color: Theme.danger
            }
        }
    }

    Variant {
        name: "Sparkline"
        surface: true

        Sparkline {
            width: 180
            values: [0.3, 0.34, 0.31, 0.42, 0.38, 0.52, 0.47, 0.44, 0.61, 0.5, 0.46, 0.4, 0.43, 0.58, 0.49, 0.41, 0.36, 0.39]
        }
    }

    Variant {
        name: "Progress"

        Column {
            spacing: 12

            ProgressBar {
                value: 0.6
            }
            ProgressBar {
                indeterminate: !Session.capture
                value: 0.3
            }
        }
    }

    Variant {
        name: "Busy"

        Row {
            spacing: 14

            Spinner {}
            BusyIndicator {
                running: true
            }
        }
    }

    Variant {
        name: "Accent"

        SwatchPicker {
            value: "purple"
        }
    }
}
