// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import Phosphor.Design

Text {
    width: parent ? parent.width : implicitWidth
    topPadding: Metrics.space16
    color: Theme.text
    font.family: Metrics.fontUi
    font.pixelSize: Metrics.textHeading
    lineHeight: Metrics.lineHeading
    lineHeightMode: Text.FixedHeight
    font.weight: Metrics.weightStrong
}
