// SPDX-FileCopyrightText: 2026 fuddlesworth
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Templates as T

// The list in a sidebar. It contains pages, and categories that contain pages.
//
//   NavList {
//       model: [
//           { text: "Placement", children: [{ id: "tiling", text: "Tiling", icon: "tiling" }] },
//           { id: "about", text: "About" }
//       ]
//       current: "tiling"
//       onPicked: id => controller.currentPageId = id
//   }
//
// An entry with `children` is a category. Its header opens and closes it. Its pages have an indent
// of one step, and a chevron shows the state. When a closed category contains the current page, its
// header shows the selection. Thus the list always shows the position of the user.
//
// `filter` shows only the pages whose name contains it. A filter opens each category, because a
// closed category hides a result.
//
// A page with a `count` shows that number as a badge. An entry with `divider: true` is a line
// between two groups. `compact` makes the list a column of icons for a narrow window. The
// categories then go away, and a page with no icon shows its first letter.
Item {
    id: root

    property var model: []
    property string current
    property string filter
    property var collapsed: [] // the `text` of each closed category
    property bool compact: false

    signal picked(string id)

    readonly property string _needle: filter.trim().toLowerCase()
    property Item _marked: null
    property bool _ready: false

    function toggle(category: string) {
        const next = collapsed.slice();
        const at = next.indexOf(category);
        if (at >= 0)
            next.splice(at, 1);
        else
            next.push(category);
        collapsed = next;
    }

    function _matches(text: string): bool {
        return _needle === "" || text.toLowerCase().includes(_needle);
    }

    implicitWidth: compact ? Metrics.navRowHeight + Metrics.space12 : 220
    implicitHeight: column.height

    // No item animates during the first layout of the list.
    Component.onCompleted: Qt.callLater(() => root._ready = true)

    component Row: T.AbstractButton {
        id: row

        property string iconName // `icon` belongs to the button template
        property int depth: 0
        property bool isCurrent: false
        property bool isCategory: false
        property bool expanded: false
        property int count: 0

        width: parent ? parent.width : 0
        implicitHeight: Metrics.navRowHeight
        leftPadding: root.compact ? (width - Metrics.iconSmall) / 2 : Metrics.padRow + depth * Metrics.navIndent
        rightPadding: root.compact ? leftPadding : Metrics.space8

        Accessible.name: text

        contentItem: Item {
            Icon {
                id: glyph

                anchors.verticalCenter: parent.verticalCenter
                visible: row.iconName !== ""
                name: row.iconName
                size: Metrics.iconSmall
                color: row.isCurrent ? Theme.accent : label.color

                Behavior on color {
                    Tint {}
                }
            }

            // In the compact list, a page with no icon shows its first letter.
            Text {
                anchors.centerIn: parent
                visible: root.compact && row.iconName === ""
                text: row.text.charAt(0).toUpperCase()
                color: row.isCurrent ? Theme.accent : label.color
                font.family: Metrics.fontUi
                font.pixelSize: Metrics.textBody
                font.weight: Metrics.weightStrong
            }

            Text {
                id: label

                anchors.left: glyph.visible ? glyph.right : parent.left
                anchors.leftMargin: glyph.visible ? 11 : 0
                anchors.right: chevron.visible ? chevron.left : tally.visible ? tally.left : parent.right
                anchors.rightMargin: chevron.visible || tally.visible ? 6 : 0
                anchors.verticalCenter: parent.verticalCenter
                visible: !root.compact
                text: row.text
                elide: Text.ElideRight
                color: row.isCurrent || row.hovered || row.isCategory ? Theme.text : Theme.muted
                font.family: Metrics.fontUi
                font.pixelSize: Metrics.textBody
                font.weight: Metrics.weightStrong

                Behavior on color {
                    Tint {}
                }
            }

            Icon {
                id: chevron

                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                visible: row.isCategory && !root.compact
                name: "chevronRight"
                size: Metrics.iconSmall
                color: Theme.muted
                rotation: row.expanded ? 90 : 0

                Behavior on rotation {
                    enabled: root._ready

                    FlowSpring {}
                }
            }

            // The compact list has no space for a number, so the badge is a dot at the icon.
            Badge {
                id: tally

                anchors.right: parent.right
                anchors.rightMargin: root.compact ? -Metrics.space6 : 0
                anchors.verticalCenter: root.compact ? undefined : parent.verticalCenter
                anchors.top: root.compact ? parent.top : undefined
                anchors.topMargin: Metrics.space4
                visible: row.count > 0
                count: root.compact ? 0 : row.count
            }
        }

        background: Rectangle {
            radius: Metrics.radiusControl
            color: row.hovered && !row.isCurrent ? Theme.hover : "transparent"

            Behavior on color {
                Tint {}
            }

            FocusRing {
                target: row
            }
        }
    }

    StretchIndicator {
        id: indicator

        anchors.fill: parent
        vertical: true
        target: root._marked
        color: Theme.selected
        radius: Metrics.radiusControl
    }

    Column {
        id: column

        width: parent.width

        Repeater {
            model: root.model

            delegate: Column {
                id: entry

                required property var modelData
                readonly property bool isDivider: modelData.divider === true
                readonly property bool isCategory: modelData.children !== undefined
                readonly property bool open: root.compact || root._needle !== "" || root.collapsed.indexOf(modelData.text) < 0
                readonly property bool holdsCurrent: isCategory && modelData.children.some(page => page.id === root.current)
                readonly property bool isCurrent: !isCategory && modelData.id === root.current
                property Item currentPage: null
                // The item that shows the selection: the page, or the header of a closed category.
                readonly property Item mark: holdsCurrent ? (open && currentPage ? currentPage : header) : isCurrent ? header : null

                width: column.width
                visible: isDivider ? root._needle === "" : isCategory ? modelData.children.some(page => root._matches(page.text)) : root._matches(modelData.text)
                onMarkChanged: if (mark)
                    root._marked = mark

                // A line between two groups of entries.
                Item {
                    width: parent.width
                    height: Metrics.space12
                    visible: entry.isDivider

                    Rectangle {
                        x: Metrics.padRow
                        width: parent.width - 2 * Metrics.padRow
                        height: Metrics.lineWidth
                        anchors.verticalCenter: parent.verticalCenter
                        color: Theme.line
                    }
                }

                Row {
                    id: header

                    // The compact list shows only pages, so the header of a category goes away.
                    visible: !entry.isDivider && !(root.compact && entry.isCategory)
                    text: entry.modelData.text ?? ""
                    count: entry.modelData.count ?? 0
                    iconName: entry.modelData.icon ?? ""
                    isCategory: entry.isCategory
                    expanded: entry.open
                    isCurrent: entry.isCurrent || (entry.holdsCurrent && !entry.open)
                    onClicked: entry.isCategory ? root.toggle(entry.modelData.text) : root.picked(entry.modelData.id)
                }

                Item {
                    id: body

                    // This value animates, and `height` reads it. `height` cannot be below zero
                    // when the spring overshoots.
                    property real extent: entry.open ? pages.height : 0

                    width: parent.width
                    height: Math.max(0, extent)
                    visible: entry.isCategory && height > 0
                    clip: true
                    opacity: entry.open ? 1 : 0
                    // The rows below move with this item, and the selection must move with them.
                    onHeightChanged: indicator.reposition()

                    Behavior on extent {
                        enabled: root._ready

                        FlowSpring {
                            epsilon: 0.05
                        }
                    }
                    Behavior on opacity {
                        enabled: root._ready

                        Fade {}
                    }

                    Column {
                        id: pages

                        width: parent.width

                        Repeater {
                            model: entry.isCategory ? entry.modelData.children : []

                            delegate: Row {
                                id: page

                                required property var modelData

                                text: modelData.text
                                iconName: modelData.icon ?? ""
                                count: modelData.count ?? 0
                                depth: 1
                                visible: root._matches(modelData.text)
                                isCurrent: modelData.id === root.current
                                onClicked: root.picked(modelData.id)
                                onIsCurrentChanged: if (isCurrent)
                                    entry.currentPage = page
                                Component.onCompleted: if (isCurrent)
                                    entry.currentPage = page
                            }
                        }
                    }
                }
            }
        }
    }
}
