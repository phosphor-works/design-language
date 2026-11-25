// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import Phosphor.Design
import Phosphor.Storybook
import Phosphor.Storybook.Shell

Story {
    Variant {
        name: "Main page"

        PanelFrame {
            QuickPanel {}
        }
    }

    Variant {
        name: "Wi-Fi"

        PanelFrame {
            QuickPanel {
                page: "wifi"
            }
        }
    }

    Variant {
        name: "Wi-Fi, a network asks for its password"

        PanelFrame {
            QuickPanel {
                page: "wifi"
                asking: "Studio"
            }
        }
    }

    Variant {
        name: "Wi-Fi, a network connects"

        PanelFrame {
            QuickPanel {
                page: "wifi"
                connecting: "Cafe guest"
            }
        }
    }

    Variant {
        name: "Wi-Fi off"

        PanelFrame {
            QuickPanel {
                page: "wifi"
                wifiOn: false
            }
        }
    }

    Variant {
        name: "Bluetooth"

        PanelFrame {
            QuickPanel {
                page: "bluetooth"
            }
        }
    }

    Variant {
        name: "Bluetooth, a device pairs"

        PanelFrame {
            QuickPanel {
                page: "bluetooth"
                pairing: "Phone"
            }
        }
    }

    Variant {
        name: "Sound, output"

        PanelFrame {
            QuickPanel {
                page: "sound"
            }
        }
    }

    Variant {
        name: "Sound, input"

        PanelFrame {
            QuickPanel {
                page: "sound"
                soundTab: "input"
            }
        }
    }

    Variant {
        name: "Sound, apps"

        PanelFrame {
            QuickPanel {
                page: "sound"
                soundTab: "apps"
            }
        }
    }
}
