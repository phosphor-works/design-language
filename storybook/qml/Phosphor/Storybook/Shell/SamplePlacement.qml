// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

pragma Singleton
import QtQuick

// Sample workspaces, and a sample of what the placement engine does. The real shell gets the
// positions of the windows from the engine. This object gives each mode a different look, so that
// the overview and the stage have real pictures to show.
QtObject {
    // Each workspace: { name, windows }. Each window: { icon, title, focused }.
    readonly property var workspaces: [
        {
            "name": "Develop",
            "windows": [
                {
                    "icon": "edit",
                    "title": "Shell.qml",
                    "focused": true
                },
                {
                    "icon": "globe",
                    "title": "Firefox"
                },
                {
                    "icon": "terminal",
                    "title": "Afterglow"
                }
            ]
        },
        {
            "name": "Build",
            "windows": [
                {
                    "icon": "terminal",
                    "title": "cmake"
                },
                {
                    "icon": "terminal",
                    "title": "ctest"
                }
            ]
        },
        {
            "name": "",
            "windows": []
        },
        {
            "name": "Listen",
            "windows": [
                {
                    "icon": "music",
                    "title": "Music"
                },
                {
                    "icon": "folder",
                    "title": "Files"
                },
                {
                    "icon": "globe",
                    "title": "Firefox"
                },
                {
                    "icon": "terminal",
                    "title": "Afterglow"
                },
                {
                    "icon": "chat",
                    "title": "Messages"
                },
                {
                    "icon": "tune",
                    "title": "Settings"
                }
            ]
        }
    ]

    // The windows with a position each, as `x`, `y`, `w` and `h`. A value is a part of the screen,
    // from 0 to 1. In the scrolling mode the strip is wider than the screen, so `x` can be above 1.
    // `fit` makes the strip fit the screen, for a small picture.
    function arrange(windows: var, mode: string, fit = true): var {
        const count = windows.length;
        return windows.map((window, index) => {
            let box;
            if (mode === "scrolling") {
                const width = fit ? Math.min(0.42, 1 / Math.max(1, count)) : count > 2 ? 0.42 : 1 / Math.max(1, count);
                box = [index * width, 0, width, 1];
            } else if (mode === "snapping") {
                const columns = Math.min(3, Math.max(1, count));
                const rows = Math.ceil(count / columns);
                box = [(index % columns) / columns, Math.floor(index / columns) / rows, 1 / columns, 1 / rows];
            } else if (count === 1) {
                box = [0, 0, 1, 1];
            } else if (index === 0) {
                box = [0, 0, 0.58, 1];
            } else {
                box = [0.58, (index - 1) / (count - 1), 0.42, 1 / (count - 1)];
            }
            return {
                "icon": window.icon,
                "title": window.title ?? "",
                "focused": window.focused === true,
                "x": box[0],
                "y": box[1],
                "w": box[2],
                "h": box[3]
            };
        });
    }
}
