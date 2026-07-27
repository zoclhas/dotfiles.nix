pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.services

Singleton {
    id: root

    readonly property int dimTimeout: 300
    readonly property int lockTimeout: 900
    readonly property int suspendTimeout: 1400

    property bool enabled: true
    property int dimmedFromPercentage: -1

    readonly property bool activeMedia: Media.isPlaying

    IdleMonitor {
        id: dimMonitor
        enabled: root.enabled && !root.activeMedia
        timeout: root.dimTimeout
        onIsIdleChanged: {
            if (isIdle) {
                if (root.dimmedFromPercentage === -1)
                    root.dimmedFromPercentage = Brightness.percentage;
                Brightness.setPercentage(Math.min(Brightness.percentage, 15));
            } else if (root.dimmedFromPercentage !== -1) {
                Brightness.setPercentage(root.dimmedFromPercentage);
                root.dimmedFromPercentage = -1;
            }
        }
    }

    IdleMonitor {
        id: lockMonitor
        enabled: root.enabled && !root.activeMedia
        timeout: root.lockTimeout
        onIsIdleChanged: {
            if (isIdle)
                Session.lock();
        }
    }

    IdleMonitor {
        id: suspendMonitor
        enabled: root.enabled && !root.activeMedia
        timeout: root.suspendTimeout
        onIsIdleChanged: {
            if (isIdle && Session.locked)
                Session.suspend();
        }
    }
}
