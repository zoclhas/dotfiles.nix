pragma Singleton
import QtQuick

import qs.services

QtObject {
    id: style

    readonly property string fontFamily: "Lilex Nerd Font Mono"

    readonly property int fontSize: 12
    function fs(offset) {
        return Math.max(style.fontSize + offset, 8);
    }

    readonly property int iconSize: 18
    function fsIcon(offset) {
        return Math.max(style.iconSize + (offset ?? 0), 10);
    }

    readonly property int spacingXs: 4
    readonly property int spacingSm: 8
    readonly property int spacingMd: 12
    readonly property int spacingLg: 16
    readonly property int spacingXl: 24

    readonly property int screenMargin: 12
    readonly property int shadowMargin: 32
    readonly property int bezelRadius: radius + screenMargin
    readonly property int pillGap: 8
    readonly property int barHeight: 32
    readonly property int pillPadding: 10

    property real radius: 8
    function innerRadius(padding) {
        return Math.max(0, style.radius - padding);
    }

    property real borderWidth: 1
    property color borderColor: Colors.outline

    readonly property bool powerSaving: PowerProfileService.current === "PowerSaver"

    readonly property bool shadowEnabled: !powerSaving
    property real shadowBlur: 28
    property real shadowSpread: 1
    property real shadowOffsetX: 0
    property real shadowOffsetY: 6
    property color shadowColor: Qt.rgba(0, 0, 0, 0x60 / 255)
    property real backgroundOpacity: 0.85

    readonly property int quickDuration: powerSaving ? 0 : 120
    readonly property int fadeDuration: powerSaving ? 0 : 220
    readonly property int morphDuration: powerSaving ? 0 : 320
    readonly property int panelFadeDuration: powerSaving ? 0 : 420
    readonly property int morphEasing: Easing.OutCubic
    readonly property int springEasing: Easing.OutBack

    readonly property int osdHideDelay: 1400
    readonly property int tooltipDelay: 400

    readonly property real volumeMax: 150
}
