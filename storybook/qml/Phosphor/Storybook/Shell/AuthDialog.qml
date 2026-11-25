// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import Phosphor.Design

// The dialog that asks for a password before an app changes the system.
//
// It shows the app, the action, the item that the action changes, and one field. The placeholder of
// the field names the account. A wrong password makes the field rose and moves it. A correct
// password changes the dialog into a check.
//
// When more than one account can approve, the plate of the account opens the list of accounts.
// When the account uses a code, the field takes the code. The small button at the top shows the
// details of the request. The dialog has no "Authentication" line, no sentence that tells the user
// to authenticate, and no key hints.
Surface {
    id: root

    property string app: "Kate"
    property string appIcon: "edit"
    property string action: "Save a protected file"
    property string target: "/etc/hosts"
    property string user: "maya"
    property var accounts: ["maya"] // the accounts that can approve the request
    property string method: "password" // password, or code
    property string phase: "prompt" // prompt, accounts, checking, error, done, unavailable
    property bool showDetails: false
    property var details: [["Action", "org.kde.ktexteditor.katetextbuffer.save"], ["Vendor", "KDE"]]

    signal accepted(string password)
    signal cancelled
    signal retried

    readonly property real _inner: width - 2 * padding
    readonly property bool _choosing: phase === "accounts"
    property real _shake: 0
    property bool _jump: false

    width: 380
    // A Surface gets its size from each item inside, also from an item that is not visible.
    height: (phase === "done" ? done.height : form.height) + 2 * padding
    padding: Metrics.padCard

    onPhaseChanged: if (phase === "error") {
        // The field starts away from its position and the spring moves it back.
        _jump = true;
        _shake = Metrics.space12;
        _jump = false;
        _shake = 0;
        field.selectAll();
    }

    Behavior on _shake {
        enabled: !root._jump

        SpringAnimation {
            spring: Motion.springFor(Motion.snapOmega, 0.25)
            damping: Motion.dampingFor(Motion.snapOmega, 0.25)
            epsilon: 0.05
        }
    }
    Behavior on height {
        enabled: !Session.capture

        FlowSpring {}
    }

    Column {
        id: form

        width: root._inner
        spacing: Metrics.gapLoose
        visible: root.phase !== "done"

        Row {
            spacing: Metrics.gapLoose

            Avatar {
                id: appPlate

                icon: root.appIcon
                name: root.app
                tone: Theme.cyan
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter
                width: root._inner - appPlate.width - more.width - 2 * parent.spacing
                spacing: Metrics.space2

                Text {
                    width: parent.width
                    text: root.action
                    wrapMode: Text.Wrap
                    maximumLineCount: 2
                    elide: Text.ElideRight
                    color: Theme.text
                    font.family: Metrics.fontUi
                    font.pixelSize: Metrics.textHeading
                    font.weight: Metrics.weightStrong
                }
                Text {
                    width: parent.width
                    text: root.app
                    elide: Text.ElideRight
                    color: Theme.muted
                    font.family: Metrics.fontUi
                    font.pixelSize: Metrics.textLabel
                    font.weight: Metrics.weightBody
                }
            }

            IconButton {
                id: more

                iconName: "chevronDown"
                text: "Details"
                rotation: root.showDetails ? 180 : 0
                onClicked: root.showDetails = !root.showDetails

                Behavior on rotation {
                    FlowSpring {}
                }
            }
        }

        Rectangle {
            width: root._inner
            height: Metrics.controlHeight + Metrics.space4
            radius: Metrics.radiusControl
            color: Theme.field
            visible: root.target !== ""

            Text {
                x: Metrics.space12
                width: parent.width - 2 * Metrics.space12
                anchors.verticalCenter: parent.verticalCenter
                text: root.target
                elide: Text.ElideMiddle
                color: Theme.text
                font.family: Metrics.fontMono
                font.pixelSize: Metrics.textLabel
            }
        }

        // The details of the request: each is a name and its value.
        Column {
            width: root._inner
            spacing: Metrics.space4
            visible: root.showDetails

            Repeater {
                model: root.details

                Row {
                    required property var modelData

                    spacing: Metrics.gap

                    Text {
                        width: 64
                        text: modelData[0]
                        color: Theme.muted
                        font.family: Metrics.fontUi
                        font.pixelSize: Metrics.textLabel
                        font.weight: Metrics.weightBody
                    }
                    Text {
                        width: root._inner - 64 - Metrics.gap
                        text: modelData[1]
                        elide: Text.ElideMiddle
                        color: Theme.text
                        font.family: Metrics.fontMono
                        font.pixelSize: Metrics.textLabel
                    }
                }
            }
        }

        // The accounts that can approve. The list replaces the field while the user selects one.
        Column {
            width: root._inner
            visible: root._choosing

            Repeater {
                model: root.accounts

                ListRow {
                    required property string modelData

                    icon: "user"
                    text: modelData
                    selected: modelData === root.user
                    onClicked: {
                        root.user = modelData;
                        root.phase = "prompt";
                    }
                }
            }
        }

        Row {
            width: root._inner
            spacing: Metrics.gap
            visible: !root._choosing && root.phase !== "unavailable"

            // With more than one account, the plate is a button that opens the list.
            T.AbstractButton {
                id: account

                width: Metrics.fieldHeight
                height: Metrics.fieldHeight
                enabled: root.accounts.length > 1 && root.phase !== "checking"
                scale: down ? Metrics.pressScale : 1
                onClicked: root.phase = "accounts"

                Accessible.name: "Account " + root.user

                Behavior on scale {
                    SnapSpring {
                        epsilon: 0.002
                    }
                }

                contentItem: Avatar {
                    name: root.user
                    size: Metrics.fieldHeight
                    tone: Theme.purple
                }

                background: Item {
                    FocusRing {
                        target: account
                        around: Metrics.radiusControl + 2
                    }
                }
            }

            TextField {
                id: field

                width: root._inner - account.width - parent.spacing
                placeholderText: root.method === "code" ? "Code for " + root.user : "Password for " + root.user
                echoMode: root.method === "code" ? TextInput.Normal : TextInput.Password
                inputMethodHints: root.method === "code" ? Qt.ImhDigitsOnly : Qt.ImhNone
                font.family: root.method === "code" ? Metrics.fontMono : Metrics.fontUi
                enabled: root.phase !== "checking"
                onAccepted: root.accepted(text)

                transform: Translate {
                    x: root._shake
                }

                Rectangle {
                    anchors.fill: parent
                    radius: Metrics.radiusControl + 2
                    color: "transparent"
                    border.width: Metrics.focusWidth
                    border.color: Theme.danger
                    opacity: root.phase === "error" ? 1 : 0

                    Behavior on opacity {
                        Fade {}
                    }
                }
            }
        }

        // The service that checks a password does not answer. The dialog can only try again.
        Row {
            spacing: Metrics.iconGap
            visible: root.phase === "unavailable"

            Icon {
                anchors.verticalCenter: parent.verticalCenter
                name: "lock"
                color: Theme.warning
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "The authentication service does not answer"
                color: Theme.text
                font.family: Metrics.fontUi
                font.pixelSize: Metrics.textBody
                font.weight: Metrics.weightBody
            }
        }

        Row {
            anchors.right: parent.right
            spacing: Metrics.gap

            Spinner {
                anchors.verticalCenter: parent.verticalCenter
                visible: root.phase === "checking"
            }
            Button {
                flat: true
                text: "Cancel"
                onClicked: root.cancelled()
            }
            Button {
                highlighted: true
                visible: root.phase === "unavailable"
                text: "Try again"
                onClicked: root.retried()
            }
            Button {
                highlighted: true
                visible: root.phase !== "unavailable"
                text: "Authenticate"
                enabled: root.phase !== "checking" && !root._choosing && field.length > 0
                onClicked: root.accepted(field.text)
            }
        }
    }

    // The password was correct. The check is the full content, and then the dialog closes.
    Item {
        id: done

        width: root._inner
        height: 72
        visible: root.phase === "done"

        Rectangle {
            anchors.centerIn: parent
            width: 44
            height: 44
            radius: 22
            color: Theme.success

            Icon {
                anchors.centerIn: parent
                name: "check"
                color: Theme.ink
            }
        }
    }
}
