import QtQuick

import qs.services

Item {
  id: root

  required property var barWindow

  readonly property string screenName: root.barWindow?.screen?.name ?? ""

  Row {
    id: leftGroup
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    anchors.leftMargin: Style.screenMargin
    anchors.bottomMargin: Style.screenMargin
    spacing: Style.pillGap

    SysMonitorPill {
      barWindow: root.barWindow
    }

    WorkspacePill {
      screenName: root.screenName
    }

    TitlePill {}
  }

  MiddleGroup {
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: Style.screenMargin
    barWindow: root.barWindow
  }

  RightGroup {
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.rightMargin: Style.screenMargin
    anchors.bottomMargin: Style.screenMargin
    barWindow: root.barWindow
  }
}
