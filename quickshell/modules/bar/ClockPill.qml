import QtQuick
import QtQuick.Layouts

import qs.services
import qs.modules.components

Button {
    id: root

    property date now: new Date()

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.now = new Date()
    }

    baseColor: Colors.surface
    hoverColor: Qt.lighter(Colors.surface, 1.3)
    pressColor: Qt.darker(Colors.surface, 1.1)
    radius: Style.radius

    implicitHeight: Style.barHeight
    implicitWidth: row.implicitWidth + Style.pillPadding * 2

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: Style.spacingXs

        Text {
            text: Qt.formatTime(root.now, "hh:mm:ss")
            color: Colors.onBackground
            font.family: Style.fontFamily
            font.pixelSize: Style.fs(0)
            font.bold: true
        }

        Text {
            text: "·"
            color: Colors.onBackground
            opacity: 0.5
            font.family: Style.fontFamily
            font.pixelSize: Style.fs(0)
            font.bold: true
        }

        Text {
            text: Qt.formatDate(root.now, "d ddd")
            color: Colors.onBackground
            opacity: 0.65
            font.family: Style.fontFamily
            font.pixelSize: Style.fs(0)
        }
    }
}
