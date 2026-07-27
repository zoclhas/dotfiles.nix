import QtQuick

import qs.services

Item {
  id: root

  property real value: 0
  property bool playing: false
  property real startAngleDeg: 200
  property real spanAngleDeg: 140
  property color trackColor: Colors.surfaceVariant
  property color progressColor: Colors.primary
  property real lineWidth: 3
  property real amplitude: 2.5
  property real frequency: 10

  signal seekRequested(real value)

  property bool dragging: false
  property real phase: 0

  NumberAnimation on phase {
    running: root.playing
    from: 0
    to: Math.PI * 2
    duration: 2600
    loops: Animation.Infinite
  }

  onPhaseChanged: canvas.requestPaint()
  onValueChanged: if (!root.dragging) canvas.requestPaint()

  Canvas {
    id: canvas
    anchors.fill: parent

    onPaint: {
      const ctx = getContext("2d");
      ctx.reset();

      const cx = width / 2;
      const cy = height / 2;
      const r = Math.min(width, height) / 2 - root.lineWidth - root.amplitude;
      const start = root.startAngleDeg * Math.PI / 180;
      const span = root.spanAngleDeg * Math.PI / 180;

      function pathFor(fromT, toT, wavy) {
        ctx.beginPath();
        const steps = 96;
        for (let i = 0; i <= steps; i++) {
          const t = fromT + (toT - fromT) * (i / steps);
          const angle = start + span * t;
          const wave = wavy ? Math.sin(angle * root.frequency + root.phase) * root.amplitude : 0;
          const rr = r + wave;
          const x = cx + rr * Math.cos(angle);
          const y = cy + rr * Math.sin(angle);
          if (i === 0) ctx.moveTo(x, y);
          else ctx.lineTo(x, y);
        }
        ctx.stroke();
      }

      ctx.lineCap = "round";
      ctx.lineWidth = root.lineWidth;

      ctx.strokeStyle = root.trackColor;
      pathFor(0, 1, false);

      const clamped = Math.max(0, Math.min(1, root.value));
      if (clamped > 0) {
        ctx.strokeStyle = root.progressColor;
        pathFor(0, clamped, root.playing);
      }
    }
  }

  function angleForPoint(x, y) {
    const cx = width / 2;
    const cy = height / 2;
    let angle = Math.atan2(y - cy, x - cx);
    const start = root.startAngleDeg * Math.PI / 180;
    let span = root.spanAngleDeg * Math.PI / 180;
    let rel = angle - start;
    while (rel < 0) rel += Math.PI * 2;
    while (rel > Math.PI * 2) rel -= Math.PI * 2;
    return Math.max(0, Math.min(1, rel / span));
  }

  MouseArea {
    anchors.fill: parent
    onPressed: mouse => {
      root.dragging = true;
      root.value = root.angleForPoint(mouse.x, mouse.y);
      canvas.requestPaint();
    }
    onPositionChanged: mouse => {
      if (root.dragging) {
        root.value = root.angleForPoint(mouse.x, mouse.y);
        canvas.requestPaint();
      }
    }
    onReleased: {
      root.dragging = false;
      root.seekRequested(root.value);
    }
  }
}
