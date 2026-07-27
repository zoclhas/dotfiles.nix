import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.services
import qs.modules.components

PanelWindow {
    id: root

    required property ShellScreen targetScreen
    screen: root.targetScreen

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "zochell-powermenu"
    WlrLayershell.keyboardFocus: Session.powerMenuOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    Region {
        id: emptyRegion
        item: null
    }
    mask: Session.powerMenuOpen ? null : emptyRegion

    property bool reallyVisible: false
    visible: reallyVisible

    Connections {
        target: Session
        function onPowerMenuOpenChanged() {
            if (Session.powerMenuOpen) {
                root.reallyVisible = true;
            } else {
                hideTimer.restart();
            }
        }
    }

    Timer {
        id: hideTimer
        interval: Style.panelFadeDuration
        onTriggered: root.reallyVisible = false
    }

    // BackgroundEffect.blurRegion: Region { item: dim }

    Rectangle {
        id: dim
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.5)
        opacity: Session.powerMenuOpen ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: Style.panelFadeDuration
                easing.type: Easing.OutCubic
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: Session.powerMenuOpen = false
        }
    }

    StyledRect {
        id: box
        anchors.centerIn: parent
        width: grid.implicitWidth + Style.spacingXl * 2
        height: grid.implicitHeight + Style.spacingXl * 2
        radius: Style.radius
        color: Colors.surface
        shadowEnabled: true
        shadowBlur: 64
        shadowSpread: 6
        shadowOffsetY: 16

        scale: Session.powerMenuOpen ? 1 : 0.85
        opacity: Session.powerMenuOpen ? 1 : 0

        Behavior on scale {
            NumberAnimation {
                duration: Style.panelFadeDuration
                easing.type: Easing.OutBack
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: Style.quickDuration
                easing.type: Easing.OutCubic
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {}
        }

        FocusScope {
            anchors.fill: parent
            focus: Session.powerMenuOpen

            Keys.onEscapePressed: event => {
                Session.powerMenuOpen = false;
                event.accepted = true;
            }

            ActionGrid {
                id: grid
                focus: true
                anchors.centerIn: parent
                buttonSize: 64
                iconSize: 24
                itemSpacing: Style.spacingMd
                actions: [
                    {
                        icon: Icons.lock,
                        name: "lock"
                    },
                    {
                        icon: Icons.logout,
                        name: "logout"
                    },
                    {
                        icon: Icons.sleep,
                        name: "suspend"
                    },
                    {
                        icon: Icons.hibernate,
                        name: "hibernate"
                    },
                    {
                        icon: Icons.powerOff,
                        name: "poweroff"
                    },
                    {
                        icon: Icons.restart,
                        name: "reboot"
                    }
                ]
                onActionTriggered: action => {
                    Session.powerMenuOpen = false;
                    if (action.name === "lock")
                        Session.lock();
                    else if (action.name === "logout")
                        Session.logout();
                    else if (action.name === "suspend")
                        Session.suspend();
                    else if (action.name === "hibernate")
                        Session.hibernate();
                    else if (action.name === "poweroff")
                        Session.poweroff();
                    else if (action.name === "reboot")
                        Session.reboot();
                }
            }
        }
    }
}
