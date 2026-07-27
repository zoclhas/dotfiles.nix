pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string devicePath: ""
    property int raw: 0
    property int max: 1
    readonly property int percentage: max > 0 ? Math.round((raw / max) * 100) : 0
    readonly property bool ready: devicePath !== ""

    Process {
        id: detect
        command: ["sh", "-c", "ls /sys/class/backlight | head -n1"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const name = data.trim();
                if (name.length > 0) {
                    root.devicePath = "/sys/class/backlight/" + name;
                    maxFile.path = root.devicePath + "/max_brightness";
                    rawFile.path = root.devicePath + "/brightness";
                }
            }
        }
    }

    FileView {
        id: maxFile
        watchChanges: false
        onLoaded: root.max = parseInt(text(), 10) || 1
    }

    FileView {
        id: rawFile
        watchChanges: true
        onFileChanged: reload()
        onLoaded: root.raw = parseInt(text(), 10) || 0
    }

    function setPercentage(pct) {
        const clamped = Math.max(0, Math.min(100, Math.round(pct)));
        setProc.command = ["brightnessctl", "set", clamped + "%"];
        setProc.running = true;
    }

    function increment(step) {
        root.setPercentage(root.percentage + (step ?? 5));
    }

    function decrement(step) {
        root.setPercentage(root.percentage - (step ?? 5));
    }

    Process {
        id: setProc
        command: ["brightnessctl", "set", "100%"]
    }

    IpcHandler {
        target: "brightness"

        function increment(step: real): void {
            root.increment(step);
        }
        function decrement(step: real): void {
            root.decrement(step);
        }
        function set(value: real): void {
            root.setPercentage(value);
        }
    }
}
