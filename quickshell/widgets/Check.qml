import QtQuick

import qs.services

Item {
    id: root

    property bool checked: false
    property string text: ""

    signal toggled(bool checked)

    implicitHeight: Theme.buttonHeight - 2
    implicitWidth: box.width + Theme.spacingMd + label.implicitWidth

    Bevel {
        id: box
        width: 20
        height: 20
        anchors.verticalCenter: parent.verticalCenter
        style: "inset"
        depth: 1
        faceColor: Theme.well

        PixelIcon {
            anchors.centerIn: parent
            visible: root.checked
            name: "check"
            scale: 1
            color: root.enabled ? Theme.wellText : Theme.textDisabled
        }
    }

    RText {
        id: label
        anchors.left: box.right
        anchors.leftMargin: Theme.spacingMd
        anchors.verticalCenter: parent.verticalCenter
        text: root.text
        engraved: !root.enabled
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.enabled
        cursorShape: Qt.PointingHandCursor
        onClicked: root.toggled(!root.checked)
    }
}
