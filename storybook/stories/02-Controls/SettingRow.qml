// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls
import Phosphor.Design
import Phosphor.Storybook

Story {
    Variant {
        name: "A group of settings"

        SettingGroup {
            width: 560

            SettingRow {
                text: "Algorithm"

                Segmented {
                    label: "Algorithm"
                    options: [
                        {
                            "value": "master",
                            "text": "Master stack"
                        },
                        {
                            "value": "spiral",
                            "text": "Spiral"
                        },
                        {
                            "value": "columns",
                            "text": "Columns"
                        }
                    ]
                    value: "master"
                }
            }
            SettingRow {
                text: "Master ratio"

                Slider {
                    from: 50
                    to: 66
                    value: 58
                }
            }
            SettingRow {
                text: "Smart gaps"

                Switch {
                    Accessible.name: "Smart gaps"
                }
            }
        }
    }

    Variant {
        name: "One setting"

        SettingGroup {
            width: 560

            SettingRow {
                text: "Accent"

                SwatchPicker {
                    value: "blue"
                }
            }
        }
    }

    Variant {
        name: "A long name gives way to its control"

        SettingGroup {
            width: 380

            SettingRow {
                text: "Restore the size that a window had before the snap"

                Switch {
                    checked: true
                    Accessible.name: "Restore size"
                }
            }
        }
    }
}
