import QtQuick
import Quickshell

import qs.widgets
import qs.services

Button {
    id: root

    readonly property string panelName: "clock:" + (QsWindow.window?.screen?.name ?? "")

    flat: true
    toggled: Session.panel === root.panelName
    text: Qt.formatDateTime(clock.date, "ddd d MMM  HH:mm:ss")
    onClicked: Session.togglePanel(root.panelName)

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    ClockPanel {
        name: root.panelName
        anchorItem: root
        centerAlign: true
        screen: QsWindow.window?.screen ?? null
    }
}
