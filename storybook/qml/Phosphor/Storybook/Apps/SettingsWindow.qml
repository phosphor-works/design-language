// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import Phosphor.Design

// The settings app: the navigation at the left, one page at the right, and a bar that appears when
// there is a change to apply.
//
// A change shows immediately in the full interface, so the interface is the preview. The bar then
// offers "Discard" and "Apply". A page has one title and its cards. It has no tagline, no sentence
// below a setting and no second column of help. The Style page changes the real theme of the
// storybook.
WindowFrame {
    id: root

    property string page: "style"
    // The values that the user applied, and the values that the controls show.
    property var saved: root._defaults
    property var draft: root._defaults
    readonly property bool dirty: JSON.stringify(saved) !== JSON.stringify(draft)
    // Changes that the window starts with, as if the user made them. A story uses this to show a
    // state.
    property var start: ({})
    // False keeps a change in this window. The window then does not change the theme of the
    // interface around it.
    property bool live: true

    // The presets of phosphor-theme (AppearanceStore::presetValues and ShellPalette::fromSettings in
    // phosphor-shell-libs). A preset is a palette and a small number of settings. The grounds, the
    // text colors and the four stops are the values of that library. It has three grounds, so
    // the field and the track here are steps from its card color. Phosphor keeps the brand palette
    // of this repository.
    readonly property var presets: [
        {
            "id": "phosphor",
            "name": "Phosphor",
            "values": {
                "scheme": "dark",
                "accent": "blue",
                "corners": 16,
                "spread": 10,
                "density": "comfortable",
                "edge": "top",
                "media": true,
                "glow": true
            },
            "palette": ({})
        },
        {
            "id": "paper",
            "name": "Paper",
            "values": {
                "scheme": "light",
                "corners": 24,
                "spread": 22,
                "glow": false
            },
            "palette": {
                "background": "#e1e8f4",
                "surface_container_low": "#e1e8f4",
                "surface_container": "#eef2fa",
                "surface": "#dce3ef",
                "surface_container_high": "#d0d9e8",
                "surface_container_highest": "#c3cee0",
                "on_surface": "#172740",
                "on_surface_variant": "#4d607a",
                "primary": "#49739d",
                "on_primary": "#eef2fa",
                "brand_stop_0": "#49739d",
                "brand_stop_1": "#6c63aa",
                "brand_stop_2": "#a2577d",
                "brand_stop_3": "#955a39"
            }
        },
        {
            "id": "ember",
            "name": "Ember",
            "values": {
                "scheme": "dark",
                "corners": 8,
                "spread": 10,
                "density": "compact",
                "edge": "bottom",
                "media": false,
                "glow": false
            },
            "palette": {
                "background": "#1c1e1b",
                "surface_container_low": "#1c1e1b",
                "surface_container": "#272620",
                "surface": "#403c32",
                "surface_container_high": "#4d483c",
                "surface_container_highest": "#5a5446",
                "on_surface": "#eee9dc",
                "on_surface_variant": "#b6b1a4",
                "primary": "#e8c988",
                "on_primary": "#1c1e1b",
                "brand_stop_0": "#e8c988",
                "brand_stop_1": "#d4b08a",
                "brand_stop_2": "#d3906c",
                "brand_stop_3": "#d27b83"
            }
        }
    ]
    readonly property var wallpapers: [
        {
            "name": "Soft orbit",
            "source": Qt.resolvedUrl("../../../../assets/cover-awake.jpg"),
            "colors": ["#22D3EE", "#3B82F6", "#7C3AED", "#A855F7"]
        },
        {
            "name": "After hours",
            "source": Qt.resolvedUrl("../../../../assets/cover-a-walk.jpg"),
            "colors": ["#F43F5E", "#A855F7", "#3B82F6", "#0E7490"]
        },
        {
            "name": "Plain",
            "source": "",
            "colors": []
        }
    ]

    readonly property var _defaults: ({
            "preset": "phosphor",
            "scheme": "dark",
            "accent": "blue",
            "corners": 16,
            "spread": 10,
            "density": "comfortable",
            "glow": true,
            "wallpaper": "Soft orbit",
            "fit": "fill",
            "follow": false,
            "edge": "top",
            "fused": true,
            "media": true,
            "stats": "numbers",
            "visualizer": "bars"
        })

    // The style values start from the toolbar of the storybook. They are read one time: a binding
    // to them would put back the saved values after each change.
    Component.onCompleted: {
        const first = Object.assign({}, _defaults);
        for (const key of ["scheme", "accent", "corners", "density", "glow"])
            first[key] = Session.globals[key];
        saved = first;
        draft = first;
        for (const key in start)
            set(key, start[key]);
    }

    // Changes one value of the draft and shows it in the interface.
    function set(key: string, value: var) {
        const next = Object.assign({}, draft);
        next[key] = value;
        // A preset also sets the values that are a part of it.
        if (key === "preset")
            Object.assign(next, presets.find(entry => entry.id === value).values);
        draft = next;
        _show(draft);
    }

    function _show(values: var) {
        if (!live)
            return;
        for (const key of ["scheme", "accent", "corners", "density", "glow"])
            Session.setGlobal(key, values[key]);
        Metrics.spread = values.spread;
        Theme.palette = _palette(values);
    }

    // The palette of the preset. When the shell follows the wallpaper, the colors of the wallpaper
    // replace the accent and the spectrum. Each ground also gets a small part of the first color.
    function _palette(values: var): var {
        const palette = Object.assign({}, presets.find(entry => entry.id === values.preset).palette);
        const colors = wallpapers.find(entry => entry.name === values.wallpaper).colors;
        if (!values.follow || colors.length < 4)
            return palette;
        const grounds = Theme.palettes[values.scheme === "light" ? "light" : "dark"];
        const roles = {
            "background": "desktop",
            "surface_container_low": "sidebar",
            "surface_container": "surface",
            "surface": "card",
            "surface_container_high": "field",
            "surface_container_highest": "track"
        };
        for (const role in roles)
            palette[role] = Qt.tint(palette[role] ?? grounds[roles[role]], Theme.tint(colors[0], 0.07));
        // The light scheme needs a darker accent, so that the ink on it stays readable.
        palette.primary = values.scheme === "light" ? Qt.darker(colors[1], 1.5) : colors[1];
        colors.forEach((color, index) => palette["brand_stop_" + index] = color);
        return palette;
    }

    function discard() {
        draft = saved;
        _show(saved);
    }

    function apply() {
        saved = draft;
    }

    implicitWidth: 940
    implicitHeight: 600
    icon: "facet"
    title: "Settings"
    focused: true

    // The palette of a preset is a value of the Theme, which lives longer than this window.
    Component.onDestruction: {
        Theme.palette = ({});
        Metrics.spread = _defaults.spread;
    }

    component Page: Column {
        width: Math.min(pageArea.width - 2 * Metrics.pageMargin, Metrics.pageWidth)
        spacing: Metrics.gapLoose
    }

    component Choice: Segmented {
        required property string key

        value: root.draft[key]
        onPicked: value => root.set(key, value)
    }

    component Toggle: Switch {
        required property string key

        checked: root.draft[key]
        onToggled: root.set(key, checked)
    }

    Rectangle {
        id: side

        width: Metrics.sidebarWidth
        height: parent.height
        color: Theme.sidebar

        TextField {
            id: search

            x: Metrics.pad
            y: Metrics.space4
            width: parent.width - 2 * Metrics.pad
            leftPadding: Metrics.space12 + Metrics.iconSize + Metrics.iconGap
            placeholderText: "Search"

            Icon {
                x: Metrics.space12
                anchors.verticalCenter: parent.verticalCenter
                name: "search"
                color: search.activeFocus ? Theme.focus : Theme.muted
            }
        }

        NavList {
            x: Metrics.space8
            y: search.y + search.height + Metrics.gap
            width: parent.width - 2 * Metrics.space8
            filter: search.text
            current: root.page
            onPicked: id => root.page = id
            model: [
                {
                    "text": "Appearance",
                    "children": [
                        {
                            "id": "style",
                            "text": "Style",
                            "icon": "drop"
                        },
                        {
                            "id": "wallpaper",
                            "text": "Wallpaper",
                            "icon": "image"
                        },
                        {
                            "id": "bar",
                            "text": "Bar",
                            "icon": "bar"
                        },
                        {
                            "id": "presets",
                            "text": "Presets",
                            "icon": "folder"
                        }
                    ]
                },
                {
                    "text": "Placement",
                    "children": [
                        {
                            "id": "snapping",
                            "text": "Snapping",
                            "icon": "zones"
                        },
                        {
                            "id": "tiling",
                            "text": "Tiling",
                            "icon": "tiling"
                        },
                        {
                            "id": "scrolling",
                            "text": "Scrolling",
                            "icon": "scrolling"
                        }
                    ]
                }
            ]
        }
    }

    Item {
        id: pageArea

        anchors.left: side.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: applyBar.top
        clip: true

        Text {
            id: heading

            x: Metrics.pageMargin
            y: Metrics.space8
            text: ({
                    "style": "Style",
                    "wallpaper": "Wallpaper",
                    "bar": "Bar",
                    "presets": "Presets",
                    "snapping": "Snapping",
                    "tiling": "Tiling",
                    "scrolling": "Scrolling"
                })[root.page]
            color: Theme.text
            font.family: Metrics.fontUi
            font.pixelSize: Metrics.textTitle
            font.weight: Metrics.weightStrong
        }

        Loader {
            x: Metrics.pageMargin
            y: heading.y + heading.height + Metrics.gapSection
            sourceComponent: ({
                    "style": stylePage,
                    "wallpaper": wallpaperPage,
                    "bar": barPage,
                    "presets": presetsPage
                })[root.page] ?? placementPage
        }
    }

    // The bar for a change that the user did not apply. It has no sentence: the two buttons tell
    // what the user can do.
    Rectangle {
        id: applyBar

        anchors.left: side.right
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: root.dirty ? Metrics.barHeight + Metrics.space12 : 0
        color: Theme.card
        clip: true

        Behavior on height {
            enabled: !Session.capture

            FlowSpring {}
        }

        Row {
            anchors.right: parent.right
            anchors.rightMargin: Metrics.pageMargin
            y: (Metrics.barHeight + Metrics.space12 - height) / 2
            spacing: Metrics.gap

            Button {
                flat: true
                text: "Discard"
                onClicked: root.discard()
            }
            Button {
                highlighted: true
                text: "Apply"
                onClicked: root.apply()
            }
        }
    }

    Component {
        id: stylePage

        Page {
            SettingGroup {
                width: parent.width

                SettingRow {
                    text: "Scheme"

                    Choice {
                        key: "scheme"
                        label: "Scheme"
                        options: [
                            {
                                "value": "dark",
                                "text": "Dark"
                            },
                            {
                                "value": "light",
                                "text": "Light"
                            }
                        ]
                    }
                }
                SettingRow {
                    text: "Accent"

                    SwatchPicker {
                        value: root.draft.accent
                        onPicked: value => root.set("accent", value)
                    }
                }
            }

            SettingGroup {
                width: parent.width

                SettingRow {
                    text: "Corners"

                    Slider {
                        width: 220
                        from: 0
                        to: 24
                        stepSize: 2
                        value: root.draft.corners
                        onMoved: root.set("corners", value)
                    }
                }
                SettingRow {
                    text: "Gap between windows"

                    Slider {
                        width: 220
                        from: 0
                        to: 24
                        stepSize: 2
                        value: root.draft.spread
                        onMoved: root.set("spread", value)
                    }
                }
                SettingRow {
                    text: "Density"

                    Choice {
                        key: "density"
                        label: "Density"
                        options: [
                            {
                                "value": "comfortable",
                                "text": "Comfortable"
                            },
                            {
                                "value": "compact",
                                "text": "Compact"
                            }
                        ]
                    }
                }
            }
        }
    }

    Component {
        id: wallpaperPage

        Page {
            Row {
                spacing: Metrics.gapLoose

                Repeater {
                    model: root.wallpapers

                    T.AbstractButton {
                        id: tile

                        required property var modelData
                        readonly property bool chosen: modelData.name === root.draft.wallpaper

                        width: 176
                        height: 110 + Metrics.space8 + Metrics.lineLabel
                        scale: down ? Metrics.pressScale : 1
                        onClicked: root.set("wallpaper", modelData.name)

                        Accessible.name: modelData.name

                        Behavior on scale {
                            SnapSpring {
                                epsilon: 0.002
                            }
                        }

                        contentItem: Item {
                            Artwork {
                                id: picture

                                width: parent.width
                                height: 110
                                radius: Metrics.radiusCard
                                source: tile.modelData.source
                                icon: "image"
                                tone: Theme.muted
                                asynchronous: !Session.capture
                            }
                            // The chosen wallpaper has the accent edge.
                            Rectangle {
                                anchors.fill: picture
                                radius: Metrics.radiusCard
                                color: "transparent"
                                border.width: Metrics.focusWidth
                                border.color: Theme.accent
                                opacity: tile.chosen ? 1 : 0

                                Behavior on opacity {
                                    Fade {}
                                }
                            }
                            Text {
                                anchors.top: picture.bottom
                                anchors.topMargin: Metrics.space8
                                width: parent.width
                                horizontalAlignment: Text.AlignHCenter
                                text: tile.modelData.name
                                color: tile.chosen ? Theme.text : Theme.muted
                                font.family: Metrics.fontUi
                                font.pixelSize: Metrics.textLabel
                                font.weight: tile.chosen ? Metrics.weightStrong : Metrics.weightBody
                            }
                        }

                        background: Item {
                            FocusRing {
                                target: tile
                                around: Metrics.radiusCard
                            }
                        }
                    }
                }
            }

            SettingGroup {
                width: parent.width

                SettingRow {
                    text: "Fit"

                    Choice {
                        key: "fit"
                        label: "Fit"
                        options: [
                            {
                                "value": "fill",
                                "text": "Fill"
                            },
                            {
                                "value": "fit",
                                "text": "Fit"
                            },
                            {
                                "value": "center",
                                "text": "Center"
                            }
                        ]
                    }
                }
                SettingRow {
                    text: "Colors from the wallpaper"

                    Row {
                        spacing: Metrics.gapLoose

                        // The colors that the shell gets from the chosen wallpaper.
                        Row {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: Metrics.space4

                            Repeater {
                                model: root.wallpapers.find(entry => entry.name === root.draft.wallpaper).colors

                                Rectangle {
                                    required property string modelData

                                    width: 16
                                    height: 16
                                    radius: root.draft.follow ? 8 : Metrics.radiusInner
                                    color: modelData
                                    opacity: root.draft.follow ? 1 : 0.4

                                    Behavior on radius {
                                        FlowSpring {}
                                    }
                                }
                            }
                        }

                        Toggle {
                            key: "follow"
                        }
                    }
                }
            }
        }
    }

    Component {
        id: barPage

        Page {
            SettingGroup {
                width: parent.width

                SettingRow {
                    text: "Position"

                    Choice {
                        key: "edge"
                        label: "Position"
                        options: [
                            {
                                "value": "top",
                                "text": "Top"
                            },
                            {
                                "value": "bottom",
                                "text": "Bottom"
                            }
                        ]
                    }
                }
                SettingRow {
                    text: "Panels join the bar"

                    Toggle {
                        key: "fused"
                    }
                }
            }

            SettingGroup {
                width: parent.width

                SettingRow {
                    text: "Media"

                    Toggle {
                        key: "media"
                    }
                }
                SettingRow {
                    text: "Visualizer"

                    Choice {
                        key: "visualizer"
                        label: "Visualizer"
                        enabled: root.draft.media
                        opacity: enabled ? 1 : Theme.disabled
                        options: [
                            {
                                "value": "bars",
                                "text": "Bars"
                            },
                            {
                                "value": "ribbon",
                                "text": "Ribbon"
                            },
                            {
                                "value": "halo",
                                "text": "Halo"
                            },
                            {
                                "value": "off",
                                "text": "Off"
                            }
                        ]
                    }
                }
                SettingRow {
                    text: "System load"

                    Choice {
                        key: "stats"
                        label: "System load"
                        options: [
                            {
                                "value": "numbers",
                                "text": "Numbers"
                            },
                            {
                                "value": "meters",
                                "text": "Meters"
                            },
                            {
                                "value": "traces",
                                "text": "Traces"
                            },
                            {
                                "value": "off",
                                "text": "Off"
                            }
                        ]
                    }
                }
            }
        }
    }

    Component {
        id: presetsPage

        Page {
            SettingGroup {
                width: parent.width

                Repeater {
                    model: root.presets

                    ListRow {
                        required property var modelData

                        width: parent.width
                        icon: "drop"
                        text: modelData.name
                        selected: modelData.id === root.draft.preset
                        onClicked: root.set("preset", modelData.id)
                    }
                }
            }

            Button {
                text: "Save the current style as a preset"
            }
        }
    }

    Component {
        id: placementPage

        Page {
            SettingGroup {
                width: parent.width

                SettingRow {
                    text: "Gap between windows"

                    Slider {
                        width: 220
                        from: 0
                        to: 24
                        stepSize: 2
                        value: 8
                    }
                }
                SettingRow {
                    text: "Gap at the screen edge"

                    Slider {
                        width: 220
                        from: 0
                        to: 24
                        stepSize: 2
                        value: 12
                    }
                }
                SettingRow {
                    text: "Smart gaps"

                    Switch {}
                }
            }
        }
    }
}
