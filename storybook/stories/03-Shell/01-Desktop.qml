// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import Phosphor.Design
import Phosphor.Storybook.Shell

// The shell as one scene: the bar, and each panel that opens from it.
//
// Press a chip, and the drawer opens from that chip. Press a different chip while the drawer is
// open, and the same drawer moves to it and changes size. A detail page, an open row and a
// dismissed card change the size of the same drawer.
//
// The buttons at the bottom do what a key or an app does. They send a volume key, a notification
// and the shortcuts key, and they ask for a password. "Lock" in the power panel shows the lock
// screen.
Item {
    id: scene

    property bool fill: true
    // In a capture, no user presses a chip, so the story opens the quick settings.
    property string panel: Session.capture ? "quick" : ""
    property date now: new Date()
    // A surface that does not open from the bar: "shortcuts", "password" or "lock".
    property string overlay

    readonly property var _hosts: ({
            "launcher": launcherHost,
            "overview": overviewHost,
            "calendar": calendarHost,
            "media": mediaHost,
            "tray": trayHost,
            "stats": statsHost,
            "quick": quickHost,
            "inbox": inboxHost,
            "power": powerHost,
            "osd": osdHost,
            "toast": toastHost
        })

    function toggle(name: string) {
        panel = panel === name ? "" : name;
    }

    // Shows a panel for a short time. A panel that the user opened stays.
    function flash(name: string, time: int) {
        if (panel !== "" && panel !== "osd" && panel !== "toast")
            return;
        panel = name;
        closeTimer.interval = time * Motion.slow;
        closeTimer.restart();
    }

    onPanelChanged: {
        if (panel === "launcher")
            launcher.takeFocus();
        if (panel !== "osd" && panel !== "toast")
            closeTimer.stop();
    }

    Keys.onEscapePressed: {
        panel = "";
        if (overlay !== "lock")
            overlay = "";
    }

    Timer {
        id: closeTimer

        onTriggered: scene.panel = ""
    }

    Timer {
        interval: 10000
        repeat: true
        running: true
        onTriggered: scene.now = new Date()
    }

    // The content of one panel inside the drawer. Only the content of the open panel is visible.
    component Host: Item {
        id: host

        property Item chip
        property bool current: false
        default property alias content: slot.data
        readonly property Item panel: slot.children.length > 0 ? slot.children[0] : null

        width: panel ? panel.width : 0
        implicitHeight: panel ? panel.implicitHeight : 0
        opacity: current ? 1 : 0
        visible: opacity > 0

        Behavior on opacity {
            Fade {}
        }

        Item {
            id: slot
        }
    }

    // A wallpaper: a brand color on the desktop ground.
    Rectangle {
        anchors.fill: parent
        color: Theme.desktop

        Rectangle {
            x: parent.width * 0.5
            y: -parent.height * 0.2
            width: parent.width * 0.7
            height: width
            radius: width / 2
            opacity: 0.16
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: Theme.blue
                }
                GradientStop {
                    position: 1
                    color: "transparent"
                }
            }
        }

        TapHandler {
            onTapped: scene.panel = ""
        }
    }

    Item {
        id: windows

        anchors.fill: parent
        anchors.margins: Metrics.screenInset
        anchors.topMargin: Metrics.barHeight + 2 * Metrics.surfaceGap
        anchors.bottomMargin: 64

        WindowFrame {
            width: (parent.width - Metrics.surfaceGap) * 0.58
            height: parent.height
            icon: "edit"
            title: "Shell.qml"
            focused: true
        }
        WindowFrame {
            anchors.right: parent.right
            width: (parent.width - Metrics.surfaceGap) * 0.42
            height: (parent.height - Metrics.surfaceGap) / 2
            icon: "globe"
            title: "Firefox"
        }
        WindowFrame {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            width: (parent.width - Metrics.surfaceGap) * 0.42
            height: (parent.height - Metrics.surfaceGap) / 2
            icon: "terminal"
            title: "Afterglow"
        }
    }

    ShellBody {
        id: body

        readonly property Item active: scene._hosts[scene.panel] ?? null
        // The drawer keeps the size of its last panel while it closes.
        property Item shown: null

        anchors.fill: parent
        fused: fusedChoice.value === "fused"
        open: active !== null
        source: active ? active.chip : (shown ? shown.chip : statusChip)
        contentWidth: shown ? shown.width : 0
        contentHeight: shown ? shown.implicitHeight : 0
        onActiveChanged: if (active)
            shown = active

        barContent: [
            Row {
                x: Metrics.space8
                height: parent.height
                spacing: Metrics.space4

                BarChip {
                    id: markChip

                    anchors.verticalCenter: parent.verticalCenter
                    text: "Launcher"
                    active: scene.panel === "launcher"
                    onClicked: scene.toggle("launcher")

                    Icon {
                        anchors.verticalCenter: parent.verticalCenter
                        name: "phosphor"
                        size: Metrics.iconLarge - 2
                        color: Theme.cyan
                    }
                }

                WorkspaceStrip {
                    id: workspaces

                    anchors.verticalCenter: parent.verticalCenter
                    count: overview.workspaces.length
                    occupied: overview.workspaces.map((workspace, index) => workspace.windows.length > 0 ? index : -1)
                    onPicked: index => current = index
                }

                // The layout of the current workspace. It opens the overview.
                BarChip {
                    id: layoutChip

                    anchors.verticalCenter: parent.verticalCenter
                    text: "Overview"
                    active: scene.panel === "overview"
                    onClicked: scene.toggle("overview")

                    LayoutPreview {
                        anchors.verticalCenter: parent.verticalCenter
                        width: 28
                        height: 18
                        windowColor: layoutChip.ink
                        windows: overview.arrange(overview.workspaces[overview.current].windows, overview.mode)
                    }
                }
            },
            BarChip {
                id: clockChip

                anchors.centerIn: parent
                text: "Calendar"
                label: Qt.formatTime(scene.now, "HH:mm")
                active: scene.panel === "calendar"
                onClicked: scene.toggle("calendar")
            },
            Row {
                anchors.right: parent.right
                anchors.rightMargin: Metrics.space8
                height: parent.height
                spacing: Metrics.space4

                BarChip {
                    id: mediaChip

                    anchors.verticalCenter: parent.verticalCenter
                    text: "Media"
                    active: scene.panel === "media"
                    onClicked: scene.toggle("media")

                    Artwork {
                        anchors.verticalCenter: parent.verticalCenter
                        size: 20
                        radius: Metrics.radiusInner
                        source: media.art
                        tone: media.tone
                        asynchronous: !Session.capture
                    }
                    Visualizer {
                        anchors.verticalCenter: parent.verticalCenter
                        width: 44
                        height: 16
                        count: 10
                        running: media.playing
                        animated: !Session.capture
                    }
                }
                BarChip {
                    id: trayChip

                    anchors.verticalCenter: parent.verticalCenter
                    text: "Background apps"
                    icons: ["tray"]
                    alert: true
                    active: scene.panel === "tray"
                    onClicked: scene.toggle("tray")
                }
                BarChip {
                    id: statsChip

                    anchors.verticalCenter: parent.verticalCenter
                    text: "System"
                    icons: ["chip"]
                    label: stats.stats[0].value
                    active: scene.panel === "stats"
                    onClicked: scene.toggle("stats")
                }
                BarChip {
                    id: statusChip

                    anchors.verticalCenter: parent.verticalCenter
                    text: "Quick settings"
                    icons: [quick.wifiOn ? "wifi" : "wifiOff", quick.volume === 0 ? "volumeMute" : quick.volume < 0.5 ? "volumeLow" : "volume", "battery"]
                    active: scene.panel === "quick"
                    onClicked: scene.toggle("quick")
                }
                BarChip {
                    id: bellChip

                    anchors.verticalCenter: parent.verticalCenter
                    text: "Notifications"
                    icons: [quick.quiet ? "bellOff" : "bell"]
                    alert: inbox.count > 0 && !quick.quiet
                    active: scene.panel === "inbox"
                    onClicked: scene.toggle("inbox")
                }
                BarChip {
                    id: powerChip

                    anchors.verticalCenter: parent.verticalCenter
                    text: "Power"
                    icons: ["power"]
                    active: scene.panel === "power"
                    onClicked: scene.toggle("power")
                }
            }
        ]

        Host {
            id: launcherHost

            chip: markChip
            current: body.shown === launcherHost && body.open

            LauncherPanel {
                id: launcher

                onLaunched: scene.panel = ""
            }
        }
        Host {
            id: overviewHost

            chip: layoutChip
            current: body.shown === overviewHost && body.open

            OverviewPanel {
                id: overview

                current: workspaces.current
                onPicked: index => workspaces.current = index
            }
        }
        Host {
            id: calendarHost

            chip: clockChip
            current: body.shown === calendarHost && body.open

            CalendarPanel {
                today: scene.now
                events: [
                    {
                        "date": scene.now,
                        "time": "11:00",
                        "title": "Shell design review"
                    },
                    {
                        "date": scene.now,
                        "time": "15:30",
                        "title": "Focus time"
                    }
                ]
            }
        }
        Host {
            id: mediaHost

            chip: mediaChip
            current: body.shown === mediaHost && body.open

            MediaPanel {
                id: media

                onToggled: playing = !playing
            }
        }
        Host {
            id: trayHost

            chip: trayChip
            current: body.shown === trayHost && body.open

            TrayPanel {}
        }
        Host {
            id: statsHost

            chip: statsChip
            current: body.shown === statsHost && body.open

            StatsPanel {
                id: stats
            }
        }
        Host {
            id: quickHost

            chip: statusChip
            current: body.shown === quickHost && body.open
            // The panel opens on its main page each time.
            onCurrentChanged: if (!current)
                quick.page = "main"

            QuickPanel {
                id: quick
            }
        }
        Host {
            id: inboxHost

            chip: bellChip
            current: body.shown === inboxHost && body.open

            InboxPanel {
                id: inbox

                quiet: quick.quiet
            }
        }
        Host {
            id: powerHost

            chip: powerChip
            current: body.shown === powerHost && body.open
            onCurrentChanged: if (!current)
                power.asking = ""

            PowerPanel {
                id: power

                onChosen: name => {
                    scene.panel = "";
                    if (name === "Lock")
                        scene.overlay = "lock";
                }
            }
        }
        Host {
            id: osdHost

            chip: statusChip
            current: body.shown === osdHost && body.open

            OsdPanel {
                icon: quick.volume === 0 ? "volumeMute" : quick.volume < 0.5 ? "volumeLow" : "volume"
                value: quick.volume
            }
        }
        Host {
            id: toastHost

            chip: bellChip
            current: body.shown === toastHost && body.open

            NotificationCard {
                width: 330
                flat: true
                icon: "chat"
                tone: Theme.purple
                title: "Maya"
                body: "The shell body looks right now"
                time: "now"
                onPressed: scene.panel = "inbox"
                onDismissed: scene.panel = ""
            }
        }
    }

    Row {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: Metrics.space20
        spacing: Metrics.gapLoose

        Segmented {
            id: fusedChoice

            label: "Panels"
            options: [
                {
                    "value": "fused",
                    "text": "Fused"
                },
                {
                    "value": "detached",
                    "text": "Detached"
                }
            ]
            value: "fused"
        }
        Button {
            text: "Volume key"
            onClicked: {
                quick.volume = quick.volume >= 0.95 ? 0 : Math.min(1, quick.volume + 0.1);
                scene.flash("osd", 1400);
            }
        }
        Button {
            text: "Notification"
            onClicked: scene.flash("toast", 4000)
        }
        Button {
            text: "Shortcuts"
            onClicked: {
                scene.panel = "";
                scene.overlay = "shortcuts";
            }
        }
        Button {
            text: "Password"
            onClicked: {
                scene.panel = "";
                password.phase = "prompt";
                scene.overlay = "password";
            }
        }
    }

    // The surfaces that do not open from the bar. A dialog that the system opens has no control, so
    // it opens in the center, on a shade.
    Rectangle {
        anchors.fill: parent
        color: Theme.shade
        opacity: scene.overlay === "shortcuts" || scene.overlay === "password" ? 1 : 0
        visible: opacity > 0

        Behavior on opacity {
            Fade {}
        }

        TapHandler {
            onTapped: scene.overlay = ""
        }
    }

    ShortcutsSheet {
        readonly property bool shown: scene.overlay === "shortcuts"

        anchors.centerIn: parent
        scale: shown ? 1 : 0.94
        opacity: shown ? 1 : 0
        visible: opacity > 0

        Behavior on scale {
            FlowSpring {
                epsilon: 0.002
            }
        }
        Behavior on opacity {
            Fade {}
        }
    }

    AuthDialog {
        id: password

        readonly property bool shown: scene.overlay === "password"

        anchors.centerIn: parent
        scale: shown ? 1 : 0.94
        opacity: shown ? 1 : 0
        visible: opacity > 0
        // This sample accepts a password of four characters or more.
        onAccepted: text => {
            phase = "checking";
            passwordTimer.good = text.length >= 4;
            passwordTimer.restart();
        }
        onCancelled: scene.overlay = ""

        Behavior on scale {
            FlowSpring {
                epsilon: 0.002
            }
        }
        Behavior on opacity {
            Fade {}
        }

        Timer {
            id: passwordTimer

            property bool good: false

            interval: 900 * Motion.slow
            onTriggered: {
                if (password.phase === "checking") {
                    password.phase = good ? "done" : "error";
                    if (good)
                        restart();
                } else if (password.phase === "done") {
                    scene.overlay = "";
                }
            }
        }
    }

    LockScreen {
        id: lock

        anchors.fill: parent
        now: scene.now
        opacity: scene.overlay === "lock" ? 1 : 0
        visible: opacity > 0
        onAccepted: {
            phase = "checking";
            lockTimer.restart();
        }

        Behavior on opacity {
            Fade {}
        }

        Timer {
            id: lockTimer

            interval: 700 * Motion.slow
            onTriggered: {
                lock.phase = "idle";
                scene.overlay = "";
            }
        }
    }
}
