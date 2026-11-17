// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import Phosphor.Design
import Phosphor.Storybook

Doc {
    Para {
        text: "These rules are requirements. A component that does not obey a rule is not complete."
    }

    Heading {
        text: "Contrast"
    }
    Para {
        text: "Text has a contrast of 4.5 to 1 or more against its ground. This applies in the two schemes and with each of the four accents. The part that identifies a control has 3 to 1 or more. The Color page measures each pair that the components use. Use Theme.contrast(a, b) to measure a new pair."
    }
    Para {
        text: "Thus an accent fill uses ink and not the text color. Almost-white text on the blue brand color has a contrast of approximately 3.5 to 1. Ink has a contrast of " + Theme.contrast(Theme.ink, Theme.accent).toFixed(1) + " to 1 on the current accent."
    }

    Heading {
        text: "A second signal for each color"
    }
    Para {
        text: "Each state that color shows has a second signal. A control that is on is also rounder. A chosen row also has a check. An error also has an icon and a message. Focus is a ring and not a tint."
    }

    Heading {
        text: "Keyboard"
    }
    Para {
        text: "The user can go to each pressable item with Tab, and can press it with Space or Return. A group that is one choice is one Tab stop, for example a segmented control or a tab bar. The arrow keys move inside the group."
    }
    Para {
        text: "Focus is always visible. The focus ring is " + Metrics.focusWidth + " px wide, has the focus color, and is " + Metrics.focusOffset + " px from the control. The keyboard shows the ring, and the pointer does not. Press Tab on this page to see the ring."
    }
    Row {
        spacing: Metrics.gapLoose

        Button {
            text: "Discard"
        }
        Button {
            text: "Apply"
            highlighted: true
        }
        Switch {
            Accessible.name: "Example"
        }
        Segmented {
            label: "Example"
            options: [
                {
                    "value": "a",
                    "text": "Snap"
                },
                {
                    "value": "b",
                    "text": "Tile"
                },
                {
                    "value": "c",
                    "text": "Scroll"
                }
            ]
            value: "a"
        }
    }
    Para {
        text: "Escape closes the open surface. Focus then goes back to the control that opened the surface."
    }

    Heading {
        text: "Targets"
    }
    Para {
        text: "Each item that the user can press has a minimum size of " + Metrics.targetMin + " px in width and in height. The drawing can be smaller than the target. An icon button draws " + Metrics.iconSmall + " px in a " + Metrics.targetMin + " px square. Two targets do not overlap. Adjacent targets in a row have a minimum of " + Metrics.space2 + " px between them."
    }

    Heading {
        text: "Names"
    }
    Para {
        text: "A control that shows no text has a name for a screen reader. Examples are an icon button, a switch in a settings row, and a slider. The name tells what the control is, with the same words that the interface uses in other places. An icon that is only decoration has no name."
    }

    Heading {
        text: "Motion"
    }
    Para {
        text: "An app sets Motion.reduced when the system requests reduced motion. Then a spring gets to its target almost immediately and does not overshoot. Fades stay, because a fade does not move an item. Only a spinner can loop. Do not make an item flash."
    }
    Para {
        text: "Do not use motion as the only signal. If a drawer opens from the bell, the bell also has the accent color while the drawer is open."
    }

    Heading {
        text: "Text size"
    }
    Para {
        text: "If text in a control is too long, it ends with an ellipsis. Text does not stop in the middle of a letter. A row becomes taller before its text overlaps its control. The smallest text is " + Metrics.textCaption + " px. Use it for a time stamp or a count. Do not use it for text that the user must read to do a task."
    }
}
