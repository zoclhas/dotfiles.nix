import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.services

PanelWindow {
    id: root

    property string layerNamespace: "zochell-panel"
    property int panelWidth: 360
    property int panelHeight: 240
    property int pillWidth: 120
    property int pillHeight: Style.barHeight
    property string edge: "bottom"
    property string align: "center"
    property int alignOffset: 0
    property bool panelOpen: false
    property bool closeOnEscape: true
    property bool closeOnOutsideClick: true
    property color panelColor: {
        const c = Qt.color(Colors.surface);
        return Qt.rgba(c.r, c.g, c.b, Style.backgroundOpacity);
    }

    readonly property int closeFadeDuration: Style.quickDuration

    default property alias panelContent: contentSlot.data

    signal panelOpened
    signal panelClosed

    function open() {
        panelOpen = true;
    }
    function close() {
        panelOpen = false;
    }
    function toggle() {
        panelOpen = !panelOpen;
    }

    property bool reallyVisible: false
    visible: reallyVisible

    onPanelOpenChanged: {
        if (panelOpen) {
            reallyVisible = true;
            panelOpened();
        } else {
            hideTimer.restart();
            panelClosed();
        }
    }

    Timer {
        id: hideTimer
        interval: Style.morphDuration
        onTriggered: root.reallyVisible = false
    }

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.namespace: root.layerNamespace
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: root.panelOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    Region {
        id: emptyRegion
        item: null
    }
    mask: root.panelOpen ? null : emptyRegion

    BackgroundEffect.blurRegion: Region {
        item: box
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.panelOpen && root.closeOnOutsideClick
        onClicked: root.close()
    }

    StyledRect {
        id: box

        anchors {
            bottom: root.edge === "bottom" ? parent.bottom : undefined
            top: root.edge === "top" ? parent.top : undefined
            bottomMargin: root.edge === "bottom" ? Style.screenMargin : 0
            topMargin: root.edge === "top" ? Style.screenMargin : 0
        }

        x: {
            if (root.align === "left")
                return Style.screenMargin + root.alignOffset;
            if (root.align === "right")
                return root.width - width - Style.screenMargin - root.alignOffset;
            return (root.width - width) / 2 + root.alignOffset;
        }

        width: root.panelOpen ? root.panelWidth : root.pillWidth
        height: root.panelOpen ? root.panelHeight : root.pillHeight
        radius: Style.radius
        color: root.panelColor
        opacity: root.panelOpen ? 1 : 0
        shadowEnabled: true
        shadowBlur: 64
        shadowSpread: 6
        shadowOffsetY: 16
        shadowColor: Qt.rgba(0, 0, 0, 0.55)

        Behavior on width {
            NumberAnimation {
                duration: Style.morphDuration
                easing.type: Style.morphEasing
            }
        }
        Behavior on height {
            NumberAnimation {
                duration: Style.morphDuration
                easing.type: Style.morphEasing
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: root.panelOpen ? Style.panelFadeDuration : root.closeFadeDuration
                easing.type: Easing.OutCubic
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {}
        }

        FocusScope {
            id: focusScope
            anchors.fill: parent
            focus: root.panelOpen

            Keys.onEscapePressed: event => {
                if (root.closeOnEscape) {
                    root.close();
                    event.accepted = true;
                }
            }

            Item {
                id: contentSlot
                anchors.fill: parent
                opacity: root.panelOpen ? 1 : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: root.panelOpen ? Style.panelFadeDuration : root.closeFadeDuration
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
    }
}
