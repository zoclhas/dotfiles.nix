import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.services
import qs.modules.components

PanelWindow {
    id: root

    required property ShellScreen targetScreen
    screen: root.targetScreen

    readonly property int openWidth: 230
    readonly property int openHeight: 56
    readonly property int bottomOffset: 128

    anchors {
        bottom: true
    }
    implicitWidth: root.openWidth
    implicitHeight: root.openHeight + root.bottomOffset + Style.shadowMargin

    exclusionMode: ExclusionMode.Ignore
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "zochell-osd"

    BackgroundEffect.blurRegion: Region {
        item: pill
    }

    StyledRect {
        id: pill
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: OsdState.active ? root.bottomOffset : Style.screenMargin

        width: OsdState.active ? root.openWidth : 0
        height: root.openHeight
        radius: Style.radius
        color: {
            const c = Qt.color(Colors.surface);
            return Qt.rgba(c.r, c.g, c.b, Style.backgroundOpacity);
        }
        shadowEnabled: false
        shadowBlur: 64
        shadowSpread: 6
        shadowOffsetY: 16
        shadowColor: Qt.rgba(0, 0, 0, 0.55)
        clip: true
        opacity: OsdState.active ? 1 : 0

        Behavior on width {
            NumberAnimation {
                duration: Style.morphDuration
                easing.type: Style.morphEasing
            }
        }
        Behavior on anchors.bottomMargin {
            NumberAnimation {
                duration: Style.morphDuration
                easing.type: Style.morphEasing
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: OsdState.active ? Style.panelFadeDuration : Style.quickDuration
                easing.type: Easing.OutCubic
            }
        }

        Row {
            anchors.centerIn: parent
            spacing: Style.spacingMd
            opacity: pill.width > root.openWidth * 0.6 ? 1 : 0

            Behavior on opacity {
                NumberAnimation {
                    duration: Style.morphDuration * 0.6
                    easing.type: Style.morphEasing
                }
            }

            Text {
                width: 24
                horizontalAlignment: Text.AlignHCenter
                anchors.verticalCenter: parent.verticalCenter
                font.family: Style.fontFamily
                font.pixelSize: Style.fsIcon(1)
                color: OsdState.muted ? Colors.outline : Colors.primary
                text: {
                    if (OsdState.kind === "mic")
                        return OsdState.muted ? Icons.microphoneOff : Icons.microphone;
                    if (OsdState.kind === "brightness")
                        return Icons.brightness;
                    if (OsdState.kind === "kbdBacklight")
                        return Icons.keyboard;
                    if (OsdState.muted)
                        return Icons.volumeOff;
                    return OsdState.value > 66 ? Icons.volumeHigh : Icons.volumeLow;
                }
            }

            Rectangle {
                id: track
                width: 120
                height: 6
                anchors.verticalCenter: parent.verticalCenter
                radius: Style.innerRadius(2)
                color: Colors.surfaceVariant
                clip: true

                Rectangle {
                    height: parent.height
                    radius: parent.radius
                    color: OsdState.muted ? Colors.outline : (OsdState.kind === "volume" && OsdState.value > 100 ? Colors.error : Colors.primary)
                    width: parent.width * (OsdState.kind === "mic" ? (OsdState.muted ? 0 : 1) : Math.min(OsdState.value, OsdState.maxForKind) / OsdState.maxForKind)

                    Behavior on width {
                        NumberAnimation {
                            duration: 150
                            easing.type: Easing.OutCubic
                        }
                    }
                }

                Rectangle {
                    visible: OsdState.kind === "volume"
                    width: 2
                    height: parent.height
                    color: Qt.rgba(1, 1, 1, 0.35)
                    x: parent.width * (100 / Style.volumeMax) - width / 2
                }
            }

            Text {
                width: 38
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                font.family: Style.fontFamily
                font.pixelSize: Style.fs(-1)
                color: Colors.onBackground
                text: OsdState.kind === "mic" ? (OsdState.muted ? "off" : "on") : Math.round(OsdState.value) + "%"
            }
        }
    }
}
