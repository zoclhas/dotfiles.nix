import QtQuick
import Quickshell

import qs.services

Item {
  id: root

  required property ShellScreen targetScreen

  property var cardHeights: ({})

  function offsetFor(index) {
    let y = 0;
    for (let i = 0; i < index; i++) {
      const id = Notifications.popups.get(i).notifId;
      y += (root.cardHeights[id] ?? 90) + Style.spacingSm;
    }
    return y;
  }

  function reportHeight(id, height) {
    const next = Object.assign({}, root.cardHeights);
    next[id] = height;
    root.cardHeights = next;
  }

  Instantiator {
    model: Notifications.popups

    delegate: ToastWindow {
      required property int index
      required property var model

      targetScreen: root.targetScreen
      stackOffset: root.offsetFor(index)

      notifId: model.notifId
      appName: model.appName
      appIcon: model.appIcon
      summary: model.summary
      body: model.body
      image: model.image
      urgency: model.urgency
      time: model.time
      actionIdentifiers: model.actionIdentifiers
      actionTexts: model.actionTexts

      onCardHeightChanged: (id, height) => root.reportHeight(id, height)
      onDismissed: id => Notifications.dismiss(id)
    }
  }
}
