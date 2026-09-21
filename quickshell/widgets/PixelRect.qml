import QtQuick

Rectangle {
    id: root

    property color colorTopEnd: root.color
    property color colorBottomStart: root.color
    property color colorBottom: root.color
    property real split: 0.5
    property bool horizontal: false

    antialiasing: false

    gradient: Gradient {
        orientation: root.horizontal ? Gradient.Horizontal : Gradient.Vertical

        GradientStop {
            position: 0
            color: root.color
        }
        GradientStop {
            position: root.split
            color: root.colorTopEnd
        }
        GradientStop {
            position: Math.min(1, root.split + 0.001)
            color: root.colorBottomStart
        }
        GradientStop {
            position: 1
            color: root.colorBottom
        }
    }
}
