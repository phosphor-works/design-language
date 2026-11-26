// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import Phosphor.Design
import Phosphor.Storybook

Doc {
    id: doc

    // The scale, from Metrics: name, size, line height, weight, sample, use.
    readonly property var scale: [["Display", Metrics.textDisplay, Metrics.lineDisplay, Metrics.weightBody, "10:24", "The clock of the lock screen. No other text uses this size."], ["Title", Metrics.textTitle, Metrics.lineTitle, Metrics.weightStrong, "Tiling", "The name of a page. Use one title in a window."], ["Heading", Metrics.textHeading, Metrics.lineHeading, Metrics.weightStrong, "Home network", "The name of the item that a surface shows."], ["Row", Metrics.textRow, Metrics.lineRow, Metrics.weightBody, "Studio 5G", "Text that the user reads to make a choice: list rows, text fields."], ["Body", Metrics.textBody, Metrics.lineBody, Metrics.weightBody, "Master ratio", "The default size: settings, messages, and buttons at weight 600."], ["Label", Metrics.textLabel, Metrics.lineLabel, Metrics.weightStrong, "Comfortable", "Inside a compact control: a segment, a tab, a key."], ["Caption", Metrics.textCaption, Metrics.lineCaption, Metrics.weightBody, "18m", "A time stamp or a count. This is the smallest text."]]

    Para {
        text: "There are six text sizes and two weights. Do not use a size that is not in the scale. The display size is a seventh size, and only the clock of the lock screen uses it."
    }

    Heading {
        text: "Fonts"
    }
    Spec {
        columns: [
            {
                "title": "Role",
                "width": 140
            },
            {
                "title": "Asks for",
                "width": 200
            },
            {
                "title": "Found here",
                "width": 200
            },
            {
                "title": "Used for",
                "width": 380
            }
        ]
        rows: [["Interface", "Manrope", Metrics.fontUi, "All text that is not a value in a column and not a line of code."], ["Mono", "JetBrains Mono", Metrics.fontMono, "Values that change or that align in a column: a percentage, a key, a path. Also the terminal."]]
    }
    Para {
        text: "The repository does not contain the fonts. Metrics uses the first installed font from a short list. Thus the guide shows the fonts that an app gets on this computer."
    }

    Heading {
        text: "Scale"
    }
    Column {
        width: parent.width

        Repeater {
            model: doc.scale

            Column {
                id: step

                required property var modelData

                width: parent.width

                Rectangle {
                    width: parent.width
                    height: Metrics.lineWidth
                    color: Theme.line
                }

                Row {
                    topPadding: Metrics.space10
                    bottomPadding: Metrics.space10

                    Text {
                        width: 90
                        anchors.baseline: sample.baseline
                        text: step.modelData[0]
                        color: Theme.text
                        font.family: Metrics.fontUi
                        font.pixelSize: Metrics.textBody
                        font.weight: Metrics.weightStrong
                    }
                    Text {
                        width: 130
                        anchors.baseline: sample.baseline
                        text: step.modelData[1] + " / " + step.modelData[2] + "   " + (step.modelData[3] === Metrics.weightStrong ? "600" : "500")
                        color: Theme.muted
                        font.family: Metrics.fontMono
                        font.pixelSize: Metrics.textLabel
                    }
                    Text {
                        id: sample

                        width: 250
                        text: step.modelData[4]
                        color: Theme.text
                        font.family: Metrics.fontUi
                        font.pixelSize: step.modelData[1]
                        font.weight: step.modelData[3]
                    }
                    Text {
                        width: 420
                        anchors.baseline: sample.baseline
                        wrapMode: Text.Wrap
                        text: step.modelData[5]
                        color: Theme.muted
                        font.family: Metrics.fontUi
                        font.pixelSize: Metrics.textBody
                    }
                }
            }
        }
    }
    Para {
        text: "The second number is the line height. Set a paragraph on its line height. Then two lines of body text are " + 2 * Metrics.lineBody + " px high, and a paragraph aligns with the spacing ramp."
    }

    Heading {
        text: "Weight"
    }
    Spec {
        columns: [
            {
                "title": "Weight",
                "width": 140
            },
            {
                "title": "Used for",
                "width": 600
            }
        ]
        rows: [["500", "Paragraphs, values, and a row that is not chosen."], ["600", "A name, a title, and each item that the user can press: a button, a tab, a page in a sidebar."]]
    }
    Para {
        text: "There is no light weight, no bold weight and no italic. To show emphasis, change the weight from 500 to 600, or change the color from muted to text. Do not change the size and the weight together."
    }

    Heading {
        text: "Rules"
    }
    Para {
        text: "Use sentence case: \"Do not disturb\", \"Shut down\". Do not use capital letters for emphasis. Do not use uppercase labels or letter spacing. Only the title has letter spacing, of -0.3 px."
    }
    Para {
        text: "Text in a control is one line. If the text is too long, it ends with an ellipsis. Only a message, the text of a notification, or a paragraph can wrap. The maximum width of such text is " + Metrics.readingWidth + " px."
    }
    Para {
        text: "Text starts at the left edge of its container. Use the mono font for a number that the user compares with the number above it. Align such a number to the right. Center only the label of a button and the clock."
    }
    Para {
        text: "Color shows the other levels of importance. Use text for important items and muted for less important items. Use the accent only for the chosen row."
    }
}
