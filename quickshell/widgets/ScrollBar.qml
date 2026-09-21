import QtQuick

import qs.services

Item {
    id: root

    required property Flickable target

    implicitWidth: 16
    visible: root.target.contentHeight > root.target.height

    readonly property real ratio: root.target.height / Math.max(1, root.target.contentHeight)
    readonly property real thumbH: Math.max(24, root.height * root.ratio)
    readonly property real travel: Math.max(1, root.height - root.thumbH)
    readonly property real maxY: Math.max(1, root.target.contentHeight - root.target.height)

    Bevel {
        anchors.fill: parent
        style: "inset"
        depth: 1
        faceColor: Theme.well
    }

    Bevel {
        id: thumb
        x: Theme.px
        width: parent.width - 2 * Theme.px
        height: root.thumbH
        y: root.travel * ((root.target.contentY - root.target.originY) / root.maxY)
        style: drag.active ? "inset" : "outset"
        depth: 1
    }

    MouseArea {
        id: drag
        anchors.fill: parent
        property bool active: false
        cursorShape: Qt.PointingHandCursor
        function seek(y) {
            const f = Math.max(0, Math.min(1, (y - root.thumbH / 2) / root.travel));
            root.target.contentY = root.target.originY + f * root.maxY;
        }
        onPressed: event => {
            active = true;
            seek(event.y);
        }
        onReleased: active = false
        onPositionChanged: event => {
            if (active)
                seek(event.y);
        }
    }
}
