import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

import qs.widgets
import qs.services
import qs.modules.bar.tray
import qs.modules.bar.volume

PanelWindow {
    id: root

    required property ShellScreen targetScreen
    screen: root.targetScreen

    anchors {
        bottom: true
        left: true
        right: true
    }
    implicitHeight: Theme.barHeight
    exclusiveZone: Theme.barHeight
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "zochell-bar"

    Bevel {
        anchors.fill: parent
        style: "outset"
        depth: 1
        vEdges: false

        Clock {
            anchors.centerIn: parent
        }

        RowLayout {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.spacingSm

            Tray {}

            VolumeButton {}
            BatteryButton {}
        }

        RowLayout {
            Button {
                icon: "start"
                Layout.leftMargin: Theme.spacingSm
                iconScale: 1.5
                gloss: true
            }

            Divider {}

            Workspaces {
                screenName: root.targetScreen.name
                Layout.alignment: Qt.AlignVCenter
            }

            Divider {}

            ActiveWindow {
                Layout.alignment: Qt.AlignVCenter
                Layout.leftMargin: Theme.spacingSm
                Layout.maximumWidth: root.width / 3
            }
        }
    }

    component Divider: Bevel {
        Layout.alignment: Qt.AlignVCenter
        Layout.preferredWidth: Theme.px * 2
        Layout.preferredHeight: Theme.buttonHeight
        style: "ridge"
        depth: 2
    }
}
