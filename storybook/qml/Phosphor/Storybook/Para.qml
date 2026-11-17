// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

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
