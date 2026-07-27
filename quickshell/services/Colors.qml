pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    property alias background: adapter.background
    property alias onBackground: adapter.on_background
    property alias surface: adapter.surface
    property alias surfaceVariant: adapter.surface_variant
    property alias primary: adapter.primary
    property alias onPrimary: adapter.on_primary
    property alias secondary: adapter.secondary
    property alias tertiary: adapter.tertiary
    property alias error: adapter.error
    property alias outline: adapter.outline
    property alias shadow: adapter.shadow
    property alias cornerBg: adapter.corner_bg
    property alias primaryFixedDim: adapter.primary_fixed_dim
    property alias secondaryFixedDim: adapter.secondary_fixed_dim
    property alias tertiaryFixedDim: adapter.tertiary_fixed_dim
    property alias errorContainer: adapter.error_container

    FileView {
        id: file
        path: Quickshell.env("HOME") + "/.local/state/quickshell/generated/colors.json"
        watchChanges: true
        onFileChanged: reload()

        JsonAdapter {
            id: adapter

            readonly property string source_color: "#888888"
            property string background: "#1a1a1a"
            property string on_background: "#e0e0e0"
            property string surface: "#1a1a1a"
            property string surface_variant: "#2a2a2a"
            property string primary: "#8ab4f8"
            property string on_primary: "#00325b"
            property string secondary: "#bfc6dc"
            property string tertiary: "#dcbfe0"
            property string error: "#ffb4ab"
            property string outline: "#8f9099"
            property string shadow: "#000000"
            property string corner_bg: "#ffffff"
            property string primary_fixed_dim: "#8ab4f8"
            property string secondary_fixed_dim: "#bfc6dc"
            property string tertiary_fixed_dim: "#dcbfe0"
            property string error_container: "#93000a"
        }
    }
}
