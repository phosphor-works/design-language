// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import Phosphor.Design
import Phosphor.Storybook
import Phosphor.Storybook.Shell

Story {
    Variant {
        name: "The current month, with events"

        PanelFrame {
            CalendarPanel {
                today: new Date(2026, 8, 12)
                events: [
                    {
                        "date": new Date(2026, 8, 12),
                        "time": "11:00",
                        "title": "Shell design review"
                    },
                    {
                        "date": new Date(2026, 8, 12),
                        "time": "15:30",
                        "title": "Focus time"
                    },
                    {
                        "date": new Date(2026, 8, 17),
                        "time": "09:00",
                        "title": "Release"
                    },
                    {
                        "date": new Date(2026, 8, 21),
                        "time": "14:00",
                        "title": "Planning"
                    }
                ]
            }
        }
    }

    Variant {
        name: "A day with no events"

        PanelFrame {
            CalendarPanel {
                today: new Date(2026, 8, 12)
                selected: new Date(2026, 8, 24)
            }
        }
    }

    Variant {
        name: "A different month"

        PanelFrame {
            CalendarPanel {
                today: new Date(2026, 8, 12)
                month: 10
            }
        }
    }
}
