// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import Phosphor.Design

Text {
    width: parent ? Math.min(parent.width, Metrics.readingWidth) : implicitWidth
    wrapMode: Text.Wrap
    lineHeight: Metrics.lineBody
    lineHeightMode: Text.FixedHeight
    color: Theme.muted
    font.family: Metrics.fontUi
    font.pixelSize: Metrics.textBody
    font.weight: Metrics.weightBody
}
