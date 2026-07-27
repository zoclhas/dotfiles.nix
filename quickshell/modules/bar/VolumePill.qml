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
        value: Audio.volume / Audio.maxVolume
        overdriveBoundary: (1 / Audio.maxVolume)
        progressColor: Audio.muted ? Colors.outline : Colors.primary
        overdriveColor: Colors.error
        lineWidth: 2.5

        Text {
            anchors.centerIn: parent
            text: Audio.muted ? Icons.volumeOff : (Audio.volumePercent > 60 ? Icons.volumeHigh : Icons.volumeLow)
            color: Audio.muted ? Colors.outline : Colors.onBackground
            font.family: Style.fontFamily
            font.pixelSize: Style.fsIcon(8)
        }
    }

    HoverHandler {
        id: hover
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onTapped: (eventPoint, button) => {
            if (button === Qt.RightButton)
                Audio.toggleMute();
            else
                Audio.toggleMute();
        }
    }

    WheelHandler {
        onWheel: event => {
            if (event.angleDelta.y > 0)
                Audio.increment();
            else
                Audio.decrement();
        }
    }

    Tooltip {
        parent: root
        x: (root.width - width) / 2
        y: -height - 6
        text: Audio.muted ? "Muted" : (Audio.volumePercent + "%")
        visible: hover.hovered
    }
}
