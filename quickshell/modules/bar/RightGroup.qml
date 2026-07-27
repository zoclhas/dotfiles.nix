import QtQuick

import qs.services

Row {
  id: root

  required property var barWindow

  spacing: Style.pillGap

  TrayPill {
    anchors.verticalCenter: parent.verticalCenter
  }

  VolumePill {
    anchors.verticalCenter: parent.verticalCenter
  }

  BrightnessPill {
    anchors.verticalCenter: parent.verticalCenter
  }

  BatteryPill {
    anchors.verticalCenter: parent.verticalCenter
    barWindow: root.barWindow
  }
}
