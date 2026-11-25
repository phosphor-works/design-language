// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

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
