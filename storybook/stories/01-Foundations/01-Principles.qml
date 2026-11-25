// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import Phosphor.Storybook

Doc {
    Heading {
        text: "Color shows a state"
    }
    Para {
        text: "A surface is dark and does not move. Use color only to show a state: focus, selection, activity or an error. Do not use color as decoration."
    }

    Heading {
        text: "A panel opens from its control"
    }
    Para {
        text: "A panel opens from the control that the user pressed. The panel closes into the same control. A panel does not appear in an empty area of the screen."
    }

    Heading {
        text: "Springs move, fades color"
    }
    Para {
        text: "A move starts immediately and stops on a spring. A color changes with a fade. The edge of the shell body becomes bright immediately, and then its glow fades slowly."
    }

    Heading {
        text: "Name, value or action"
    }
    Para {
        text: "Each string gives the name of an item, shows a value or tells what a control does. Remove all other text. Do not write an eyebrow, a tagline or a helper sentence. Use an icon when the icon gives the same information. Put an explanation in a tooltip."
    }

    Heading {
        text: "Show the state"
    }
    Para {
        text: "Show a state with a preview, a fill level or a position. Do not write a sentence that describes the state."
    }
}
