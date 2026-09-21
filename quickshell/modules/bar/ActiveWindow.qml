import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.widgets
import qs.services

RowLayout {
    id: root

    readonly property var win: Niri.focusedWindow
    readonly property var entry: root.win ? DesktopEntries.heuristicLookup(root.win.appId) : null
    readonly property string iconPath: root.entry && root.entry.icon ? Quickshell.iconPath(root.entry.icon, true) : ""

    visible: root.win !== null
    spacing: Theme.spacingSm

    Item {
        Layout.alignment: Qt.AlignVCenter
        implicitWidth: root.iconPath.length > 0 ? Theme.iconSize : fallback.implicitWidth
        implicitHeight: Theme.iconSize

        Image {
            anchors.fill: parent
            visible: root.iconPath.length > 0
            source: root.iconPath
            sourceSize: Qt.size(Theme.iconSize, Theme.iconSize)
            smooth: false
        }
        PixelIcon {
            id: fallback
            anchors.centerIn: parent
            visible: root.iconPath.length === 0
            name: "card"
            scale: 1
        }
    }

    RText {
        Layout.alignment: Qt.AlignVCenter
        Layout.fillWidth: true
        readonly property string full: root.win ? (root.win.title || root.win.appId) : ""
        text: full.length > 30 ? full.slice(0, 29) + "…" : full
        elide: Text.ElideRight
    }
}
