// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import Phosphor.Design
import Phosphor.Storybook

Doc {
    Para {
        text: "Each string on a surface gives the name of an item, shows a value or tells what a control does. Remove a string that does none of these. The other rules on this page apply this rule."
    }

    Heading {
        text: "Text to remove"
    }
    DoDont {
        good: "Wi-Fi"
        bad: "QUICK SETTINGS  ·  Wi-Fi"
        why: "Do not put an eyebrow above a title. An eyebrow is a small label above a title. The surface is the quick settings, so the label gives no information."
    }
    DoDont {
        good: "Home network"
        bad: "Home network. You're online. Make yourself at home."
        why: "Do not write a tagline or a status sentence. The accent fill of the tile shows the connection."
    }
    DoDont {
        good: "Studio 5G, with a lock icon and three bars"
        bad: "Studio 5G  ·  5 GHz · Strong signal · WPA3"
        why: "Use an icon when the icon gives the same information. Put detail that few users need on a detail page."
    }
    DoDont {
        good: "Smart gaps"
        bad: "Smart gaps. Hide the gaps when only one window is open."
        why: "Do not put a helper sentence below a control. If the name is not sufficient, change the name or show a preview. Put an explanation in a tooltip."
    }
    DoDont {
        good: "An empty list, with the bell-off icon"
        bad: "You're all caught up! New notifications will appear here."
        why: "An empty state is an icon. Do not add text to it."
    }
    Para {
        text: "The Wi-Fi panel of the earlier shell mockup contained 19 strings. With this rule it contains five: its title and four network names."
    }

    Heading {
        text: "Names"
    }
    DoDont {
        good: "Night light"
        bad: "Enable night light"
        why: "The name of a switch is a noun for the item that is on. The switch gives the meaning \"enable\"."
    }
    DoDont {
        good: "Apply  ·  Discard  ·  Connect"
        bad: "OK  ·  Cancel changes  ·  Click to connect"
        why: "The label of a button is a verb for the action. Use one word if one word is sufficient."
    }
    DoDont {
        good: "Do not disturb"
        bad: "Do Not Disturb  ·  DO NOT DISTURB"
        why: "Use sentence case. Use a capital letter only for the first word and for names."
    }
    DoDont {
        good: "Tiling"
        bad: "Tiling settings"
        why: "The name of a page is its subject. Each page in a settings app contains settings, so do not write \"settings\"."
    }
    Para {
        text: "Use one name for one item in all places. If the bar shows \"Quick settings\", the shortcut list and the documentation also show \"Quick settings\"."
    }

    Heading {
        text: "Values"
    }
    Spec {
        columns: [
            {
                "title": "Kind",
                "width": 150
            },
            {
                "title": "Written",
                "width": 200,
                "mono": true
            },
            {
                "title": "Rule",
                "width": 420
            }
        ]
        rows: [["Percentage", "58%", "No space before the sign."], ["With a unit", "10 px   4.2 GHz   18.4 GB", "A space, then the unit's symbol."], ["A range", "358 GB free of 1 TB", "Use words, not a slash, when the two values have units."], ["Time of day", "16:54   4:54 PM", "Use the format that the user set. A 12 hour clock has no zero at the start."], ["How long ago", "now   2m   1h   3d", "The shortest form. After one week, show the date."], ["A shortcut", "Meta Shift M", "One keycap for each key, in the sequence that the user holds them."], ["A count", "3", "Only the number, in a chip. Do not write \"3 new\"."]]
    }
    Para {
        text: "Use the mono font for a value that changes, or that is in a column with other values."
    }

    Heading {
        text: "Messages"
    }
    Para {
        text: "Only a message uses a full sentence. A message tells what occurred and what to do. A message ends with a full stop."
    }
    DoDont {
        good: "Archive drive disconnected. Reconnect it to finish the backup."
        bad: "Oops! Something went wrong with your backup."
        why: "Name the item and the next step. Do not apologize. Do not use an exclamation mark or the word \"something\"."
    }
    DoDont {
        good: "Password"
        bad: "Please enter your password to continue"
        why: "The placeholder of a field is the name of its content."
    }

    Heading {
        text: "Punctuation"
    }
    Para {
        text: "Do not put a full stop after a name, a label or the text of a button. Do not put a colon after a label. Use an ellipsis on a button only when the text is too long. Do not use an exclamation mark."
    }
    Para {
        text: "Do not connect clauses with an em dash or a semicolon. Do not use a hyphen as a dash. Write two sentences."
    }
}
