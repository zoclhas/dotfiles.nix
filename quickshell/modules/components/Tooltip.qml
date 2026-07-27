import QtQuick
import QtQuick.Controls

import qs.services

ToolTip {
  id: root

  delay: Style.tooltipDelay
  timeout: -1

  contentItem: Text {
    text: root.text
    color: Colors.onBackground
    font.family: Style.fontFamily
    font.pixelSize: Style.fs(-1)
  }

  background: StyledRect {
    color: Colors.surfaceVariant
    radius: Style.radius
    borderEnabled: true
    shadowEnabled: true
  }
}
