// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import Phosphor.Design
import Phosphor.Storybook
import Phosphor.Storybook.Shell

Story {
    Variant {
        name: "Centered"

        LockScreen {
            width: 760
            height: 470
            now: new Date(2026, 8, 12, 10, 24)
            onAccepted: phase = "error"
        }
    }

    Variant {
        name: "Split, with the track and the senders"

        LockScreen {
            width: 760
            height: 470
            now: new Date(2026, 8, 12, 10, 24)
            layout: "split"
            media: ({
                    "title": "Awake",
                    "artist": "Tycho",
                    "art": Qt.resolvedUrl("../../assets/cover-awake.jpg"),
                    "playing": true
                })
            senders: [
                {
                    "icon": "chat",
                    "tone": "purple",
                    "title": "Maya"
                },
                {
                    "icon": "disk",
                    "tone": "rose",
                    "title": "Backup"
                }
            ]
        }
    }

    Variant {
        name: "Wrong password, with Caps Lock"

        LockScreen {
            width: 760
            height: 470
            now: new Date(2026, 8, 12, 10, 24)
            phase: "error"
            capsLock: true
            notifications: 0
        }
    }

    Variant {
        name: "Checking, with a low battery"

        LockScreen {
            width: 760
            height: 470
            now: new Date(2026, 8, 12, 10, 24)
            phase: "checking"
            battery: 14
        }
    }
}
