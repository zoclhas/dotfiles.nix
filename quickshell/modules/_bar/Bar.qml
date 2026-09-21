import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.services

PanelWindow {
  id: root

  required property ShellScreen targetScreen

  screen: root.targetScreen

  anchors { bottom: true; left: true; right: true }
  implicitHeight: Style.barHeight + Style.screenMargin + Style.shadowMargin
  exclusiveZone: Style.barHeight + Style.screenMargin
  color: "transparent"

  WlrLayershell.layer: WlrLayer.Top
  WlrLayershell.namespace: "zochell-bar"

  BarContent {
    anchors.fill: parent
    barWindow: root
  }
}
