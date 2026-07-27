import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

import qs.services
import qs.modules.components

StyledRect {
    id: root

    readonly property int itemCount: SystemTray.items.values.length

    color: Colors.surface
    radius: Style.radius
    implicitHeight: Style.barHeight
    implicitWidth: root.itemCount > 0 ? (row.implicitWidth + Style.pillPadding * 2) : 0
    opacity: root.itemCount > 0 ? 1 : 0
    clip: true

    Behavior on implicitWidth {
        NumberAnimation {
            duration: Style.morphDuration
            easing.type: Style.morphEasing
        }
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: Style.spacingXs

        Repeater {
            model: SystemTray.items

            delegate: Item {
                id: trayItem
                required property SystemTrayItem modelData

                width: Style.barHeight - 8
                height: Style.barHeight - 8

                IconImage {
                    anchors.fill: parent
                    source: trayItem.modelData.icon
                }

                QsMenuAnchor {
                    id: menuAnchor
                    menu: trayItem.modelData.menu
                    anchor.item: trayItem
                    anchor.edges: Edges.Top
                    anchor.gravity: Edges.Top
                }

                TapHandler {
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    cursorShape: Qt.PointingHandCursor
                    onTapped: (eventPoint, button) => {
                        if (button === Qt.RightButton) {
                            if (trayItem.modelData.hasMenu)
                                menuAnchor.open();
                        } else {
                            trayItem.modelData.activate();
                        }
                    }
                }
            }
        }
    }
}
