// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import Phosphor.Design
import Phosphor.Storybook

Story {
    Variant {
        name: "Two options"

        Segmented {
            label: "New windows"
            options: [
                {
                    "value": "master",
                    "text": "Master"
                },
                {
                    "value": "stack",
                    "text": "Stack"
                }
            ]
            value: "stack"
        }
    }

    Variant {
        name: "Four options"

        Segmented {
            label: "Algorithm"
            options: [
                {
                    "value": "master",
                    "text": "Master stack"
                },
                {
                    "value": "spiral",
                    "text": "Spiral"
                },
                {
                    "value": "columns",
                    "text": "Columns"
                },
                {
                    "value": "monocle",
                    "text": "Monocle"
                }
            ]
            value: "master"
        }
    }
}
