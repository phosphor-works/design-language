// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import Phosphor.Design

// The calendar: one month, and the events of the selected day. The bar shows the time, so the panel
// does not show the time again. It has no time zone line and no key hints.
Column {
    id: root

    property date today: new Date()
    property date selected: today
    property int year: today.getFullYear()
    property int month: today.getMonth()
    // Each event: { date, time, title }.
    property var events: []

    readonly property bool _onToday: year === today.getFullYear() && month === today.getMonth()
    readonly property var _agenda: events.filter(event => event.date.toDateString() === selected.toDateString())

    function step(months: int) {
        const next = new Date(year, month + months, 1);
        year = next.getFullYear();
        month = next.getMonth();
    }

    width: 7 * 38 + 2 * Metrics.pad
    padding: Metrics.pad
    topPadding: Metrics.space8
    spacing: Metrics.gap

    PanelHeader {
        width: root.width - 2 * Metrics.pad
        canGoBack: false
        text: new Date(root.year, root.month, 1).toLocaleDateString(Qt.locale(), "MMMM yyyy")

        Button {
            flat: true
            text: "Today"
            visible: !root._onToday
            onClicked: {
                root.year = root.today.getFullYear();
                root.month = root.today.getMonth();
                root.selected = root.today;
            }
        }
        IconButton {
            iconName: "chevronLeft"
            text: "Previous month"
            onClicked: root.step(-1)
        }
        IconButton {
            iconName: "chevronRight"
            text: "Next month"
            onClicked: root.step(1)
        }
    }

    MonthGrid {
        id: grid

        width: root.width - 2 * Metrics.pad
        year: root.year
        month: root.month
        today: root.today
        selected: root.selected
        marked: root.events.filter(event => event.date.getFullYear() === root.year && event.date.getMonth() === root.month).map(event => event.date.getDate())
        onPicked: date => root.selected = date
    }

    Column {
        width: grid.width
        visible: root._agenda.length > 0

        Repeater {
            model: root._agenda

            ListRow {
                required property var modelData

                icon: "clock"
                text: modelData.title
                value: modelData.time
            }
        }
    }
}
