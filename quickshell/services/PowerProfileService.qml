pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  readonly property var profiles: ["PowerSaver", "Balanced", "Performance"]
  readonly property var cliNames: ({ "PowerSaver": "power-saver", "Balanced": "balanced", "Performance": "performance" })

  property string current: "Balanced"
  readonly property string niriConfigPath: "/home/zoc/.config/niri/config.kdl"
  readonly property string niriOutputsPath: "/home/zoc/.config/niri/outputs.kdl"

  onCurrentChanged: root.syncNiriPowerSaving()

  function syncNiriPowerSaving() {
    if (root.current === "PowerSaver") {
      niriEnableProc.running = true;
      niriRefreshLowProc.running = true;
    } else {
      niriDisableProc.running = true;
      niriRefreshHighProc.running = true;
    }
  }

  function setProfile(name) {
    const cli = root.cliNames[name] ?? "balanced";
    setProc.command = ["powerprofilesctl", "set", cli];
    setProc.running = true;
    root.current = name;
  }

  function cycle() {
    const idx = root.profiles.indexOf(root.current);
    root.setProfile(root.profiles[(idx + 1) % root.profiles.length]);
  }

  function refresh() {
    getProc.running = true;
  }

  Process {
    id: setProc
  }

  Process {
    id: niriEnableProc
    command: ["sed", "-i", "s|^// include \"power-saving.kdl\"|include \"power-saving.kdl\"|", root.niriConfigPath]
  }

  Process {
    id: niriDisableProc
    command: ["sed", "-i", "s|^include \"power-saving.kdl\"|// include \"power-saving.kdl\"|", root.niriConfigPath]
  }

  Process {
    id: niriRefreshLowProc
    command: ["sed", "-i", "s|1920x1080@144.000|1920x1080@60.002|", root.niriOutputsPath]
  }

  Process {
    id: niriRefreshHighProc
    command: ["sed", "-i", "s|1920x1080@60.002|1920x1080@144.000|", root.niriOutputsPath]
  }

  Process {
    id: getProc
    command: ["powerprofilesctl", "get"]
    stdout: StdioCollector {
      onStreamFinished: {
        const val = text.trim();
        if (val === "performance") root.current = "Performance";
        else if (val === "power-saver") root.current = "PowerSaver";
        else if (val === "balanced") root.current = "Balanced";
      }
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  IpcHandler {
    target: "powerProfile"

    function set(name: string): void { root.setProfile(name); }
    function cycle(): void { root.cycle(); }
  }
}
