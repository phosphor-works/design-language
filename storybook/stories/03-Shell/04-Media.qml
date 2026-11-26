// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import Phosphor.Design
import Phosphor.Storybook
import Phosphor.Storybook.Shell

Story {
    Variant {
        name: "Playing, bars"

        PanelFrame {
            MediaPanel {
                onToggled: playing = !playing
            }
        }
    }

    Variant {
        name: "Playing, ribbon"

        PanelFrame {
            MediaPanel {
                visualizer: "ribbon"
                title: "A Walk"
                position: 0.71
                art: Qt.resolvedUrl("../../assets/cover-a-walk.jpg")
                onToggled: playing = !playing
            }
        }
    }

    Variant {
        name: "Playing, halo"

        PanelFrame {
            MediaPanel {
                visualizer: "halo"
                onToggled: playing = !playing
            }
        }
    }

    Variant {
        name: "Paused"

        PanelFrame {
            MediaPanel {
                playing: false
                onToggled: playing = !playing
            }
        }
    }

    Variant {
        name: "No cover and no visualizer"

        PanelFrame {
            MediaPanel {
                art: ""
                visualizer: "off"
                title: "Podcast episode 212"
                artist: "Interconnects"
                tone: Theme.cyan
                onToggled: playing = !playing
            }
        }
    }

    Variant {
        name: "Nothing plays"

        PanelFrame {
            MediaPanel {
                hasMedia: false
            }
        }
    }
}
