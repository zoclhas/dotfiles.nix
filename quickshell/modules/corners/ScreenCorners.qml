import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.services

PanelWindow {
    id: root

    required property ShellScreen targetScreen
    screen: root.targetScreen

    readonly property real bezelSize: Style.bezelRadius

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "zochell-corners"

    mask: Region {
        item: null
    }

    RoundCorner {
        corner: 0
        size: root.bezelSize
        cornerColor: Colors.cornerBg
        anchors.top: parent.top
        anchors.left: parent.left
    }

    RoundCorner {
        corner: 1
        size: root.bezelSize
        cornerColor: Colors.cornerBg
        anchors.top: parent.top
        anchors.right: parent.right
    }

    RoundCorner {
        corner: 2
        size: root.bezelSize
        cornerColor: Colors.cornerBg
        anchors.bottom: parent.bottom
        anchors.left: parent.left
    }

    RoundCorner {
        corner: 3
        size: root.bezelSize
        cornerColor: Colors.cornerBg
        anchors.bottom: parent.bottom
        anchors.right: parent.right
    }
}
