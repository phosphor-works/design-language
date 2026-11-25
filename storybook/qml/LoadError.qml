// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick

// The host shows this page when Main.qml does not load. The page imports no module of this
// repository. Thus a defective token file cannot stop the page that reports it.
Rectangle {
    color: "#050916"

    Text {
        anchors.fill: parent
        anchors.margins: 32
        text: Session.error
        color: "#F43F5E"
        font.family: "monospace"
        font.pixelSize: 13
        wrapMode: Text.Wrap
    }
}
