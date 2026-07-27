pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Keyboard backlight service for the ASUS TUF A15's `asus::kbd_backlight`
// LED. Reads are polled straight from sysfs via FileView (sysfs LED
// brightness attributes don't emit inotify events, so watchChanges/
// onFileChanged never fires even though `cat` shows the value changing
// live). Writes go through `asusctl leds set/next/prev`, since asusd
// handles the permissions a plain user doesn't have for the sysfs node.
Singleton {
  id: root

  property int maxLevel: 3
  property int level: 0
  readonly property bool ready: true
  readonly property int percentage: maxLevel > 0 ? Math.round((level / maxLevel) * 100) : 0

  readonly property string sysfsPath: "/sys/class/leds/asus::kbd_backlight/brightness"
  readonly property string sysfsMaxPath: "/sys/class/leds/asus::kbd_backlight/max_brightness"
  readonly property var levelNames: ["off", "low", "med", "high"]

  function next() {
    setProc.command = ["asusctl", "leds", "next"];
    setProc.running = true;
  }

  function prev() {
    setProc.command = ["asusctl", "leds", "prev"];
    setProc.running = true;
  }

  function setLevel(newLevel) {
    const clamped = Math.max(0, Math.min(root.maxLevel, newLevel));
    if (clamped === root.level) return;
    const name = root.levelNames[clamped] ?? root.levelNames[root.levelNames.length - 1];
    setProc.command = ["asusctl", "leds", "set", name];
    setProc.running = true;
  }

  function setPercentage(pct) {
    root.setLevel(Math.round((Math.max(0, Math.min(100, pct)) / 100) * root.maxLevel));
  }

  Process { id: setProc }

  FileView {
    id: maxFile
    path: root.sysfsMaxPath
    watchChanges: false
    onLoaded: {
      const n = parseInt(text().trim());
      if (!isNaN(n) && n > 0) root.maxLevel = n;
    }
  }

  FileView {
    id: levelFile
    path: root.sysfsPath

    function updateLevel() {
      const n = parseInt(text().trim());
      if (!isNaN(n)) root.level = n;
    }

    onLoaded: updateLevel()
    onTextChanged: updateLevel()
  }

  Timer {
    interval: 200
    running: true
    repeat: true
    onTriggered: levelFile.reload()
  }

  IpcHandler {
    target: "kbdBacklight"

    function next(): void { root.next(); }
    function prev(): void { root.prev(); }
    function set(level: int): void { root.setLevel(level); }
  }
}
