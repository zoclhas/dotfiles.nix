import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

import qs.widgets
import qs.services

Item {
    id: root

    required property SystemTrayItem modelData

    readonly property string panelName: "tray:" + modelData.id + ":" + (QsWindow.window?.screen?.name ?? "")

    implicitWidth: Theme.iconSize + 2 * Theme.spacingXs
    implicitHeight: Theme.buttonHeight - 2 * Theme.px

    function openMenu() {
        if (root.modelData.hasMenu)
            Session.togglePanel(root.panelName);
    }

    Bevel {
        anchors.fill: parent
        visible: mouse.containsMouse || Session.panel === root.panelName
        style: mouse.pressed || Session.panel === root.panelName ? "inset" : "outset"
        depth: 1
    }

    Image {
        anchors.centerIn: parent
        width: Theme.iconSize
        height: Theme.iconSize
        source: root.modelData.icon
        sourceSize: Qt.size(Theme.iconSize, Theme.iconSize)
        smooth: false
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor

        onClicked: event => {
            if (event.button === Qt.MiddleButton)
                root.modelData.secondaryActivate();
            else if (event.button === Qt.RightButton || root.modelData.onlyMenu)
                root.openMenu();
            else
                root.modelData.activate();
        }
        onWheel: wheel => {
            const horizontal = Math.abs(wheel.angleDelta.x) > Math.abs(wheel.angleDelta.y);
            root.modelData.scroll(horizontal ? wheel.angleDelta.x : wheel.angleDelta.y, horizontal);
        }
    }

    TrayMenu {
        name: root.panelName
        anchorItem: root
        screen: QsWindow.window?.screen ?? null
        trayItem: root.modelData
    }
}
