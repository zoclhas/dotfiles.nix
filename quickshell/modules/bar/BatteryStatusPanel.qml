import QtQuick
import QtQuick.Layouts

import qs.services
import qs.modules.components

Item {
    id: root

    readonly property color levelColor: Battery.charging ? Colors.primary : Battery.level === "critical" ? Colors.error : Battery.level === "low" ? Colors.tertiary : Battery.level === "medium" ? Colors.secondary : Colors.primary

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.spacingSm
        spacing: Style.spacingSm

        StyledRect {
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            color: Qt.rgba(root.levelColor.r, root.levelColor.g, root.levelColor.b, 0.08)
            radius: Style.innerRadius(4)

            RowLayout {
                anchors.fill: parent
                anchors.margins: Style.spacingMd
                spacing: Style.spacingMd

                Text {
                    text: Battery.charging ? Icons.bolt : Icons.batteryFull
                    color: root.levelColor
                    font.family: Style.fontFamily
                    font.pixelSize: Style.fsIcon(4)
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Text {
                        text: Battery.charging ? "Charging" : (Battery.fullyCharged ? "Fully Charged" : "On Battery")
                        color: Colors.onBackground
                        font.family: Style.fontFamily
                        font.bold: true
                        font.pixelSize: Style.fs(2)
                    }

                    Text {
                        visible: (Battery.charging && Battery.timeToFull > 0) || (!Battery.charging && !Battery.fullyCharged && Battery.timeToEmpty > 0)
                        text: Battery.charging ? ("Full in " + Battery.formatTime(Battery.timeToFull)) : (Battery.formatTime(Battery.timeToEmpty) + " remaining")
                        color: Colors.onBackground
                        opacity: 0.6
                        font.family: Style.fontFamily
                        font.pixelSize: Style.fs(-1)
                    }
                }

                Text {
                    text: Battery.percent + "%"
                    color: root.levelColor
                    font.family: Style.fontFamily
                    font.bold: true
                    font.pixelSize: Style.fs(4)
                }
            }
        }

        StyledRect {
            Layout.fillWidth: true
            Layout.preferredHeight: 56
            color: Colors.surfaceVariant
            radius: Style.innerRadius(4)

            RowLayout {
                anchors.fill: parent
                anchors.margins: Style.spacingSm - 4
                spacing: Style.spacingSm

                Repeater {
                    model: [
                        {
                            icon: Icons.leaf,
                            name: "PowerSaver"
                        },
                        {
                            icon: Icons.gauge,
                            name: "Balanced"
                        },
                        {
                            icon: Icons.rabbit,
                            name: "Performance"
                        }
                    ]

                    delegate: Button {
                        id: profileButton
                        required property var modelData

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: Style.innerRadius(4)

                        readonly property bool active: PowerProfileService.current === modelData.name

                        baseColor: active ? Colors.primary : Qt.rgba(0, 0, 0, 0)
                        hoverColor: active ? Qt.lighter(Colors.primary, 1.1) : Colors.surface
                        shadowEnabled: false

                        onClicked: PowerProfileService.setProfile(modelData.name)

                        Text {
                            anchors.centerIn: parent
                            text: profileButton.modelData.icon
                            color: profileButton.active ? Colors.onPrimary : Colors.onBackground
                            font.family: Style.fontFamily
                            font.pixelSize: Style.fsIcon(10)
                        }
                    }
                }
            }
        }
    }
}
