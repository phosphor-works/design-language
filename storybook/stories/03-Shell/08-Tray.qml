// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import Phosphor.Design
import Phosphor.Storybook
import Phosphor.Storybook.Shell

Story {
    Variant {
        name: "Apps, one needs the user"

        PanelFrame {
            TrayPanel {}
        }
    }

    Variant {
        name: "The menu of an app"

        PanelFrame {
            TrayPanel {
                open: "Nextcloud"
            }
        }
    }

    Variant {
        name: "A submenu"

        PanelFrame {
            TrayPanel {
                open: "Nextcloud"
                submenu: "Pause syncing"
            }
        }
    }

    Variant {
        name: "More apps than the grid shows"

        PanelFrame {
            TrayPanel {
                apps: [
                    {
                        "icon": "cloud",
                        "name": "Nextcloud",
                        "attention": false,
                        "pinned": false,
                        "menu": [["power", "Quit"]]
                    },
                    {
                        "icon": "phone",
                        "name": "KDE Connect",
                        "attention": true,
                        "pinned": false,
                        "menu": [["power", "Quit"]]
                    },
                    {
                        "icon": "record",
                        "name": "OBS Studio",
                        "attention": false,
                        "pinned": false,
                        "menu": [["power", "Quit"]]
                    },
                    {
                        "icon": "key",
                        "name": "KeePassXC",
                        "attention": false,
                        "pinned": false,
                        "menu": [["power", "Quit"]]
                    },
                    {
                        "icon": "sync",
                        "name": "Syncthing",
                        "attention": false,
                        "pinned": false,
                        "menu": [["power", "Quit"]]
                    },
                    {
                        "icon": "download",
                        "name": "qBittorrent",
                        "attention": false,
                        "pinned": false,
                        "menu": [["power", "Quit"]]
                    },
                    {
                        "icon": "game",
                        "name": "Steam",
                        "attention": false,
                        "pinned": false,
                        "menu": [["power", "Quit"]]
                    },
                    {
                        "icon": "chat",
                        "name": "Discord",
                        "attention": false,
                        "pinned": false,
                        "menu": [["power", "Quit"]]
                    },
                    {
                        "icon": "disk",
                        "name": "Backups",
                        "attention": false,
                        "pinned": false,
                        "menu": [["power", "Quit"]]
                    },
                    {
                        "icon": "send",
                        "name": "Mail",
                        "attention": false,
                        "pinned": false,
                        "menu": [["power", "Quit"]]
                    },
                    {
                        "icon": "restart",
                        "name": "Updates",
                        "attention": false,
                        "pinned": false,
                        "menu": [["power", "Quit"]]
                    },
                    {
                        "icon": "lock",
                        "name": "VPN",
                        "attention": false,
                        "pinned": false,
                        "menu": [["power", "Quit"]]
                    }
                ]
            }
        }
    }

    Variant {
        name: "The full grid"

        PanelFrame {
            TrayPanel {
                expanded: true
                apps: [
                    {
                        "icon": "cloud",
                        "name": "Nextcloud",
                        "attention": false,
                        "pinned": false,
                        "menu": [["power", "Quit"]]
                    },
                    {
                        "icon": "phone",
                        "name": "KDE Connect",
                        "attention": true,
                        "pinned": false,
                        "menu": [["power", "Quit"]]
                    },
                    {
                        "icon": "record",
                        "name": "OBS Studio",
                        "attention": false,
                        "pinned": false,
                        "menu": [["power", "Quit"]]
                    },
                    {
                        "icon": "key",
                        "name": "KeePassXC",
                        "attention": false,
                        "pinned": false,
                        "menu": [["power", "Quit"]]
                    },
                    {
                        "icon": "sync",
                        "name": "Syncthing",
                        "attention": false,
                        "pinned": false,
                        "menu": [["power", "Quit"]]
                    },
                    {
                        "icon": "download",
                        "name": "qBittorrent",
                        "attention": false,
                        "pinned": false,
                        "menu": [["power", "Quit"]]
                    },
                    {
                        "icon": "game",
                        "name": "Steam",
                        "attention": false,
                        "pinned": false,
                        "menu": [["power", "Quit"]]
                    },
                    {
                        "icon": "chat",
                        "name": "Discord",
                        "attention": false,
                        "pinned": false,
                        "menu": [["power", "Quit"]]
                    },
                    {
                        "icon": "disk",
                        "name": "Backups",
                        "attention": false,
                        "pinned": false,
                        "menu": [["power", "Quit"]]
                    },
                    {
                        "icon": "send",
                        "name": "Mail",
                        "attention": false,
                        "pinned": false,
                        "menu": [["power", "Quit"]]
                    },
                    {
                        "icon": "restart",
                        "name": "Updates",
                        "attention": false,
                        "pinned": false,
                        "menu": [["power", "Quit"]]
                    },
                    {
                        "icon": "lock",
                        "name": "VPN",
                        "attention": false,
                        "pinned": false,
                        "menu": [["power", "Quit"]]
                    }
                ]
            }
        }
    }

    Variant {
        name: "Two apps"

        PanelFrame {
            TrayPanel {
                apps: [
                    {
                        "icon": "cloud",
                        "name": "Nextcloud",
                        "attention": false,
                        "pinned": true,
                        "menu": []
                    },
                    {
                        "icon": "key",
                        "name": "KeePassXC",
                        "attention": false,
                        "pinned": false,
                        "menu": []
                    }
                ]
            }
        }
    }

    Variant {
        name: "No apps"

        PanelFrame {
            TrayPanel {
                apps: []
            }
        }
    }
}
