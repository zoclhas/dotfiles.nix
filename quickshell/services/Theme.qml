pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property color bg: adapter.background
    readonly property color bgText: adapter.on_background
    readonly property color surfaceVariant: adapter.surface_variant
    readonly property color primary: adapter.primary
    readonly property color tertiary: adapter.tertiary
    readonly property color error: adapter.error

    function mix(a, b, t) {
        return Qt.rgba(a.r + (b.r - a.r) * t, a.g + (b.g - a.g) * t, a.b + (b.b - a.b) * t, 1);
    }
    function lin(c) {
        return c <= 0.03928 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4);
    }
    function luminance(c) {
        return 0.2126 * lin(c.r) + 0.7152 * lin(c.g) + 0.0722 * lin(c.b);
    }
    function contrast(a, b) {
        const la = luminance(a), lb = luminance(b);
        return (Math.max(la, lb) + 0.05) / (Math.min(la, lb) + 0.05);
    }
    function desaturate(c, t) {
        const g = 0.299 * c.r + 0.587 * c.g + 0.114 * c.b;
        return mix(c, Qt.rgba(g, g, g, 1), t);
    }
    function contrastOn(bgColor) {
        const light = Qt.rgba(1, 1, 1, 1), dark = Qt.rgba(0, 0, 0, 1);
        const pref = root.bgText;
        if (root.contrast(pref, bgColor) >= 4.5)
            return pref;
        return root.contrast(light, bgColor) >= root.contrast(dark, bgColor) ? light : dark;
    }
    function lift(c, f) {
        return luminance(c) < 0.06 ? mix(c, Qt.rgba(1, 1, 1, 1), 0.12 * f) : Qt.lighter(c, 1 + 0.4 * f);
    }
    function sink(c, f) {
        return Qt.darker(c, 1 + 0.35 * f);
    }

    readonly property color face: desaturate(surfaceVariant, 0.3)
    readonly property color faceLight: lift(face, 1)
    readonly property color faceHighlight: lift(face, 2.4)
    readonly property color faceShadow: sink(face, 1.3)
    readonly property color faceDark: sink(face, 3)

    readonly property color text: contrastOn(face)
    readonly property color textDisabled: faceShadow

    readonly property color accent: primary
    readonly property color accentAlt: tertiary
    readonly property color accentText: contrastOn(accent)
    readonly property color selection: accent
    readonly property color selectionText: accentText

    readonly property color desktop: bg
    readonly property color desktopText: contrastOn(bg)
    readonly property color well: mix(bg, face, 0.25)
    readonly property color wellText: contrastOn(well)

    readonly property color danger: error
    readonly property color tooltipFace: mix(face, Qt.rgba(1, 0.96, 0.7, 1), 0.7)
    readonly property color tooltipText: Qt.rgba(0, 0, 0, 1)

    FileView {
        path: Quickshell.env("HOME") + "/.local/state/quickshell/generated/colors.json"
        watchChanges: true
        onFileChanged: reload()

        JsonAdapter {
            id: adapter

            property string background: "#1a1a1a"
            property string on_background: "#e0e0e0"
            property string surface_variant: "#2a2a2a"
            property string primary: "#8ab4f8"
            property string tertiary: "#dcbfe0"
            property string error: "#ffb4ab"
        }
    }

    readonly property int px: 2
    readonly property real volumeMax: 150
    readonly property int osdHideDelay: 1400
    function snap(v) {
        return Math.round(v / root.px) * root.px;
    }

    readonly property string fontFamily: "CozetteCrossedSevenVector"
    readonly property int fontSize: 16
    function fs(offset) {
        return Math.max(root.fontSize + (offset ?? 0), 8);
    }
    readonly property int iconSize: 18

    readonly property int spacingXs: 2
    readonly property int spacingSm: 4
    readonly property int spacingMd: 8
    readonly property int spacingLg: 12
    readonly property int spacingXl: 16

    readonly property int barHeight: 34
    readonly property int titleBarHeight: 22
    readonly property int buttonHeight: 26

    readonly property bool powerSaving: PowerProfileService.current === "PowerSaver"
}
