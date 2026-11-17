// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import Phosphor.Design
import Phosphor.Storybook
import Phosphor.Storybook.Shell

Story {
    Variant {
        name: "In the bar: numbers, meters, traces"
        surface: true

        Row {
            spacing: Metrics.space4

            StatsChip {}
            StatsChip {
                style: "meters"
            }
            StatsChip {
                style: "traces"
            }
        }
    }

    Variant {
        name: "All resources"

        PanelFrame {
            StatsPanel {}
        }
    }

    Variant {
        name: "A resource with a history, open"

        PanelFrame {
            StatsPanel {
                open: "cpu"
            }
        }
    }

    Variant {
        name: "A resource with a level, open"

        PanelFrame {
            StatsPanel {
                open: "storage"
            }
        }
    }
}
