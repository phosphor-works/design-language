// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import Phosphor.Storybook

Story {
    Variant {
        name: "Tab bar"
        surface: true

        TabBar {
            TabButton {
                text: "phosphor"
            }
            TabButton {
                text: "Shell.qml"
            }
            TabButton {
                text: "ctest"
            }
        }
    }
}
