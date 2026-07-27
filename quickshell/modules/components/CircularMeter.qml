import QtQuick

import qs.services

Item {
  id: root

  default property alias content: centerSlot.data

  property real value: 0
  property real overdriveBoundary: 1
  property real size: 28
  property real lineWidth: 3
  property real gapDeg: 45
  property color trackColor: Colors.surfaceVariant
  property color progressColor: Colors.primary
  property color overdriveColor: Colors.error

  implicitWidth: size
  implicitHeight: size

  readonly property real startAngle: (90 + gapDeg / 2) * Math.PI / 180
  readonly property real totalAngle: (360 - gapDeg) * Math.PI / 180

  Behavior on value {
    NumberAnimation { duration: 240; easing.type: Easing.OutCubic }
  }

  Canvas {
    id: canvas
    anchors.fill: parent

    onPaint: {
      const ctx = getContext("2d");
      ctx.reset();

      const cx = width / 2;
      const cy = height / 2;
      const r = Math.min(width, height) / 2 - root.lineWidth / 2;

      ctx.lineCap = "round";
      ctx.lineWidth = root.lineWidth;

      ctx.strokeStyle = root.trackColor;
      ctx.beginPath();
      ctx.arc(cx, cy, r, root.startAngle, root.startAngle + root.totalAngle, false);
      ctx.stroke();

      const clamped = Math.max(0, Math.min(1, root.value));
      const boundary = Math.max(0, Math.min(1, root.overdriveBoundary));
      const primary = Math.min(clamped, boundary);

      if (primary > 0) {
        ctx.strokeStyle = root.progressColor;
        ctx.beginPath();
        ctx.arc(cx, cy, r, root.startAngle, root.startAngle + root.totalAngle * primary, false);
        ctx.stroke();
      }

      if (clamped > boundary) {
        ctx.strokeStyle = root.overdriveColor;
        ctx.beginPath();
        ctx.arc(cx, cy, r, root.startAngle + root.totalAngle * boundary, root.startAngle + root.totalAngle * clamped, false);
        ctx.stroke();
      }

      if (boundary < 1) {
        const tickAngle = root.startAngle + root.totalAngle * boundary;
        ctx.strokeStyle = root.trackColor;
        ctx.lineWidth = 1.5;
        ctx.beginPath();
        ctx.moveTo(cx + Math.cos(tickAngle) * (r - root.lineWidth / 2 - 1), cy + Math.sin(tickAngle) * (r - root.lineWidth / 2 - 1));
        ctx.lineTo(cx + Math.cos(tickAngle) * (r + root.lineWidth / 2 + 1), cy + Math.sin(tickAngle) * (r + root.lineWidth / 2 + 1));
        ctx.stroke();
      }
    }
  }

  onValueChanged: canvas.requestPaint()
  onOverdriveBoundaryChanged: canvas.requestPaint()
  onProgressColorChanged: canvas.requestPaint()
  onOverdriveColorChanged: canvas.requestPaint()
  onTrackColorChanged: canvas.requestPaint()
  Component.onCompleted: canvas.requestPaint()

  Item {
    id: centerSlot
    anchors.fill: parent
  }
}
