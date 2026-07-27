pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Networking

Singleton {
  id: root

  readonly property var devices: Networking.devices.values
  readonly property var wifiDevices: root.devices.filter(d => d.type === DeviceType.Wifi)
  readonly property var wiredDevices: root.devices.filter(d => d.type === DeviceType.Wired)

  readonly property var activeWired: root.wiredDevices.find(d => d.connected) ?? null
  readonly property var activeWifi: root.wifiDevices.find(d => d.connected) ?? null

  readonly property bool ethernetConnected: root.activeWired !== null
  readonly property bool wifiConnected: root.activeWifi !== null

  readonly property var activeWifiNetwork: root.activeWifi
    ? (root.activeWifi.networks.values.find(n => n.connected) ?? null)
    : null

  readonly property string wifiSsid: root.activeWifiNetwork?.name ?? ""
  readonly property real wifiSignal: root.activeWifiNetwork?.signalStrength ?? 0
  readonly property bool wifiEnabled: Networking.wifiEnabled
  readonly property bool wifiHardwareEnabled: Networking.wifiHardwareEnabled

  readonly property string activeInterface: root.ethernetConnected
    ? root.activeWired.name
    : (root.wifiConnected ? root.activeWifi.name : "")

  function toggleWifi() { Networking.wifiEnabled = !Networking.wifiEnabled; }

  property real downloadSpeed: 0
  property real uploadSpeed: 0
  property real _lastRx: -1
  property real _lastTx: -1
  property string _lastIface: ""

  Timer {
    interval: 1000
    running: root.activeInterface !== ""
    repeat: true
    triggeredOnStart: true
    onTriggered: speedProc.running = true
  }

  onActiveInterfaceChanged: {
    root._lastRx = -1;
    root._lastTx = -1;
  }

  Process {
    id: speedProc
    command: ["sh", "-c", root.activeInterface !== ""
      ? `cat /sys/class/net/${root.activeInterface}/statistics/rx_bytes /sys/class/net/${root.activeInterface}/statistics/tx_bytes 2>/dev/null`
      : "true"]
    stdout: StdioCollector {
      onStreamFinished: {
        const lines = text.trim().split("\n");
        if (lines.length < 2) return;
        const rx = parseFloat(lines[0]);
        const tx = parseFloat(lines[1]);
        if (root._lastRx >= 0 && !isNaN(rx) && !isNaN(tx)) {
          root.downloadSpeed = Math.max(0, rx - root._lastRx);
          root.uploadSpeed = Math.max(0, tx - root._lastTx);
        }
        root._lastRx = rx;
        root._lastTx = tx;
      }
    }
  }

  function formatSpeed(bytesPerSec) {
    if (!bytesPerSec || bytesPerSec < 1024) return (bytesPerSec || 0).toFixed(0) + " B/s";
    if (bytesPerSec < 1024 * 1024) return (bytesPerSec / 1024).toFixed(1) + " KB/s";
    return (bytesPerSec / 1024 / 1024).toFixed(1) + " MB/s";
  }
}
