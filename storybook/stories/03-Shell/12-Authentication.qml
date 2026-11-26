// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import Phosphor.Design
import Phosphor.Storybook
import Phosphor.Storybook.Shell

Story {
    Variant {
        name: "Prompt"

        AuthDialog {
            onAccepted: phase = "error"
        }
    }

    Variant {
        name: "Checking"

        AuthDialog {
            phase: "checking"
        }
    }

    Variant {
        name: "Wrong password"

        AuthDialog {
            phase: "error"
            onAccepted: phase = "done"
        }
    }

    Variant {
        name: "Correct password"

        AuthDialog {
            phase: "done"
        }
    }

    Variant {
        name: "More than one account can approve"

        AuthDialog {
            accounts: ["maya", "root", "sam"]
            phase: "accounts"
        }
    }

    Variant {
        name: "A code in place of a password"

        AuthDialog {
            method: "code"
        }
    }

    Variant {
        name: "The details of the request"

        AuthDialog {
            showDetails: true
        }
    }

    Variant {
        name: "A long action, with no item"

        AuthDialog {
            app: "Facet"
            appIcon: "tune"
            action: "Change the time, the date and the time zone of this computer"
            target: ""
        }
    }

    Variant {
        name: "The service does not answer"

        AuthDialog {
            phase: "unavailable"
            onRetried: phase = "prompt"
        }
    }
}
