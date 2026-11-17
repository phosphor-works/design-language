// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import Phosphor.Design
import Phosphor.Storybook

Story {
    Variant {
        name: "Setting"

        Slider {
            from: 0
            to: 24
            value: 10
        }
    }

    Variant {
        name: "Empty"

        Slider {
            value: 0
        }
    }

    Variant {
        name: "Shell"
        surface: true

        BigSlider {
            width: 300
            iconName: "volume"
            label: ""
            value: 0.62
        }
    }

    Variant {
        name: "Shell, named"
        surface: true

        BigSlider {
            width: 300
            iconName: "music"
            label: "Music"
            value: 0.84
        }
    }
}
