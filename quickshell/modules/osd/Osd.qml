import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.widgets
import qs.services

PanelWindow {
    id: root

    required property ShellScreen targetScreen
    screen: root.targetScreen

    readonly property var kinds: ({
            "volume": {
                title: "Volume",
                icon: "volume"
            },
            "mic": {
                title: "Microphone",
                icon: "mic"
            },
            "brightness": {
                title: "Brightness",
                icon: "sun"
            },
            "kbdBacklight": {
                title: "Keyboard Light",
                icon: "keyboard"
            }
        })
    readonly property var info: root.kinds[OsdState.kind] ?? root.kinds.volume
    readonly property bool muted: OsdState.muted
    readonly property bool isMic: OsdState.kind === "mic"
    readonly property real fraction: root.isMic ? (root.muted ? 0 : 1) : Math.min(OsdState.value, OsdState.maxForKind) / OsdState.maxForKind
    readonly property bool loud: OsdState.kind === "volume" && OsdState.value > 100

    visible: OsdState.active || pop.animating

    anchors.bottom: true
    margins.bottom: Theme.barHeight + 96
    implicitWidth: dialog.implicitWidth
    implicitHeight: dialog.implicitHeight
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "zochell-osd"

    PopIn {
        id: pop
        anchors.fill: parent
        open: OsdState.active
        originX: 0.5
        originY: 1

    Dialog {
        id: dialog
        anchors.fill: parent
        minWidth: 300
        title: root.info.title
        icon: root.info.icon
        showClose: false

        Row {
            spacing: Theme.spacingMd

            PixelIcon {
                anchors.verticalCenter: parent.verticalCenter
                name: root.isMic ? "mic" : (root.muted && OsdState.kind === "volume" ? "volumeMuted" : root.info.icon)
                strike: root.isMic && root.muted
                scale: 3
                color: root.muted ? Theme.danger : Theme.text
            }
            SegmentBar {
                anchors.verticalCenter: parent.verticalCenter
                width: 170
                height: 22
                value: root.fraction
                fillColor: root.muted ? Theme.faceShadow : (root.loud ? Theme.danger : Theme.accent)
            }
            RText {
                anchors.verticalCenter: parent.verticalCenter
                width: 44
                horizontalAlignment: Text.AlignRight
                text: root.isMic ? (root.muted ? "off" : "on") : Math.round(OsdState.value) + "%"
            }
        }
    }
    }
}
