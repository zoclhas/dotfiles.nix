import QtQuick
import Quickshell.Services.SystemTray

import qs.widgets
import qs.services

PopupPanel {
    id: root

    required property SystemTrayItem trayItem

    Bevel {
        id: frame
        style: "outset"
        depth: 2
        width: Math.max(200, level.implicitWidth + 2 * (insetX + Theme.spacingXs))
        height: level.implicitHeight + 2 * (insetY + Theme.spacingXs)

        TrayMenuLevel {
            id: level
            x: frame.insetX + Theme.spacingXs
            y: frame.insetY + Theme.spacingXs
            width: frame.width - 2 * (frame.insetX + Theme.spacingXs)
            menu: root.trayItem.menu
            onFinished: root.dismiss()
        }
    }
}
