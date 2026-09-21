import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import qs.services
import qs.modules.components

Item {
    id: root

    ColumnLayout {
        anchors.fill: parent
        spacing: Style.spacingSm

        RowLayout {
            Layout.fillWidth: true

            Text {
                text: "Notifications"
                color: Colors.onBackground
                font.family: Style.fontFamily
                font.pixelSize: Style.fs(0)
                font.bold: true
                Layout.fillWidth: true
            }

            Button {
                width: 22
                height: 22
                radius: Style.radius
                baseColor: Notifications.dndEnabled ? Colors.primary : Qt.rgba(0, 0, 0, 0)
                hoverColor: Notifications.dndEnabled ? Qt.lighter(Colors.primary, 1.1) : Colors.surfaceVariant
                onClicked: Notifications.toggleDnd()
                Text {
                    anchors.centerIn: parent
                    text: Notifications.dndEnabled ? Icons.bellOff : Icons.bell
                    color: Notifications.dndEnabled ? Colors.onPrimary : Colors.onBackground
                    font.family: Style.fontFamily
                    font.pixelSize: Style.fs(-2)
                }
            }

            Button {
                width: 22
                height: 22
                radius: Style.radius
                baseColor: Qt.rgba(0, 0, 0, 0)
                hoverColor: Colors.surfaceVariant
                onClicked: Notifications.dismissAll()
                Text {
                    anchors.centerIn: parent
                    text: Icons.close
                    color: Colors.onBackground
                    font.family: Style.fontFamily
                    font.pixelSize: Style.fs(-2)
                }
            }
        }

        Item {
            visible: Notifications.list.count === 0
            Layout.fillWidth: true
            Layout.fillHeight: true

            Column {
                anchors.centerIn: parent
                spacing: Style.spacingSm

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Icons.bellOff
                    color: Colors.onBackground
                    opacity: 0.3
                    font.family: Style.fontFamily
                    font.pixelSize: Style.fsIcon(20)
                    horizontalAlignment: Text.AlignHCenter
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "No notifications"
                    color: Colors.onBackground
                    opacity: 0.4
                    font.family: Style.fontFamily
                    font.pixelSize: Style.fs(-1)
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        ListView {
            id: notifList
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: Notifications.list.count > 0
            spacing: Style.spacingSm
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            model: Notifications.list

            delegate: NotificationCard {
                width: notifList.width
            }

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }
        }
    }
}
