// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import Phosphor.Storybook
import Phosphor.Widgets

// The components that phosphor-shell-libs ships now, each next to its equivalent in this
// repository. These are the real Phosphor.Widgets components from the PlasmaZones checkout. They
// use their own Phosphor.Theme, so the toolbar above does not change them.
Story {
    Variant {
        name: "PhosphorButton, filled"

        PhosphorButton {
            text: "Apply"
        }
    }

    Variant {
        name: "Button, lit"

        Button {
            text: "Apply"
            highlighted: true
        }
    }

    Variant {
        name: "PhosphorButton, tonal"

        PhosphorButton {
            text: "Discard"
            variant: PhosphorButton.Tonal
        }
    }

    Variant {
        name: "Button"

        Button {
            text: "Discard"
        }
    }

    Variant {
        name: "PhosphorButton, text"

        PhosphorButton {
            text: "Cancel"
            variant: PhosphorButton.Text
        }
    }

    Variant {
        name: "Button, quiet"

        Button {
            text: "Cancel"
            flat: true
        }
    }

    Variant {
        name: "PhosphorSlider"

        PhosphorSlider {
            width: 220
            value: 0.6
        }
    }

    Variant {
        name: "Slider"

        Slider {
            width: 220
            value: 0.6
        }
    }

    Variant {
        name: "PhosphorTextField"

        PhosphorTextField {
            width: 240
            placeholderText: "Search"
        }
    }

    Variant {
        name: "TextField"

        TextField {
            width: 240
            placeholderText: "Search"
        }
    }
}
