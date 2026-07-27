import QtQuick
import QtQuick.Layouts

import qs.services

Item {
    id: root

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.spacingSm
        spacing: Style.spacingSm

        SysMonitorRow {
            Layout.fillWidth: true
            icon: Icons.cpu
            util: SystemStats.cpuUsage
            title: SystemStats.truncMiddle(SystemStats.cpuName) || "CPU"
            quickInfo: Math.round(SystemStats.cpuUsage) + "%  " + Math.round(SystemStats.cpuTemp) + "°C  " + Math.round(SystemStats.cpuFanRpm) + "rpm"
            accentColor: Colors.primary
        }

        SysMonitorRow {
            Layout.fillWidth: true
            icon: Icons.memory
            util: SystemStats.ramPercent
            title: SystemStats.ramUsedGiB.toFixed(1) + " / " + SystemStats.ramTotalGiB.toFixed(1) + " GiB"
            quickInfo: Math.round(SystemStats.ramPercent) + "%"
            accentColor: Colors.secondary
        }

        Repeater {
            model: SystemStats.gpus

            delegate: SysMonitorRow {
                required property var modelData
                Layout.fillWidth: true
                icon: Icons.chip
                util: modelData.util
                title: SystemStats.truncMiddle(modelData.name, 20)
                quickInfo: Math.round(modelData.util) + "%  " + Math.round(modelData.temp) + "°C  " + Math.round(SystemStats.gpuFanRpm) + "rpm"
                accentColor: Colors.tertiary
            }
        }

        SysMonitorRow {
            Layout.fillWidth: true
            icon: Icons.harddisk
            util: SystemStats.diskPercent
            title: SystemStats.diskAvailGiB.toFixed(0) + " GB free"
            quickInfo: Math.round(SystemStats.diskPercent) + "%"
            accentColor: Colors.primary
        }

        Item {
            Layout.fillHeight: true
        }

        RowLayout {
            Layout.fillWidth: true
            visible: Network.wifiConnected || Network.ethernetConnected
            spacing: Style.spacingSm

            Text {
                text: Network.ethernetConnected ? Icons.ethernet : (Network.wifiSignal > 75 ? Icons.wifiStrength4 : Network.wifiSignal > 50 ? Icons.wifiStrength3 : Network.wifiSignal > 25 ? Icons.wifiStrength2 : Icons.wifiStrength1)
                color: Colors.primary
                font.family: Style.fontFamily
                font.pixelSize: Style.fs(1)
            }

            Text {
                text: Network.ethernetConnected ? "Ethernet" : Network.wifiSsid
                color: Colors.onBackground
                font.family: Style.fontFamily
                font.pixelSize: Style.fs(-1)
                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            Text {
                text: Icons.arrowDown
                color: Colors.secondary
                font.family: Style.fontFamily
                font.pixelSize: Style.fsIcon(-4)
            }
            Text {
                text: Network.formatSpeed(Network.downloadSpeed)
                color: Colors.onBackground
                opacity: 0.75
                font.family: Style.fontFamily
                font.pixelSize: Style.fs(-2)
            }
            Text {
                text: Icons.arrowUp
                color: Colors.tertiary
                font.family: Style.fontFamily
                font.pixelSize: Style.fsIcon(-4)
            }
            Text {
                text: Network.formatSpeed(Network.uploadSpeed)
                color: Colors.onBackground
                opacity: 0.75
                font.family: Style.fontFamily
                font.pixelSize: Style.fs(-2)
            }
        }
    }
}
