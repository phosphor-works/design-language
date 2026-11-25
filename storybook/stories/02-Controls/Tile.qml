// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import Phosphor.Design
import Phosphor.Storybook

Story {
    Variant {
        name: "Off"
        surface: true

        Tile {
            icon: "moon"
            text: "Do not disturb"
            onToggled: checked = !checked
        }
    }

    Variant {
        name: "On"
        surface: true

        Tile {
            icon: "bulb"
            text: "Night light"
            checked: true
            onToggled: checked = !checked
        }
    }

    Variant {
        name: "On, with a detail page"
        surface: true

        Tile {
            icon: "wifi"
            text: "Home network"
            checked: true
            hasMore: true
            moreLabel: "Networks"
            onToggled: checked = !checked
        }
    }

    Variant {
        name: "Off, with a detail page"
        surface: true

        Tile {
            icon: "bluetooth"
            text: "Bluetooth"
            hasMore: true
            moreLabel: "Devices"
            onToggled: checked = !checked
        }
    }
}
