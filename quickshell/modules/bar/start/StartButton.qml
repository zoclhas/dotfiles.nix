import QtQuick
import Quickshell

import qs.widgets
import qs.services

Button {
    id: root

    readonly property string panelName: "start:" + (QsWindow.window?.screen?.name ?? "")

    icon: "start"
    iconScale: 1.5
    gloss: true
    toggled: Session.panel === root.panelName
    onClicked: Session.togglePanel(root.panelName)

    StartMenu {
        name: root.panelName
        screen: QsWindow.window?.screen ?? null
    }
}
