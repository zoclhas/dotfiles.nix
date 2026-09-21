import QtQuick
import QtQuick.Layouts

import qs.services
import qs.modules.components

StyledRect {
    id: root

    property string icon: ""
    property real util: 0
    property string title: ""
    property string quickInfo: ""
    property color accentColor: Colors.primary

    color: Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.08)
    borderEnabled: false
    borderColor: root.accentColor
    radius: Style.innerRadius(4)

    implicitHeight: col.implicitHeight + Style.spacingSm * 2

    ColumnLayout {
        id: col
        anchors.fill: parent
        anchors.margins: Style.spacingSm
        spacing: Style.spacingXs

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.spacingSm

            Text {
                Layout.preferredWidth: 20
                text: root.icon
                color: root.accentColor
                font.family: Style.fontFamily
                font.pixelSize: Style.fsIcon(-3)
                horizontalAlignment: Text.AlignHCenter
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 18
                radius: Style.innerRadius(4)
                color: "transparent"
                border.width: 1
                border.color: root.accentColor
                clip: true

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.margins: 2
                    height: parent.height - 4
                    radius: Style.innerRadius(4) - 2
                    width: Math.max(height, (parent.width - 4) * Math.max(0, Math.min(1, root.util / 100)))
                    color: root.accentColor

                    Behavior on width {
                        NumberAnimation {
                            duration: 240
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.spacingSm

            Text {
                Layout.fillWidth: true
                text: root.title
                color: Colors.onBackground
                font.family: Style.fontFamily
                font.pixelSize: Style.fs(-1)
                elide: Text.ElideRight
            }

            Text {
                text: root.quickInfo
                color: Colors.onBackground
                opacity: 0.75
                font.family: Style.fontFamily
                font.pixelSize: Style.fs(-1)
            }
        }
    }
}
