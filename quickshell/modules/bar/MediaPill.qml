import QtQuick

import qs.services
import qs.modules.components

StyledRect {
  id: root

  signal activated()

  readonly property bool active: Media.hasActivePlayer

  color: Colors.surface
  radius: Style.radius

  implicitHeight: Style.barHeight
  implicitWidth: root.active ? (row.implicitWidth + Style.pillPadding * 2) : 0
  opacity: root.active ? 1 : 0
  clip: true

  Behavior on implicitWidth {
    NumberAnimation { duration: Style.morphDuration; easing.type: Style.morphEasing }
  }
  Behavior on opacity {
    NumberAnimation { duration: Style.morphDuration; easing.type: Style.morphEasing }
  }

  MouseArea {
    anchors.fill: parent
    onClicked: root.activated()
  }

  Row {
    id: row
    anchors.centerIn: parent
    spacing: Style.spacingXs

    Button {
      width: 26
      height: 26
      anchors.verticalCenter: parent.verticalCenter
      baseColor: Qt.rgba(0, 0, 0, 0)
      hoverColor: Colors.surfaceVariant
      onClicked: Media.previous()

      Text {
        anchors.centerIn: parent
        text: Icons.stepBackward
        color: Colors.onBackground
        font.family: Style.fontFamily
        font.pixelSize: Style.fsIcon(-4)
      }
    }

    Button {
      width: 26
      height: 26
      anchors.verticalCenter: parent.verticalCenter
      baseColor: Qt.rgba(0, 0, 0, 0)
      hoverColor: Colors.surfaceVariant
      onClicked: Media.togglePlaying()

      Text {
        anchors.centerIn: parent
        text: Media.isPlaying ? Icons.pause : Icons.play
        color: Colors.primary
        font.family: Style.fontFamily
        font.pixelSize: Style.fsIcon(-4)
      }
    }

    Button {
      width: 26
      height: 26
      anchors.verticalCenter: parent.verticalCenter
      baseColor: Qt.rgba(0, 0, 0, 0)
      hoverColor: Colors.surfaceVariant
      onClicked: Media.next()

      Text {
        anchors.centerIn: parent
        text: Icons.stepForward
        color: Colors.onBackground
        font.family: Style.fontFamily
        font.pixelSize: Style.fsIcon(-4)
      }
    }

    MarqueeText {
      anchors.verticalCenter: parent.verticalCenter
      maxWidth: 140
      text: root.active ? (Media.title + (Media.artist ? " — " + Media.artist : "")) : ""
      maxChars: 30
      fontPixelSize: Style.fs(-1)
      fadeColor: Colors.surface
    }
  }
}
