// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import Phosphor.Design
import Phosphor.Storybook

Story {
    Variant {
        name: "Message"
        surface: true

        NotificationCard {
            icon: "folder"
            title: "Files"
            body: "12 items copied to Archive"
            time: "18m"
            onPressed: expanded = !expanded
        }
    }

    Variant {
        name: "Stack of three"
        surface: true

        NotificationCard {
            icon: "chat"
            tone: Theme.purple
            title: "Maya"
            body: "Left notes on the lock screen spacing"
            count: 3
        }
    }

    Variant {
        name: "Needs attention"
        surface: true

        NotificationCard {
            icon: "lock"
            tone: Theme.danger
            title: "Backup"
            body: "Archive drive disconnected"
            time: "1h"
        }
    }

    Variant {
        name: "With a picture"
        surface: true

        NotificationCard {
            icon: "image"
            title: "Screenshot"
            body: "Saved to Pictures"
            time: "now"
            picture: Qt.resolvedUrl("../../assets/cover-a-walk.jpg")
        }
    }

    Variant {
        name: "Open, with actions"
        surface: true

        NotificationCard {
            icon: "download"
            tone: Theme.cyan
            title: "Updates"
            body: "14 packages are ready to install, including the kernel and the graphics driver. A restart finishes the upgrade."
            time: "now"
            expanded: true

            Button {
                text: "Install"
                highlighted: true
            }
            Button {
                text: "Later"
                flat: true
            }
        }
    }

    Variant {
        name: "Toast"
        surface: true

        NotificationCard {
            icon: "terminal"
            tone: Theme.cyan
            title: "Afterglow"
            body: "ctest finished"
            time: "now"
            flat: true
        }
    }
}
