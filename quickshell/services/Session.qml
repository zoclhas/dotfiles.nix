pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool locked: false

    property string panel: ""

    property string panelHint: ""

    property string _pendingKind: ""
    function togglePanelFocused(kind) {
        root._pendingKind = kind;
        focusedOutputProc.running = true;
    }

    Process {
        id: focusedOutputProc
        command: ["sh", "-c", "niri msg --json focused-output | jq -r .name"]
        stdout: StdioCollector {
            onStreamFinished: {
                const name = text.trim() || (Quickshell.screens[0]?.name ?? "");
                root.togglePanel(root._pendingKind + ":" + name);
            }
        }
    }

    IpcHandler {
        target: "dashboard"
        function toggle(): void {
            root.togglePanelFocused("start");
        }
    }
    IpcHandler {
        target: "volume"
        function toggle(): void {
            root.togglePanelFocused("volume");
        }
    }
    IpcHandler {
        target: "battery"
        function toggle(): void {
            root.togglePanelFocused("battery");
        }
    }

    property string _dismissedName: ""
    property real _dismissedAt: 0
    function noteFocusDismiss(name) {
        root._dismissedName = name;
        root._dismissedAt = Date.now();
    }
    function togglePanel(name) {
        if (root.panel !== name && root._dismissedName === name && Date.now() - root._dismissedAt < 500) {
            root._dismissedName = "";
            return;
        }
        root.panel = root.panel === name ? "" : name;
    }

    property string wallpaper: ""

    function lock() {
        wallpaperProc.running = true;
    }
    function unlock() {
        root.locked = false;
    }

    Process {
        id: wallpaperProc
        command: ["sh", "-c", "awww query 2>/dev/null | sed -n 's/.*image: //p' | head -n 1"]
        stdout: StdioCollector {
            onStreamFinished: root.wallpaper = text.trim()
        }

        onExited: root.locked = true
    }

    function suspend() {
        suspendProc.running = true;
    }

    function hibernate() {
        hibernateProc.running = true;
    }

    function reboot() {
        rebootProc.running = true;
    }

    function poweroff() {
        poweroffProc.running = true;
    }

    function logout() {
        logoutProc.running = true;
    }

    Process {
        id: suspendProc
        command: ["systemctl", "suspend"]
    }
    Process {
        id: hibernateProc
        command: ["systemctl", "hibernate"]
    }
    Process {
        id: rebootProc
        command: ["systemctl", "reboot"]
    }
    Process {
        id: poweroffProc
        command: ["systemctl", "poweroff"]
    }
    Process {
        id: logoutProc
        command: ["niri", "msg", "action", "quit", "--skip-confirmation"]
    }

    IpcHandler {
        target: "session"

        function lock(): void {
            root.lock();
        }
        function togglePowerMenu(): void {
            root.panelHint = "lock";
            root.togglePanelFocused("start");
        }
        function unlock(): void {
            root.unlock();
        }
        function suspend(): void {
            root.suspend();
        }
        function hibernate(): void {
            root.hibernate();
        }
        function reboot(): void {
            root.reboot();
        }
        function poweroff(): void {
            root.poweroff();
        }
        function logout(): void {
            root.logout();
        }
    }
}
