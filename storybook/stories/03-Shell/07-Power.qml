// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import Phosphor.Design
import Phosphor.Storybook
import Phosphor.Storybook.Shell

Story {
    Variant {
        name: "Actions"

        PanelFrame {
            PowerPanel {}
        }
    }

    Variant {
        name: "An action asks one time"

        PanelFrame {
            PowerPanel {
                asking: "Restart"
            }
        }
    }

    Variant {
        name: "Volume key"

        PanelFrame {
            OsdPanel {}
        }
    }

    Variant {
        name: "Brightness key"

        PanelFrame {
            OsdPanel {
                icon: "sun"
                value: 0.8
            }
        }
    }

    Variant {
        name: "Muted"

        PanelFrame {
            OsdPanel {
                icon: "volumeMute"
                value: 0
            }
        }
    }
}
