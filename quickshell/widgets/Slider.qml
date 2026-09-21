import QtQuick

import qs.services

Item {
    id: root

    property real from: 0
    property real to: 1
    property real value: 0
    property real stepSize: 0
    property real wheelStep: (root.to - root.from) / 20

    signal moved(real value)

    implicitHeight: Theme.buttonHeight

    readonly property real ratio: root.to > root.from ? Math.max(0, Math.min(1, (root.value - root.from) / (root.to - root.from))) : 0

    function _set(v) {
        let n = Math.max(root.from, Math.min(root.to, v));
        if (root.stepSize > 0)
            n = root.from + Math.round((n - root.from) / root.stepSize) * root.stepSize;
        if (n !== root.value)
            root.moved(n);
    }

    Bevel {
        id: track
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: Theme.px * 4 + 2
        style: "inset"
        depth: 1
        faceColor: Theme.well

        Rectangle {
            x: track.insetX
            y: track.insetY
            width: Math.max(0, (track.width - 2 * track.insetX) * root.ratio)
            height: track.height - 2 * track.insetY
            color: Theme.accent
        }
    }

    Bevel {
        id: handle
        readonly property int hw: Theme.px * 5
        x: Math.round((root.width - hw) * root.ratio)
        anchors.verticalCenter: parent.verticalCenter
        width: hw
        height: root.height - Theme.px * 2
        style: mouse.pressed ? "inset" : "outset"
        depth: 1
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        function fromX(x) {
            const hw = handle.hw;
            const r = (x - hw / 2) / Math.max(1, root.width - hw);
            root._set(root.from + Math.max(0, Math.min(1, r)) * (root.to - root.from));
        }

        onPressed: m => fromX(m.x)
        onPositionChanged: m => {
            if (pressed)
                fromX(m.x);
        }
        onWheel: w => root._set(root.value + (w.angleDelta.y > 0 ? 1 : -1) * (root.stepSize > 0 ? root.stepSize : root.wheelStep))
    }
}
