import QtQuick

import qs.services

Item {
    id: root

    property int corner: 0
    property color cornerColor: "black"
    property real size: Style.bezelRadius

    implicitWidth: size
    implicitHeight: size

    Canvas {
        id: canvas
        anchors.fill: parent

        onPaint: {
            const ctx = getContext("2d");
            ctx.reset();
            const s = root.size;

            ctx.fillStyle = root.cornerColor;
            ctx.fillRect(0, 0, s, s);

            let cx = 0;
            let cy = 0;
            if (root.corner === 0) {
                cx = s;
                cy = s;
            } else if (root.corner === 1) {
                cx = 0;
                cy = s;
            } else if (root.corner === 2) {
                cx = s;
                cy = 0;
            } else {
                cx = 0;
                cy = 0;
            }

            ctx.globalCompositeOperation = "destination-out";
            ctx.beginPath();
            ctx.arc(cx, cy, s, 0, Math.PI * 2);
            ctx.fill();
        }
    }

    onCornerColorChanged: canvas.requestPaint()
    onSizeChanged: canvas.requestPaint()
    Component.onCompleted: canvas.requestPaint()
}
