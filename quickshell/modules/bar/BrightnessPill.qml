import QtQuick

import qs.services
import qs.modules.components

StyledRect {
    id: root

    color: Colors.surface
    radius: Style.radius
    implicitWidth: Style.barHeight
    implicitHeight: Style.barHeight

    CircularMeter {
        anchors.fill: parent
        anchors.margins: 4
        value: Brightness.percentage / 100
        progressColor: Colors.secondary
        lineWidth: 2.5

        Text {
            anchors.centerIn: parent
            text: Icons.brightness
            color: Colors.onBackground
            font.family: Style.fontFamily
            font.pixelSize: Style.fsIcon(4)
        }
    }

    HoverHandler {
        id: hover
        cursorShape: Qt.PointingHandCursor
    }

    WheelHandler {
        onWheel: event => {
            if (event.angleDelta.y > 0)
                Brightness.increment();
            else
                Brightness.decrement();
        }
    }

    Tooltip {
        parent: root
        x: (root.width - width) / 2
        y: -height - 6
        text: Brightness.percentage + "%"
        visible: hover.hovered
    }
}
