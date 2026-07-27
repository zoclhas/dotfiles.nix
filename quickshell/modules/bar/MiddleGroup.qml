import QtQuick
import Quickshell.Io

import qs.services
import qs.modules.components
import qs.modules.bar.dashboard

Row {
    id: root

    required property var barWindow

    spacing: Style.pillGap

    MediaPill {
        anchors.verticalCenter: parent.verticalCenter
        onActivated: panelLoader.item.toggle()
    }

    ClockPill {
        anchors.verticalCenter: parent.verticalCenter
        onClicked: panelLoader.item.toggle()
    }

    Loader {
        id: panelLoader
        active: true
        sourceComponent: MorphPanel {
            layerNamespace: "zochell-dashboard"
            panelWidth: 780
            panelHeight: 320
            pillWidth: 260
            pillHeight: Style.barHeight
            align: "center"
            screen: root.barWindow?.screen ?? null

            panelContent: DashboardPanel {
                anchors.fill: parent
            }
        }
    }

    IpcHandler {
        target: "dashboard"
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
