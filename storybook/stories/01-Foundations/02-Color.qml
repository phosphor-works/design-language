// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import Phosphor.Design
import Phosphor.Storybook

// This page reads each value from Theme. If you change a color in Theme, the page changes.
Doc {
    id: doc

    readonly property var dark: Theme.palettes.dark
    readonly property var light: Theme.palettes.light

    function rows(names: var, uses: var): var {
        return names.map((name, i) => [Theme[name].toString(), name, doc.dark[name].toUpperCase(), doc.light[name].toUpperCase(), uses[i]]);
    }

    // One row of the pair table: the two colors, the measured contrast and the necessary contrast.
    function pairing(what: string, front: color, back: color, needs: real): var {
        const ratio = Theme.contrast(front, back);
        return [what, ratio.toFixed(1) + " : 1", needs + " : 1", ratio >= needs ? "Passes" : "Fails"];
    }

    readonly property var table: [
        {
            "title": "",
            "width": 56,
            "swatch": true
        },
        {
            "title": "Token",
            "width": 110
        },
        {
            "title": "Dark",
            "width": 110,
            "mono": true
        },
        {
            "title": "Light",
            "width": 110,
            "mono": true
        },
        {
            "title": "Means",
            "width": 420
        }
    ]

    Para {
        text: "A surface is dark and does not move. Color shows a state: focus, selection, activity or an error. Remove a color that does not show a state."
    }

    Heading {
        text: "Brand colors"
    }
    Para {
        text: "There are four brand colors, and two colors that show only a result. In the light scheme each color is darker, so that white ink is readable on it."
    }
    Spec {
        columns: doc.table
        rows: doc.rows(["blue", "cyan", "purple", "rose", "green", "amber"], ["Action and selection. The default accent.", "Focus and activity: the focus ring, the focused window, a cursor.", "A second selection near the first selection: a drop target, the other window of a swap.", "An error, a destructive action or an unread item. Do not use rose as decoration.", "A good result, for example a test that passes. Do not use green for a control that is on.", "A state that the user must know about: caps lock, a low battery."])
    }
    Para {
        text: "The user selects one of the four brand colors as the accent. A component reads Theme.accent and does not read a brand color by its name. There are two exceptions: cyan always shows focus, and rose always shows danger."
    }

    Heading {
        text: "Grounds"
    }
    Para {
        text: "A ground is a background color. There are six grounds, from the back to the front. To show depth, use the next ground and a 1 px line. Do not use a shadow."
    }
    Spec {
        columns: doc.table
        rows: doc.rows(["desktop", "sidebar", "surface", "card", "field", "track"], ["The background of the screen. In the dark scheme, ink has the same value.", "The navigation column of a window.", "The background of a window, and the color of the shell body.", "A group of related rows on a window.", "A text field, and a button that the user does not touch.", "The part of a control that has no accent: a switch that is off, the empty part of a slider."])
    }

    Para {
        text: "The shell has a material: glass or solid. The shell body and each panel use Theme.shellSurface, which is the surface color with that material. With glass, a small part of the desktop shows through, and the compositor adds the blur. A window of an app is always solid."
    }

    Heading {
        text: "Text"
    }
    Spec {
        columns: doc.table
        rows: doc.rows(["text", "muted", "ink"], ["Names and values. All text that the user reads or presses.", "A less important value, an icon that is not active, a page that is not open.", "Text and icons on an accent fill. Do not use Theme.text on an accent fill."])
    }

    Heading {
        text: "States"
    }
    Spec {
        columns: [
            {
                "title": "",
                "width": 56,
                "swatch": true
            },
            {
                "title": "Token",
                "width": 110
            },
            {
                "title": "Value",
                "width": 220,
                "mono": true
            },
            {
                "title": "Means",
                "width": 420
            }
        ]
        rows: [[Theme.hover.toString(), "hover", doc.dark.hover + "  " + doc.light.hover, "A layer on the item that is below the pointer."], [Theme.selected.toString(), "selected", "accent at " + Theme.selectedAlpha * 100 + "%", "The current row of a list. The row keeps Theme.text."], [Theme.line.toString(), "line", doc.dark.line + "  " + doc.light.line, "The edge between two grounds, " + Metrics.lineWidth + " px."], [Theme.shade.toString(), "shade", doc.dark.shade + "  " + doc.light.shade, "Behind a modal surface."], ["transparent", "disabled", "opacity " + Theme.disabled, "A control that the user cannot use. The control also ignores the pointer."]]
    }

    Heading {
        text: "Color pairs"
    }
    Para {
        text: "The table shows the contrast for the scheme and the accent in the toolbar. Text must have a contrast of 4.5 to 1. The part that identifies a control (a knob, a fill, a ring) must have 3 to 1 against the area around it."
    }
    Spec {
        columns: [
            {
                "title": "Pair",
                "width": 260
            },
            {
                "title": "Measures",
                "width": 120,
                "mono": true
            },
            {
                "title": "Needs",
                "width": 120,
                "mono": true
            },
            {
                "title": "",
                "width": 120
            }
        ]
        rows: [doc.pairing("Text on surface", Theme.text, Theme.surface, 4.5), doc.pairing("Text on card", Theme.text, Theme.card, 4.5), doc.pairing("Text on field", Theme.text, Theme.field, 4.5), doc.pairing("Muted on surface", Theme.muted, Theme.surface, 4.5), doc.pairing("Muted on card", Theme.muted, Theme.card, 4.5), doc.pairing("Muted on sidebar", Theme.muted, Theme.sidebar, 4.5), doc.pairing("Ink on the accent", Theme.ink, Theme.accent, 4.5), doc.pairing("Ink on rose", Theme.ink, Theme.rose, 4.5), doc.pairing("Accent as text on surface", Theme.accent, Theme.surface, 4.5), doc.pairing("Rose as text on card", Theme.danger, Theme.card, 4.5), doc.pairing("Focus ring on surface", Theme.focus, Theme.surface, 3), doc.pairing("Accent fill on track", Theme.accent, Theme.track, 3), doc.pairing("Knob on track", Theme.muted, Theme.track, 3)]
    }
    Para {
        text: "A track is a ground and not an outline. Its color is near the color of the card. The knob, the fill or the label identifies the control, and the table measures those pairs."
    }

    Heading {
        text: "Rules"
    }
    Para {
        text: "When a small control is on, its fill is the accent and its content is ink. The current row of a list has the Theme.selected tint and keeps its text color."
    }
    Row {
        spacing: Metrics.gapLoose

        Button {
            text: "Accent fill, ink"
            highlighted: true
        }
        Rectangle {
            width: 220
            height: Metrics.navRowHeight
            radius: Metrics.radiusControl
            color: Theme.selected

            Label {
                anchors.verticalCenter: parent.verticalCenter
                leftPadding: Metrics.padRow
                text: "Tinted row, text"
                font.weight: Metrics.weightStrong
            }
        }
    }
    Para {
        text: "A preset or a wallpaper can replace the palette. It sets Theme.palette with the role names of matugen: background, surface_container_low, surface_container, surface, surface_container_high, surface_container_highest, primary, on_primary, on_surface and on_surface_variant. The roles brand_stop_0 to brand_stop_3 replace the spectrum. A role that the palette does not contain keeps the brand value. The Settings story has the Paper preset and the Ember preset of phosphor-theme."
    }
    Para {
        text: "The spectrum is the gradient of the four brand colors. The spectrum is the brand and does not show a state. Use it only on the edge of the shell body, in the visualizer of the sound and in the logos."
    }
    Para {
        text: "Do not use color as the only signal. A tile that is on is also rounder. A chosen row also has a check. An error also has an icon."
    }
    Para {
        text: "A component does not contain a color value. If a role is missing, add the role to Theme for the two schemes."
    }
}
