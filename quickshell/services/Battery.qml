pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: root

    readonly property UPowerDevice device: UPower.displayDevice
    readonly property bool available: device?.isLaptopBattery ?? false
    readonly property real percentage: (device?.percentage ?? 0) * 100
    readonly property int percent: Math.round(root.percentage)
    readonly property int state: device?.state ?? UPowerDeviceState.Unknown
    readonly property bool charging: root.state === UPowerDeviceState.Charging
    readonly property bool pendingCharge: root.state === UPowerDeviceState.PendingCharge
    readonly property bool fullyCharged: root.state === UPowerDeviceState.FullyCharged
    readonly property bool onBattery: UPower.onBattery
    readonly property real timeToEmpty: device?.timeToEmpty ?? 0
    readonly property real timeToFull: device?.timeToFull ?? 0
    readonly property real healthPercentage: (device?.healthPercentage ?? 0) * 100

    readonly property string level: {
        if (root.percent <= 10)
            return "critical";
        if (root.percent <= 25)
            return "low";
        if (root.percent <= 60)
            return "medium";
        return "high";
    }

    function formatTime(seconds) {
        if (!seconds || seconds <= 0)
            return "";
        const h = Math.floor(seconds / 3600);
        const m = Math.round((seconds % 3600) / 60);
        if (h > 0)
            return h + "h " + m + "m";
        return m + "m";
    }
}
