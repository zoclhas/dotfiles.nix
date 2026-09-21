import QtQuick
import Quickshell.Services.SystemTray

import qs.widgets
import qs.services

Well {
    id: root

    readonly property var shown: SystemTray.items.values.filter(i => i.status !== Status.Passive)

    visible: root.shown.length > 0

    padding: Theme.spacingXs
    spacing: Theme.spacingXs

    Repeater {
        model: root.shown
        delegate: TrayItem {}
    }
}
