pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool locked: false
    property bool dashboardOpen: false
    property bool sysMonitorOpen: false
    property bool powerMenuOpen: false
    property bool batteryPanelOpen: false

    readonly property string lockBgPath: Quickshell.env("HOME") + "/.cache/quickshell/lockscreen-bg.png"

    function lock() {
        lockCaptureProc.running = true;
    }
    function unlock() {
        root.locked = false;
    }

    Process {
        id: lockCaptureProc
        command: ["sh", "-c", `mkdir -p "$(dirname '${root.lockBgPath}')" && grim '${root.lockBgPath}.tmp.png' && magick '${root.lockBgPath}.tmp.png' -resize 15% -blur 0x1 -resize 800% '${root.lockBgPath}' && rm -f '${root.lockBgPath}.tmp.png'`]
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
        function togglePowerMenu(): void {
            root.powerMenuOpen = !root.powerMenuOpen;
        }
    }
}
