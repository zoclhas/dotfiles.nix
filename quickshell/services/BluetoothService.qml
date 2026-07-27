pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Bluetooth

Singleton {
  id: root

  readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
  readonly property bool available: root.adapter !== null && root.adapter !== undefined
  readonly property bool enabled: root.adapter?.enabled ?? false
  readonly property bool discovering: root.adapter?.discovering ?? false
  readonly property var devices: Bluetooth.devices.values
  readonly property var connectedDevices: root.devices.filter(d => d.connected)
  readonly property bool hasConnected: root.connectedDevices.length > 0

  function toggle() {
    if (root.adapter) root.adapter.enabled = !root.adapter.enabled;
  }

  function setDiscovering(v) {
    if (root.adapter) root.adapter.discovering = v;
  }

  IpcHandler {
    target: "bluetooth"

    function toggle(): void { root.toggle(); }
  }
}
