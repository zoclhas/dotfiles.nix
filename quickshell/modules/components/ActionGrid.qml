import QtQuick

import qs.services

FocusScope {
  id: root

  property var actions: []
  property int buttonSize: 48
  property int iconSize: 20
  property int itemSpacing: 8
  property int currentIndex: 0

  signal actionTriggered(var action)

  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight

  Keys.onLeftPressed: root.currentIndex = Math.max(0, root.currentIndex - 1)
  Keys.onRightPressed: root.currentIndex = Math.min(root.actions.length - 1, root.currentIndex + 1)
  Keys.onReturnPressed: root.trigger(root.currentIndex)
  Keys.onEnterPressed: root.trigger(root.currentIndex)
  Keys.onSpacePressed: root.trigger(root.currentIndex)

  function trigger(i) {
    if (i >= 0 && i < root.actions.length) root.actionTriggered(root.actions[i]);
  }

  StyledRect {
    id: highlight
    property real idx1: root.currentIndex
    property real idx2: root.currentIndex

    y: 0
    x: Math.min(idx1, idx2) * (root.buttonSize + root.itemSpacing)
    width: Math.abs(idx1 - idx2) * (root.buttonSize + root.itemSpacing) + root.buttonSize
    height: root.buttonSize
    radius: Style.radius
    color: Colors.surfaceVariant

    Behavior on idx1 { NumberAnimation { duration: Style.morphDuration / 3; easing.type: Easing.OutSine } }
    Behavior on idx2 { NumberAnimation { duration: Style.morphDuration; easing.type: Easing.OutSine } }
    Behavior on width { NumberAnimation { duration: Style.morphDuration / 3; easing.type: Easing.OutSine } }
  }

  Row {
    id: row
    spacing: root.itemSpacing

    Repeater {
      model: root.actions

      delegate: Button {
        id: delegateButton
        required property var modelData
        required property int index

        width: root.buttonSize
        height: root.buttonSize
        baseColor: Qt.rgba(0, 0, 0, 0)
        hoverColor: Colors.surfaceVariant
        pressColor: Qt.darker(Colors.surfaceVariant, 1.15)
        shadowEnabled: false

        onClicked: {
          root.currentIndex = index;
          root.trigger(index);
        }

        Text {
          anchors.centerIn: parent
          text: delegateButton.modelData.icon ?? ""
          font.family: Style.fontFamily
          font.pixelSize: root.iconSize
          color: Colors.onBackground
        }
      }
    }
  }
}
