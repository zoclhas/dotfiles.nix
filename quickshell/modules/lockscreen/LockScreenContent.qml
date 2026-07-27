import QtQuick
import Quickshell.Services.Pam

import qs.services
import qs.modules.components

Item {
  id: root

  required property bool lockSecure
  property date currentTime: new Date()
  property bool startAnim: false

  readonly property bool shown: root.startAnim && root.lockSecure
  readonly property real slideOffset: root.shown ? 0 : height

  opacity: root.shown ? 1 : 0

  Behavior on opacity {
    NumberAnimation { duration: 480; easing.type: Easing.OutCubic }
  }

  Timer {
    id: entryTimer
    interval: 32
    running: true
    onTriggered: root.startAnim = true
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: root.currentTime = new Date()
  }

  Rectangle {
    anchors.fill: parent
    color: Colors.background
  }

  Image {
    anchors.fill: parent
    source: "file://" + Session.lockBgPath
    fillMode: Image.PreserveAspectCrop
    cache: false
    asynchronous: true
  }

  Item {
    id: content
    anchors.fill: parent
    y: root.slideOffset

    Behavior on y {
      NumberAnimation { duration: 480; easing.type: Easing.OutCubic }
    }

    Rectangle {
      anchors.fill: parent
      color: Colors.background
      opacity: 0.94
    }

    Column {
      anchors.centerIn: parent
      spacing: Style.spacingXl

      Text {
        anchors.horizontalCenter: parent.horizontalCenter
        text: Qt.formatTime(root.currentTime, "hh:mm")
        color: Colors.onBackground
        font.family: Style.fontFamily
        font.pixelSize: Style.fs(20)
        font.bold: true
      }

      Text {
        anchors.horizontalCenter: parent.horizontalCenter
        text: Qt.formatDate(root.currentTime, "dddd, d MMMM")
        color: Colors.onBackground
        opacity: 0.7
        font.family: Style.fontFamily
        font.pixelSize: Style.fs(1)
      }

      StyledRect {
        anchors.horizontalCenter: parent.horizontalCenter
        width: 280
        height: 48
        radius: Style.radius
        color: Colors.surfaceVariant
        borderEnabled: true
        borderColor: pam.messageIsError ? Colors.error : Colors.outline

        property real shakeOffset: 0
        x: shakeOffset

        SequentialAnimation {
          id: shakeAnim
          NumberAnimation { target: parent; property: "shakeOffset"; to: -8; duration: 50 }
          NumberAnimation { target: parent; property: "shakeOffset"; to: 8; duration: 50 }
          NumberAnimation { target: parent; property: "shakeOffset"; to: -6; duration: 50 }
          NumberAnimation { target: parent; property: "shakeOffset"; to: 0; duration: 50 }
        }

        TextInput {
          id: passwordField
          anchors.fill: parent
          anchors.margins: Style.spacingMd
          verticalAlignment: TextInput.AlignVCenter
          color: Colors.onBackground
          font.family: Style.fontFamily
          font.pixelSize: Style.fs(0)
          echoMode: TextInput.Password
          focus: root.lockSecure
          clip: true

          Text {
            anchors.verticalCenter: parent.verticalCenter
            visible: passwordField.text.length === 0
            text: pam.active ? "Checking..." : "Enter password"
            color: Colors.onBackground
            opacity: 0.5
            font.family: Style.fontFamily
            font.pixelSize: Style.fs(0)
          }

          Keys.onReturnPressed: root.trySubmit()
          Keys.onEnterPressed: root.trySubmit()
        }
      }
    }
  }

  function trySubmit() {
    if (pam.active || passwordField.text.length === 0) return;
    pam.start();
  }

  PamContext {
    id: pam
    configDirectory: Qt.resolvedUrl("../../config/pam").toString().replace("file://", "")
    config: "password.conf"

    onPamMessage: {
      if (responseRequired) respond(passwordField.text);
    }

    onCompleted: result => {
      if (result === PamResult.Success) {
        Session.unlock();
      } else {
        shakeAnim.start();
      }
      passwordField.text = "";
    }
  }
}
