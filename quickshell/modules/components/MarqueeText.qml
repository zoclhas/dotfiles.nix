import QtQuick

import qs.services

Item {
    id: root

    property string text: ""
    property int maxChars: 30
    property real maxWidth: 220
    property color textColor: Colors.onBackground
    property color fadeColor: Colors.surface
    property real fontPixelSize: Style.fs(0)
    property bool bold: false
    property real speed: 28
    property real gap: 40
    property real fadeWidth: 14
    property real dwell: 1200

    readonly property string clippedText: root.text.length > root.maxChars ? root.text.slice(0, root.maxChars) + "…" : root.text
    readonly property bool overflowing: label.implicitWidth > root.maxWidth

    implicitWidth: Math.min(label.implicitWidth, root.maxWidth)
    implicitHeight: label.implicitHeight
    clip: true

    Behavior on implicitWidth {
        NumberAnimation {
            duration: Style.morphDuration
            easing.type: Style.morphEasing
        }
    }

    Row {
        id: track
        spacing: root.gap
        x: 0

        Text {
            id: label
            text: root.clippedText
            color: root.textColor
            font.family: Style.fontFamily
            font.pixelSize: root.fontPixelSize
            font.bold: root.bold
        }

        Text {
            visible: root.overflowing
            text: root.clippedText
            color: root.textColor
            font.family: Style.fontFamily
            font.pixelSize: root.fontPixelSize
            font.bold: root.bold
        }
    }

    SequentialAnimation {
        id: scrollAnim
        running: root.overflowing && root.width > 0
        loops: Animation.Infinite

        PauseAnimation {
            duration: root.dwell
        }
        NumberAnimation {
            target: track
            property: "x"
            from: 0
            to: -(label.implicitWidth + root.gap)
            duration: (label.implicitWidth + root.gap) / root.speed * 1000
            easing.type: Easing.Linear
        }
        PauseAnimation {
            duration: root.dwell
        }
        NumberAnimation {
            target: track
            property: "x"
            to: 0
            duration: 1
        }
    }

    Rectangle {
        visible: root.overflowing
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        width: root.fadeWidth
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop {
                position: 0.0
                color: root.fadeColor
            }
            GradientStop {
                position: 1.0
                color: Qt.rgba(root.fadeColor.r, root.fadeColor.g, root.fadeColor.b, 0)
            }
        }
    }

    Rectangle {
        visible: root.overflowing
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        width: root.fadeWidth
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop {
                position: 0.0
                color: Qt.rgba(root.fadeColor.r, root.fadeColor.g, root.fadeColor.b, 0)
            }
            GradientStop {
                position: 1.0
                color: root.fadeColor
            }
        }
    }
}
