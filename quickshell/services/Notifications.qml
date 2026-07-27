pragma Singleton
import QtQuick
import QtQml.Models
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

Singleton {
  id: root

  property ListModel list: ListModel {}
  property ListModel popups: ListModel {}
  property bool dndEnabled: false

  signal popupAdded(int index)

  function toggleDnd() { root.dndEnabled = !root.dndEnabled; }

  NotificationServer {
    id: server
    actionsSupported: true
    bodySupported: true
    bodyMarkupSupported: true
    bodyHyperlinksSupported: true
    bodyImagesSupported: true
    imageSupported: true
    keepOnReload: false

    onNotification: notification => {
      notification.tracked = true;

      const entry = {
        notifId: notification.id,
        appName: notification.appName || "Notification",
        appIcon: notification.appIcon,
        summary: notification.summary,
        body: notification.body,
        image: notification.image,
        urgency: notification.urgency,
        time: Date.now(),
        actionIdentifiers: notification.actions.map(a => a.identifier),
        actionTexts: notification.actions.map(a => a.text)
      };

      root.list.insert(0, entry);
      if (!root.dndEnabled) {
        root.popups.insert(0, entry);
        root.popupAdded(0);
      }

      notification.closed.connect(() => root.removeById(notification.id));

      const timeout = notification.expireTimeout > 0 ? notification.expireTimeout
        : (notification.urgency === NotificationUrgency.Critical ? 0 : 6000);
      if (timeout > 0) {
        const timer = timerComponent.createObject(root, { interval: timeout, notifId: notification.id });
        timer.start();
      }

      root._notifObjects[notification.id] = notification;
    }
  }

  property var _notifObjects: ({})

  Component {
    id: timerComponent
    Timer {
      property int notifId: -1
      repeat: false
      onTriggered: {
        root.dismissPopup(notifId);
        destroy();
      }
    }
  }

  function _indexInList(id) {
    for (let i = 0; i < root.list.count; i++) if (root.list.get(i).notifId === id) return i;
    return -1;
  }

  function _indexInPopups(id) {
    for (let i = 0; i < root.popups.count; i++) if (root.popups.get(i).notifId === id) return i;
    return -1;
  }

  function removeById(id) {
    const li = root._indexInList(id);
    if (li !== -1) root.list.remove(li);
    root.dismissPopup(id);
    delete root._notifObjects[id];
  }

  function dismissPopup(id) {
    const pi = root._indexInPopups(id);
    if (pi !== -1) root.popups.remove(pi);
  }

  function dismiss(id) {
    const obj = root._notifObjects[id];
    if (obj) obj.dismiss();
    else root.removeById(id);
  }

  function dismissAll() {
    while (root.list.count > 0) root.dismiss(root.list.get(0).notifId);
  }

  function invokeAction(id, identifier) {
    const obj = root._notifObjects[id];
    if (!obj) return;
    const action = obj.actions.find(a => a.identifier === identifier);
    if (action) action.invoke();
  }

  IpcHandler {
    target: "notifications"

    function dismissAll(): void { root.dismissAll(); }
    function toggleDnd(): void { root.toggleDnd(); }
  }
}
