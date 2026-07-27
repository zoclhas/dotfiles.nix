//@ pragma UseQApplication
//@ pragma ShellId zochell
//@ pragma DataDir $BASE/zochell
//@ pragma StateDir $BASE/zochell
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.services
import qs.modules.bar
import qs.modules.osd
import qs.modules.corners
import qs.modules.notifications
import qs.modules.powermenu
import qs.modules.lockscreen

ShellRoot {
    id: root

    Component.onCompleted: {
        let _ = Niri.connected;
        let _osd = OsdState.active;
        let _idle = Idle.enabled;
    }

    Variants {
        model: Quickshell.screens

        Bar {
            required property ShellScreen modelData
            targetScreen: modelData
        }
    }

    Variants {
        model: Quickshell.screens

        Osd {
            required property ShellScreen modelData
            targetScreen: modelData
        }
    }

    Variants {
        model: Quickshell.screens

        ScreenCorners {
            required property ShellScreen modelData
            targetScreen: modelData
        }
    }

    Variants {
        model: Quickshell.screens

        NotificationStack {
            required property ShellScreen modelData
            targetScreen: modelData
        }
    }

    Variants {
        model: Quickshell.screens

        PowerMenu {
            required property ShellScreen modelData
            targetScreen: modelData
        }
    }

    WlSessionLock {
        id: sessionLock
        locked: Session.locked

        surface: Component {
            WlSessionLockSurface {
                LockScreenContent {
                    anchors.fill: parent
                    lockSecure: sessionLock.secure
                }
            }
        }
    }
}
