pragma Singleton
import QtQuick

QtObject {
    id: root

    readonly property string family: "CozetteVector"
    readonly property int cellW: 7
    readonly property int cellH: 13

    function battery(percent, charging) {
        if (charging)
            return percent >= 95 ? "batteryChargeFull" : "batteryCharge" + Math.max(0, Math.min(5, Math.floor(percent / 16)));
        if (percent >= 95)
            return "battery";
        if (percent <= 5)
            return "batteryAlert";
        return "battery" + Math.max(1, Math.min(9, Math.round(percent / 10)));
    }

    readonly property var icons: ({
            "start": "㋽",
            "volume": "",
            "volumeLow": "",
            "volumeMuted": "",
            "mic": "",
            "wifi": "",
            "ethernet": "\u{f0200}",
            "bluetooth": "",
            "battery": "\uf578",
            "battery1": "\uf579",
            "battery2": "\uf57a",
            "battery3": "\uf57b",
            "battery4": "\uf57c",
            "battery5": "\uf57d",
            "battery6": "\uf57e",
            "battery7": "\uf57f",
            "battery8": "\uf580",
            "battery9": "\uf581",
            "batteryAlert": "\uf582",
            "batteryChargeFull": "\uf584",
            "batteryCharge0": "\uf585",
            "batteryCharge1": "\uf586",
            "batteryCharge2": "\uf587",
            "batteryCharge3": "\uf588",
            "batteryCharge4": "\uf589",
            "batteryCharge5": "\uf58a",
            "bolt": "",
            "alert": "",
            "bell": "",
            "lock": "",
            "sleep": "\u23fe",
            "logout": "↪",
            "restart": "↻",
            "power": "⏻",
            "play": "",
            "pause": "",
            "prev": "",
            "next": "",
            "left": "",
            "right": "",
            "up": "▲",
            "down": "▼",
            "close": "",
            "check": "",
            "info": "",
            "sun": "",
            "keyboard": "",
            "leaf": "\u{1f342}\ufe0e",
            "gauge": "\u25d1",
            "cpu": "",
            "ram": "",
            "disk": "",
            "user": "",
            "arrowUp": "↑",
            "arrowDown": "↓",
            "calendar": "",
            "gear": "",
            "reply": "↩",
            "archive": "",
            "trash": "",
            "app": "",
            "card": "\u{1f4c7}\ufe0e",
            "ws-browser": "\u{1f310}\ufe0e",
            "ws-work": "",
            "ws-games": "\u{1f3ae}\ufe0e",
            "ws-media": "\u{1f3b6}\ufe0e"
        })

    readonly property var off: ({
            "mic": "",
            "bell": ""
        })
}
