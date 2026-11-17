// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import Phosphor.Design
import Phosphor.Storybook

Doc {
    id: doc

    property bool there: false

    component Run: Row {
        id: run

        property string name
        property real spring
        property real damping

        spacing: Metrics.space20

        Text {
            width: 60
            anchors.verticalCenter: parent.verticalCenter
            text: run.name
            color: Theme.text
            font.family: Metrics.fontMono
            font.pixelSize: Metrics.textLabel
        }

        Rectangle {
            width: 360
            height: 26
            radius: 13
            color: Theme.track

            Rectangle {
                x: doc.there ? parent.width - width - 3 : 3
                y: 3
                width: 20
                height: 20
                radius: 10
                color: Theme.accent

                Behavior on x {
                    SpringAnimation {
                        spring: run.spring
                        damping: run.damping
                        epsilon: 0.05
                    }
                }
            }
        }
    }

    Para {
        text: "An item that has a position moves on a spring. An item that has a color changes with a fade. The motion and speed settings in the toolbar change each number on this page."
    }

    Heading {
        text: "Springs"
    }
    Para {
        text: "A spring has no duration. It has a frequency, omega, that sets its speed. It has a damping ratio, zeta, that sets its overshoot. At a zeta of 1 there is no overshoot, and a lower value gives more overshoot. If a spring gets a new target during a move, it keeps its speed and turns. An animation with a duration stops and starts again."
    }
    Spec {
        columns: [
            {
                "title": "Token",
                "width": 90
            },
            {
                "title": "Omega",
                "width": 80,
                "mono": true
            },
            {
                "title": "Zeta",
                "width": 80,
                "mono": true
            },
            {
                "title": "Use it through",
                "width": 130,
                "mono": true
            },
            {
                "title": "For",
                "width": 420
            }
        ]
        rows: [["snap", Motion.snapOmega.toFixed(1), Motion.snapZeta.toFixed(2), "SnapSpring", "A press, a toggle, a small item below the pointer."], ["flow", Motion.flowOmega.toFixed(1), Motion.flowZeta.toFixed(2), "FlowSpring", "A surface that opens, a radius that changes, the leading edge of a selection."], ["trail", Motion.trailOmega.toFixed(1), Motion.trailZeta.toFixed(2), "TrailSpring", "The trailing edge of a selection, content that follows its surface."]]
    }
    Run {
        name: "snap"
        spring: Motion.snapSpring
        damping: Motion.snapDamping
    }
    Run {
        name: "flow"
        spring: Motion.flowSpring
        damping: Motion.flowDamping
    }
    Run {
        name: "trail"
        spring: Motion.trailSpring
        damping: Motion.trailDamping
    }
    Button {
        text: "Play"
        highlighted: true
        onClicked: doc.there = !doc.there
    }
    Para {
        text: "Press Play two times quickly. Each dot turns at its position and keeps its speed."
    }

    Heading {
        text: "Fades"
    }
    Spec {
        columns: [
            {
                "title": "Token",
                "width": 110
            },
            {
                "title": "Now",
                "width": 80,
                "mono": true
            },
            {
                "title": "Use it through",
                "width": 130,
                "mono": true
            },
            {
                "title": "For",
                "width": 440
            }
        ]
        rows: [["fade", Motion.fade + " ms", "Tint, Fade", "A color that changes with a state, content that appears in a surface."], ["fadeFast", Motion.fadeFast + " ms", "", "A popup or a tooltip that appears or disappears."], ["glowFade", Motion.glowFade + " ms", "", "The glow on the edge of the shell body, after the shell body changes shape."]]
    }
    Para {
        text: "A fade eases out. A color appears quickly and disappears slowly."
    }

    Heading {
        text: "The motion of each change"
    }
    Spec {
        columns: [
            {
                "title": "The change",
                "width": 280
            },
            {
                "title": "Runs on",
                "width": 480
            }
        ]
        rows: [["The user presses a control", "It scales to " + Metrics.pressScale + " on snap, and returns to 1 on release."], ["The user operates a switch", "The knob moves on snap. The knob is wider while the user holds it."], ["A selection moves", "The stretch indicator: its leading edge on flow, its trailing edge on trail."], ["A control goes on", "Its color fades. If its radius changes, the radius moves on flow."], ["A panel opens", "Its width moves on flow, and its height follows. Then its content fades in."], ["A list opens or closes", "Its height moves on flow. The rows below move with it."], ["The user drags a value", "No animation. The fill follows the pointer exactly."], ["An item changes color", "fade."]]
    }

    Heading {
        text: "The four moves"
    }
    Para {
        text: "Grow. A surface opens from the control that the user pressed, and closes into the same control. A surface does not appear in the middle of the screen. The Shell body story shows this move."
    }
    Para {
        text: "Stretch. A selection does not jump, and it does not move as a block. Its front edge moves first and its rear edge follows. Thus the selection becomes longer in the direction of the move."
    }
    Segmented {
        label: "Placement"
        options: [
            {
                "value": "snap",
                "text": "Snap"
            },
            {
                "value": "tile",
                "text": "Tile"
            },
            {
                "value": "scroll",
                "text": "Scroll"
            },
            {
                "value": "float",
                "text": "Float"
            }
        ]
        value: "snap"
    }
    Para {
        text: "Press. A control becomes smaller while the pointer presses it. On release, a spring returns the control to its size."
    }
    Row {
        spacing: Metrics.gapLoose

        Button {
            text: "Apply"
            highlighted: true
        }
        Switch {
            Accessible.name: "Example"
        }
    }
    Para {
        text: "Glow. When the shell body changes shape, its edge becomes bright immediately. The glow fades in " + Motion.glowFade + " ms."
    }

    Heading {
        text: "Rules"
    }
    Para {
        text: "Do not use an animation with a duration on a position, a size, a radius or a scale. Use a spring for each of these."
    }
    Para {
        text: "An item moves only when the user causes the move. A spinner is the exception. Do not play an animation when a window opens. Do not use a loop to get attention."
    }
    Para {
        text: "Do not use motion as the only signal of a change. With reduced motion, the interface must give the same information."
    }
    Para {
        text: "A preset changes only zeta. Calm sets each zeta to 1 or more, so there is no overshoot. Lively decreases each zeta. Use the quarter speed only to examine a move."
    }
}
