import QtQuick

import qs.widgets
import qs.services

GroupBox {
    id: root

    title: "System"
    height: labelH + Theme.spacingSm + col.implicitHeight + Theme.spacingMd

    function gib(v) {
        return v.toFixed(1);
    }

    Column {
        id: col
        width: parent.width
        spacing: Theme.spacingMd

        RText {
            width: parent.width
            text: SystemStats.cpuName || "CPU"
            font.bold: true
            elide: Text.ElideRight
        }
        StatRow {
            width: parent.width
            label: "Load"
            value: SystemStats.cpuUsage / 100
            detail: Math.round(SystemStats.cpuUsage) + "%"
        }
        RText {
            visible: SystemStats.cpuTemp > 0 || SystemStats.cpuFanRpm > 0
            opacity: 0.8
            text: (SystemStats.cpuTemp > 0 ? Math.round(SystemStats.cpuTemp) + "°C" : "") + (SystemStats.cpuFanRpm > 0 ? "   fan " + Math.round(SystemStats.cpuFanRpm) + " rpm" : "")
        }

        Repeater {
            model: SystemStats.gpus

            delegate: Column {
                required property var modelData
                width: col.width
                spacing: Theme.spacingMd

                Separator {
                    width: parent.width
                }
                RText {
                    width: parent.width
                    text: modelData.name
                    font.bold: true
                    elide: Text.ElideRight
                }
                StatRow {
                    width: parent.width
                    label: "Load"
                    value: modelData.util / 100
                    detail: Math.round(modelData.util) + "%"
                }
                StatRow {
                    width: parent.width
                    label: "VRAM"
                    value: modelData.memTotalMiB > 0 ? modelData.memUsedMiB / modelData.memTotalMiB : 0
                    detail: root.gib(modelData.memUsedMiB / 1024) + "G"
                }
                RText {
                    opacity: 0.8
                    text: Math.round(modelData.temp) + "°C" + (SystemStats.gpuFanRpm > 0 ? "   fan " + Math.round(SystemStats.gpuFanRpm) + " rpm" : "")
                }
            }
        }

        Separator {
            width: parent.width
        }

        StatRow {
            width: parent.width
            label: "RAM"
            value: SystemStats.ramPercent / 100
            detail: root.gib(SystemStats.ramUsedGiB) + "/" + root.gib(SystemStats.ramTotalGiB) + "G"
            detailWidth: 96
        }
        StatRow {
            width: parent.width
            label: "Disk"
            value: SystemStats.diskPercent / 100
            detail: Math.round(SystemStats.diskTotalGiB - SystemStats.diskAvailGiB) + "/" + Math.round(SystemStats.diskTotalGiB) + "G"
            detailWidth: 96
        }

        Item {
            visible: Network.ethernetConnected || Network.wifiConnected
            width: parent.width
            height: netRow.height

            Row {
                id: netRow
                spacing: Theme.spacingXl

                Row {
                    spacing: Theme.spacingXs
                    PixelIcon {
                        anchors.verticalCenter: parent.verticalCenter
                        name: "arrowDown"
                    }
                    RText {
                        anchors.verticalCenter: parent.verticalCenter
                        text: Network.formatSpeed(Network.downloadSpeed)
                    }
                }
                Row {
                    spacing: Theme.spacingXs
                    PixelIcon {
                        anchors.verticalCenter: parent.verticalCenter
                        name: "arrowUp"
                    }
                    RText {
                        anchors.verticalCenter: parent.verticalCenter
                        text: Network.formatSpeed(Network.uploadSpeed)
                    }
                }
            }
        }
    }
}
