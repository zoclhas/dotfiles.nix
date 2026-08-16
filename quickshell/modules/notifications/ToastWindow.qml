import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.services
import qs.modules.bar.dashboard

PanelWindow {
  id: root

  required property ShellScreen targetScreen
  screen: root.targetScreen

  property int notifId: -1
  property string appName: ""
  property string appIcon: ""
  property string summary: ""
  property string body: ""
  property string image: ""
  property int urgency: 1
  property double time: 0
  property var actionIdentifiers: []
  property var actionTexts: []
  property bool hasInlineReply: false
  property string inlineReplyPlaceholder: ""

  property real stackOffset: 0
  readonly property int cardWidth: 340
  readonly property real dismissThreshold: cardWidth * 0.35

  signal cardHeightChanged(int notifId, real height)
  signal dismissed(int notifId)

  anchors { top: true; right: true }
  margins.top: Style.screenMargin + root.stackOffset
  margins.right: Style.screenMargin

  implicitWidth: root.cardWidth
  implicitHeight: card.implicitHeight
  color: "transparent"
  exclusionMode: ExclusionMode.Ignore

  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.namespace: "zochell-notifications"

  Behavior on margins.top {
    NumberAnimation { duration: Style.morphDuration; easing.type: Style.morphEasing }
  }

  mask: Region { item: card }
  BackgroundEffect.blurRegion: Region { item: card }

  onImplicitHeightChanged: root.cardHeightChanged(root.notifId, root.implicitHeight)
  Component.onCompleted: {
    root.cardHeightChanged(root.notifId, root.implicitHeight);
    entrance.start();
  }

  NotificationCard {
    id: card
    width: root.cardWidth
    isPopup: true

    notifId: root.notifId
    appName: root.appName
    appIcon: root.appIcon
    summary: root.summary
    body: root.body
    image: root.image
    urgency: root.urgency
    time: root.time
    actionIdentifiers: root.actionIdentifiers
    actionTexts: root.actionTexts
    read: false
    hasInlineReply: root.hasInlineReply
    inlineReplyPlaceholder: root.inlineReplyPlaceholder

    opacity: 0

    Behavior on x {
      enabled: !dragHandler.active
      NumberAnimation { duration: Style.quickDuration; easing.type: Easing.OutCubic }
    }

    ParallelAnimation {
      id: entrance
      NumberAnimation { target: card; property: "opacity"; to: 1; duration: Style.fadeDuration }
      NumberAnimation { target: card; property: "x"; from: root.cardWidth; to: 0; duration: Style.morphDuration; easing.type: Easing.OutCubic }
    }

    DragHandler {
      id: dragHandler
      target: card
      yAxis.enabled: false
      onActiveChanged: {
        if (!active) {
          if (Math.abs(card.x) > root.dismissThreshold) {
            root.dismissed(root.notifId);
          } else {
            card.x = 0;
          }
        }
      }
    }
  }
}
