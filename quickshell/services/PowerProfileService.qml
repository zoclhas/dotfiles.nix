pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property var profiles: ["PowerSaver", "Balanced", "Performance"]
    readonly property var cliNames: ({
            "PowerSaver": "power-saver",
            "Balanced": "balanced",
            "Performance": "performance"
        })

    property string current: "Balanced"

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
        id: getProc
        command: ["powerprofilesctl", "get"]
        stdout: StdioCollector {
            onStreamFinished: {
                const val = text.trim();
                if (val === "performance")
                    root.current = "Performance";
                else if (val === "power-saver")
                    root.current = "PowerSaver";
                else if (val === "balanced")
                    root.current = "Balanced";
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

        function set(name: string): void {
            root.setProfile(name);
        }
        function cycle(): void {
            root.cycle();
        }
    }
}
