import QtQuick

import qs.services
import qs.modules.components

StyledRect {
  id: root

  required property string screenName

  readonly property real cellSize: Style.barHeight - 8

  color: Colors.surface
  radius: Style.radius
  implicitHeight: Style.barHeight
  implicitWidth: row.implicitWidth + Style.pillPadding * 2

  function recomputeFocus() {
    const count = Niri.workspaces.count;
    for (let i = 0; i < count; i++) {
      const ws = Niri.workspaces.get(i);
      if (ws.output === root.screenName && ws.isFocused) {
        highlight.idx1 = ws.index;
        highlight.idx2 = ws.index;
        return;
      }
    }
  }

  Connections {
    target: Niri.workspaces
    function onDataChanged() { root.recomputeFocus(); }
    function onCountChanged() { root.recomputeFocus(); }
  }

  Component.onCompleted: root.recomputeFocus()

  StyledRect {
    id: highlight
    property real idx1: 0
    property real idx2: 0

    y: (parent.height - height) / 2
    height: root.cellSize
    radius: Style.innerRadius(4)
    color: Colors.secondary

    x: Style.pillPadding + Math.min(idx1 - 1, idx2 - 1) * (root.cellSize + row.spacing)
    width: Math.abs(idx1 - idx2) * (root.cellSize + row.spacing) + root.cellSize

    Behavior on idx1 { NumberAnimation { duration: Style.morphDuration / 3; easing.type: Easing.OutSine } }
    Behavior on idx2 { NumberAnimation { duration: Style.morphDuration; easing.type: Easing.OutSine } }
    Behavior on width { NumberAnimation { duration: Style.morphDuration / 3; easing.type: Easing.OutSine } }
  }

  Row {
    id: row
    anchors.centerIn: parent
    spacing: Style.spacingXs

    Repeater {
      model: Niri.workspaces

      delegate: Item {
        id: wsItem

        required property int index
        required property string output
        required property bool isFocused
        required property bool isUrgent
        required property var id

        readonly property bool onThisScreen: wsItem.output === root.screenName

        visible: wsItem.onThisScreen
        width: wsItem.onThisScreen ? root.cellSize : 0
        height: root.cellSize

        onIsFocusedChanged: if (wsItem.isFocused) root.recomputeFocus()
        onIndexChanged: if (wsItem.isFocused) root.recomputeFocus()

        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: Niri.focusWorkspaceById(wsItem.id)
        }

        Text {
          anchors.centerIn: parent
          text: wsItem.index
          font.family: Style.fontFamily
          font.pixelSize: Style.fs(-1)
          color: wsItem.isUrgent ? Colors.error : (wsItem.isFocused ? Colors.background : Colors.primary)

          Behavior on color { ColorAnimation { duration: Style.quickDuration } }
        }
      }
    }
  }
}
