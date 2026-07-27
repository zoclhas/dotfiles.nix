pragma Singleton
import QtQuick
import Quickshell
import Niri

Singleton {
  id: root

  readonly property alias workspaces: niri.workspaces
  readonly property alias windows: niri.windows
  readonly property alias focusedWindow: niri.focusedWindow
  property bool connected: false

  function focusWorkspace(index) { return niri.focusWorkspace(index); }
  function focusWorkspaceById(id) { return niri.focusWorkspaceById(id); }
  function focusWindow(id) { return niri.focusWindow(id); }
  function closeWindow(id) { return niri.closeWindow(id); }
  function toggleOverview() { return niri.toggleOverview(); }
  function sendRawAction(action) { return niri.sendRawAction(action); }

  Niri {
    id: niri
    Component.onCompleted: connect()
    onConnected: root.connected = true
    onDisconnected: root.connected = false
    onErrorOccurred: function(error) {
      console.error("Niri error:", error);
    }
  }
}
