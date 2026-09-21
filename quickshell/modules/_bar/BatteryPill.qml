import QtQuick
import Quickshell.Io

import qs.services
import qs.modules.components

Item {
  id: root

  required property var barWindow

  visible: Battery.available
  implicitWidth: Style.barHeight
  implicitHeight: Style.barHeight

  readonly property color levelColor: Battery.charging ? Colors.primary
    : Battery.level === "critical" ? Colors.error
    : Battery.level === "low" ? Colors.tertiary
    : Battery.level === "medium" ? Colors.secondary : Colors.primary

  StyledRect {
    anchors.fill: parent
    color: Colors.surface
    radius: Style.radius

    CircularMeter {
      anchors.fill: parent
      anchors.margins: 4
      value: Battery.percentage / 100
      progressColor: root.levelColor
      lineWidth: 2.5

      Text {
        anchors.centerIn: parent
        text: Battery.charging ? Icons.bolt : (Battery.level === "critical" ? Icons.batteryAlert : Icons.batteryFull)
        color: root.levelColor
        font.family: Style.fontFamily
        font.pixelSize: Style.fsIcon(-2)
      }
    }

    HoverHandler {
      id: hover
      cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
      acceptedButtons: Qt.LeftButton | Qt.RightButton
      onTapped: (eventPoint, button) => {
        if (button === Qt.RightButton) Session.powerMenuOpen = !Session.powerMenuOpen;
        else panelLoader.item.toggle();
      }
    }

    Tooltip {
      parent: root
      x: (root.width - width) / 2
      y: -height - 6
      text: Battery.percent + "%" + (Battery.charging ? " (charging)" : "")
      visible: hover.hovered && !panelLoader.item.panelOpen
    }
  }

  Loader {
    id: panelLoader
    active: true
    sourceComponent: MorphPanel {
      layerNamespace: "zochell-battery"
      panelWidth: 300
      panelHeight: 160
      pillWidth: Style.barHeight
      pillHeight: Style.barHeight
      align: "right"
      screen: root.barWindow?.screen ?? null

      panelContent: BatteryStatusPanel {
        anchors.fill: parent
      }
    }
  }

  IpcHandler {
    target: "battery"
    function toggle(): void { panelLoader.item.toggle(); }
    function open(): void { panelLoader.item.open(); }
    function close(): void { panelLoader.item.close(); }
  }
}
