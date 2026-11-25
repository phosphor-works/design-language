// SPDX-FileCopyrightText: 2026 Phosphor Works Team
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import Phosphor.Design

// A page of the guide: headings, paragraphs and examples in one column.
Item {
    id: doc

    default property alias blocks: column.data
    property bool fill: false

    implicitHeight: column.height + 2 * Metrics.pageMargin

    Column {
        id: column

        x: Metrics.pageMargin
        y: Metrics.space16
        width: Math.min(doc.width - 2 * Metrics.pageMargin, 980)
        spacing: Metrics.gapLoose
    }
}
