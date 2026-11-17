// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

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
