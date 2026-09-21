import QtQuick
import Quickshell

import qs.widgets
import qs.services

PopupPanel {
    id: root

    leftAlign: true
    escapeCloses: root.confirm === ""

    property string confirm: ""
    readonly property var confirmInfo: ({
            "logout": { title: "Log Off", text: "Log off and close all programs?", run: () => Session.logout() },
            "suspend": { title: "Suspend", text: "Suspend this computer?", run: () => Session.suspend() },
            "reboot": { title: "Restart", text: "Restart the computer?", run: () => Session.reboot() },
            "poweroff": { title: "Shut Down", text: "Are you sure you want to shut down?", run: () => Session.poweroff() }
        })

    property int col: 0
    property int cursor: 0
    property int ncursor: 0
    property int sub: 0
    property int cbtn: 0
    property int mbtn: 1
    property int nbtn: -1

    readonly property var entries: {
        const e = [
            { icon: "wifi", text: "Wi-Fi", detail: Network.wifiEnabled ? (Network.wifiSsid || "on") : "off", toggled: Network.wifiEnabled, run: () => Network.toggleWifi() }
        ];
        if (BluetoothService.available)
            e.push({ icon: "bluetooth", text: "Bluetooth", detail: BluetoothService.enabled ? "on" : "off", toggled: BluetoothService.enabled, run: () => BluetoothService.toggle() });
        e.push({ icon: "bell", text: "Do Not Disturb", detail: Notifications.dndEnabled ? "on" : "off", toggled: Notifications.dndEnabled, run: () => Notifications.toggleDnd() });
        e.push({
            icon: PowerProfileService.current === "PowerSaver" ? "leaf" : (PowerProfileService.current === "Performance" ? "bolt" : "gauge"),
            text: "Power Profile",
            detail: PowerProfileService.current,
            gap: true,
            run: () => PowerProfileService.cycle()
        });
        e.push({ icon: "lock", text: "Lock", run: () => { root.dismiss(); Session.lock(); } });
        e.push({ icon: "sleep", text: "Suspend…", run: () => root.confirm = "suspend" });
        e.push({ icon: "logout", text: "Log Off…", run: () => root.confirm = "logout" });
        e.push({ icon: "restart", text: "Restart…", run: () => root.confirm = "reboot" });
        e.push({ icon: "power", text: "Shut Down…", run: () => root.confirm = "poweroff" });
        return e;
    }

    function accept() {
        const run = root.confirmInfo[root.confirm]?.run;
        root.confirm = "";
        root.dismiss();
        if (run)
            run();
    }

    onOpenChanged: {
        root.confirm = "";
        if (open) {
            const hint = Session.panelHint;
            Session.panelHint = "";
            root.col = 0;
            root.cursor = hint === "lock" ? Math.max(0, root.entries.findIndex(e => e.text === "Lock")) : 0;
            root.ncursor = 0;
            root.sub = 0;
            root.cbtn = 0;
            root.mbtn = 1;
            root.nbtn = -1;
            calendar.view = new Date();
        }
    }

    function move(dx, dy) {
        const nCount = Notifications.list.count;
        const eCount = root.entries.length;
        const hasMedia = Media.hasActivePlayer;

        if (dy !== 0) {
            if (root.col === 0) {
                root.cursor = (root.cursor + dy + eCount) % eCount;
            } else if (root.col === 1) {
                root.sub = hasMedia ? Math.max(0, Math.min(1, root.sub + dy)) : 0;
            } else if (nCount > 0) {
                root.ncursor = (Math.min(root.ncursor, nCount - 1) + dy + nCount) % nCount;
                root.nbtn = -1;
            }
            return;
        }

        if (root.col === 0) {
            if (dx > 0)
                root.col = 1;
        } else if (root.col === 1) {
            if (root.sub === 1 && !hasMedia)
                root.sub = 0;
            const btn = root.sub === 0 ? root.cbtn : root.mbtn;
            const max = root.sub === 0 ? 1 : 2;
            const nb = btn + dx;
            if (nb < 0) {
                root.col = 0;
            } else if (nb > max) {
                root.col = 2;
            } else if (root.sub === 0) {
                root.cbtn = nb;
            } else {
                root.mbtn = nb;
            }
        } else {
            const count = nCount > 0 ? notifBox.buttonCount(Math.min(root.ncursor, nCount - 1)) : 0;
            const nb = root.nbtn + dx;
            if (nb < -1)
                root.col = 1;
            else if (nb < count)
                root.nbtn = nb;
        }
    }

    function activate() {
        const nCount = Notifications.list.count;
        if (root.col === 0) {
            root.entries[Math.min(root.cursor, root.entries.length - 1)].run();
        } else if (root.col === 1) {
            if (root.sub === 0)
                calendar.shift(root.cbtn === 0 ? -1 : 1);
            else if (root.mbtn === 0)
                Media.previous();
            else if (root.mbtn === 1)
                Media.togglePlaying();
            else
                Media.next();
        } else if (nCount > 0) {
            const i = Math.min(root.ncursor, nCount - 1);
            if (root.nbtn < 0)
                notifBox.toggleExpand(Notifications.list.get(i).notifId);
            else
                notifBox.activateButton(i, root.nbtn);
        }
    }

    onKeyPressed: event => {
        if (root.confirm !== "") {
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Y)
                root.accept();
            else if (event.key === Qt.Key_Escape || event.key === Qt.Key_N)
                root.confirm = "";
            else
                return;
            event.accepted = true;
            return;
        }

        const nCount = Notifications.list.count;
        switch (event.key) {
        case Qt.Key_Up:
        case Qt.Key_K:
        case Qt.Key_Backtab:
            root.move(0, -1);
            break;
        case Qt.Key_Down:
        case Qt.Key_J:
        case Qt.Key_Tab:
            root.move(0, 1);
            break;
        case Qt.Key_Left:
        case Qt.Key_H:
            root.move(-1, 0);
            break;
        case Qt.Key_Right:
        case Qt.Key_L:
            root.move(1, 0);
            break;
        case Qt.Key_Return:
        case Qt.Key_Enter:
        case Qt.Key_Space:
            root.activate();
            break;
        case Qt.Key_X:
        case Qt.Key_Delete:
            if (root.col === 2 && nCount > 0)
                Notifications.dismiss(Notifications.list.get(Math.min(root.ncursor, nCount - 1)).notifId);
            break;
        case Qt.Key_C:
            Notifications.dismissAll();
            break;
        case Qt.Key_E:
            if (root.col === 2 && nCount > 0)
                notifBox.toggleExpand(Notifications.list.get(Math.min(root.ncursor, nCount - 1)).notifId);
            break;
        case Qt.Key_O:
            if (root.col === 2 && nCount > 0)
                notifBox.copyCode(Notifications.list.get(Math.min(root.ncursor, nCount - 1)).notifId);
            break;
        case Qt.Key_P:
            Media.togglePlaying();
            break;
        case Qt.Key_Period:
            Media.next();
            break;
        case Qt.Key_Comma:
            Media.previous();
            break;
        case Qt.Key_PageUp:
            calendar.shift(-1);
            break;
        case Qt.Key_PageDown:
            calendar.shift(1);
            break;
        default:
            return;
        }
        event.accepted = true;
    }

    Connections {
        target: Notifications.list
        function onCountChanged() {
            const c = Notifications.list.count;
            root.ncursor = Math.max(0, Math.min(root.ncursor, c - 1));
        }
    }

    Bevel {
        id: menu
        style: "outset"
        depth: 2
        width: notifBox.x + notifBox.width + Theme.spacingSm + 2 * insetX
        height: Math.max(colA.implicitHeight, colB.implicitHeight) + 2 * Theme.spacingSm + 2 * insetY

        PixelRect {
            id: side
            x: Theme.spacingXs
            y: Theme.spacingXs
            width: 40
            height: parent.height - 2 * Theme.spacingXs
            color: Theme.accentAlt
            colorTopEnd: Theme.accent
            split: 1

            RText {
                x: 8
                y: side.height - 10
                rotation: -90
                transformOrigin: Item.TopLeft
                text: Quickshell.env("USER")
                color: Theme.contrastOn(Theme.mix(Theme.accent, Theme.accentAlt, 0.5))
                font.bold: true
                font.pixelSize: 22
            }
        }

        Column {
            id: colA
            x: side.x + side.width + Theme.spacingSm
            y: Theme.spacingSm
            width: 220
            spacing: 0

            Repeater {
                model: root.entries

                delegate: Column {
                    id: entry
                    required property var modelData
                    required property int index
                    width: colA.width

                    MenuItem {
                        width: parent.width
                        icon: entry.modelData.icon
                        text: entry.modelData.text
                        detail: entry.modelData.detail ?? ""
                        toggled: entry.modelData.toggled ?? false
                        highlighted: root.col === 0 && root.cursor === entry.index
                        onClicked: {
                            root.col = 0;
                            root.cursor = entry.index;
                            entry.modelData.run();
                        }
                    }
                    Item {
                        visible: entry.modelData.gap ?? false
                        width: parent.width
                        height: Theme.spacingMd * 2 + Theme.px

                        Separator {
                            x: Theme.spacingSm
                            y: Theme.spacingMd
                            width: parent.width - 2 * Theme.spacingSm
                        }
                    }
                }
            }
        }

        Column {
            id: colB
            x: colA.x + colA.width + Theme.spacingSm
            y: Theme.spacingSm
            width: 270
            spacing: Theme.spacingSm

            Calendar {
                id: calendar
                width: parent.width
                height: 244
                cursorButton: root.col === 1 && root.sub === 0 ? root.cbtn : -1
            }
            MediaBox {
                width: parent.width
                visible: Media.hasActivePlayer
                cursorButton: root.col === 1 && root.sub === 1 ? root.mbtn : -1
            }
            SystemBox {
                width: parent.width
            }
        }

        NotificationsBox {
            id: notifBox
            x: colB.x + colB.width + Theme.spacingSm
            y: Theme.spacingSm
            width: 340
            height: colB.implicitHeight
            focused: root.col === 2
            cursor: root.ncursor
            button: root.nbtn
        }
    }

    overlay: Rectangle {
        anchors.fill: parent
        visible: root.confirm !== ""
        color: Qt.rgba(0, 0, 0, 0.35)

        MouseArea {
            anchors.fill: parent
        }

        Dialog {
            anchors.centerIn: parent
            title: root.confirmInfo[root.confirm]?.title ?? ""
            icon: "alert"
            onCloseClicked: root.confirm = ""

            Column {
                spacing: Theme.spacingLg

                RText {
                    text: root.confirmInfo[root.confirm]?.text ?? ""
                }

                Row {
                    spacing: Theme.spacingMd
                    x: parent.width - width

                    Button {
                        text: "Yes"
                        gloss: true
                        minWidth: 80
                        onClicked: root.accept()
                    }
                    Button {
                        text: "No"
                        minWidth: 80
                        onClicked: root.confirm = ""
                    }
                }
            }
        }
    }
}
