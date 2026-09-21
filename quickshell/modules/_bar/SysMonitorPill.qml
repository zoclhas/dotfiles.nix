import QtQuick
import Quickshell.Io

import qs.services
import qs.modules.components

Item {
    id: root

    required property var barWindow

    implicitWidth: Style.barHeight
    implicitHeight: Style.barHeight

    Button {
        id: button
        anchors.fill: parent
        radius: Style.radius
        baseColor: Colors.surface
        hoverColor: Qt.lighter(Colors.surface, 1.3)
        pressColor: Qt.darker(Colors.surface, 1.1)

        onClicked: panelLoader.item.toggle()

        Text {
            anchors.centerIn: parent
            text: Icons.monitor
            color: Colors.primary
            font.family: Style.fontFamily
            font.pixelSize: Style.fsIcon(-1)
        }
    }

    Loader {
        id: panelLoader
        active: true
        sourceComponent: MorphPanel {
            layerNamespace: "zochell-sysmonitor"
            panelWidth: 380
            panelHeight: 300
            pillWidth: Style.barHeight
            pillHeight: Style.barHeight
            align: "left"
            alignOffset: 0
            screen: root.barWindow?.screen ?? null

            panelContent: SysMonitorPanel {
                anchors.fill: parent
            }
        }
    }

    IpcHandler {
        target: "sysmonitor"
        function toggle(): void {
            panelLoader.item.toggle();
        }
        function open(): void {
            panelLoader.item.open();
        }
        function close(): void {
            panelLoader.item.close();
        }
    }
}
