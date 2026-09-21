import QtQuick
import Quickshell

import qs.widgets
import qs.services

Item {
    id: root

    property string text
    property string iconName: ""
    property bool submenu: false
    property bool checkable: false
    property bool checked: false
    property bool back: false
    signal activated

    readonly property string iconUrl: {
        const prefix = "image://icon/";
        if (!root.iconName)
            return "";
        if (root.iconName.startsWith(prefix))
            return Quickshell.iconPath(root.iconName.slice(prefix.length).split("?")[0], true);
        if (root.iconName.indexOf("/") >= 0)
            return root.iconName;
        return Quickshell.iconPath(root.iconName, true);
    }

    implicitHeight: Theme.buttonHeight - 2 * Theme.px
    implicitWidth: content.implicitWidth + 2 * Theme.spacingSm + (root.submenu ? arrow.implicitWidth + Theme.spacingMd : 0)

    Bevel {
        anchors.fill: parent
        visible: hover.hovered && root.enabled
        style: "outset"
        depth: 1
    }

    Row {
        id: content
        anchors.verticalCenter: parent.verticalCenter
        x: Theme.spacingSm
        spacing: Theme.spacingSm

        Item {
            width: Theme.iconSize
            height: Theme.iconSize
            anchors.verticalCenter: parent.verticalCenter

            PixelIcon {
                anchors.centerIn: parent
                visible: root.checkable && root.checked
                name: "check"
                scale: 1
                color: root.enabled ? Theme.text : Theme.textDisabled
            }
            Image {
                anchors.fill: parent
                visible: !root.checkable && root.iconUrl.length > 0
                source: root.iconUrl
                sourceSize: Qt.size(Theme.iconSize, Theme.iconSize)
                smooth: false
            }
        }
        RText {
            anchors.verticalCenter: parent.verticalCenter
            text: (root.back ? "< " : "") + root.text
            engraved: !root.enabled
        }
    }

    RText {
        id: arrow
        visible: root.submenu
        anchors.right: parent.right
        anchors.rightMargin: Theme.spacingSm
        anchors.verticalCenter: parent.verticalCenter
        text: ">"
    }

    HoverHandler {
        id: hover
        cursorShape: Qt.PointingHandCursor
    }
    TapHandler {
        enabled: root.enabled
        onTapped: root.activated()
    }
}
