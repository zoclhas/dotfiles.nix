import QtQuick
import Quickshell
import Quickshell.Widgets

import qs.services
import qs.modules.components

StyledRect {
    id: root

    readonly property var focusedWindow: Niri.focusedWindow
    readonly property bool hasWindow: root.focusedWindow !== null && root.focusedWindow !== undefined

    color: Colors.surface
    radius: Style.radius
    clip: false

    implicitHeight: Style.barHeight
    implicitWidth: root.hasWindow ? (row.implicitWidth + Style.pillPadding * 2) : 0
    opacity: root.hasWindow ? 1 : 0

    Behavior on implicitWidth {
        NumberAnimation {
            duration: Style.morphDuration
            easing.type: Style.morphEasing
        }
    }
    Behavior on opacity {
        NumberAnimation {
            duration: Style.morphDuration
            easing.type: Style.morphEasing
        }
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: Style.spacingSm

        IconImage {
            id: appIcon
            anchors.verticalCenter: parent.verticalCenter
            implicitSize: 20
            source: root.hasWindow ? Quickshell.iconPath(root.focusedWindow.appId, "application-x-executable") : ""
        }

        MarqueeText {
            id: marquee
            anchors.verticalCenter: parent.verticalCenter
            maxWidth: 220
            text: root.hasWindow ? root.focusedWindow.title : ""
            maxChars: 30
            fontPixelSize: Style.fs(-1)
            fadeColor: Colors.surface
        }
    }
}
