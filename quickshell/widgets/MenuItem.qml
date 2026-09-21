import QtQuick

import qs.services

Item {
    id: root

    property string icon: ""
    property string text: ""
    property alias label: root.text
    property string detail: ""
    property bool toggled: false
    property bool highlighted: false

    signal clicked

    implicitHeight: 30
    implicitWidth: 220

    readonly property bool lit: mouse.containsMouse || root.highlighted
    readonly property color fg: !root.enabled ? Theme.textDisabled : (root.lit ? Theme.selectionText : Theme.text)

    PixelRect {
        anchors.fill: parent
        color: root.lit && root.enabled ? Theme.selection : "transparent"
    }

    PixelIcon {
        id: icon
        visible: root.icon.length > 0
        x: Theme.spacingMd
        anchors.verticalCenter: parent.verticalCenter
        name: root.icon
        color: root.fg
    }

    RText {
        anchors.left: parent.left
        anchors.leftMargin: Theme.spacingMd + Theme.iconSize + Theme.spacingMd
        anchors.right: detail.left
        anchors.rightMargin: Theme.spacingSm
        height: parent.height
        text: root.text
        color: root.fg
        elide: Text.ElideRight
        font.bold: root.toggled
    }

    RText {
        id: detail
        anchors.right: parent.right
        anchors.rightMargin: Theme.spacingMd
        height: parent.height
        text: root.detail
        color: root.fg
        opacity: 0.8
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        enabled: root.enabled
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
