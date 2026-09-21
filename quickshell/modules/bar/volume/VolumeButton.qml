import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.widgets
import qs.services

// Volume and display brightness as one control: two flat buttons split by a
// small divider. Both open the same panel; each scrolls its own value.
RowLayout {
    id: root

    readonly property string panelName: "volume:" + (QsWindow.window?.screen?.name ?? "")
    readonly property bool open: Session.panel === root.panelName

    spacing: 0

    Button {
        flat: true
        toggled: root.open
        icon: Audio.muted ? "volumeMuted" : (Audio.volume > 0.5 ? "volume" : "volumeLow")
        // fixed 3-digit field so the bar doesn't shift: " 90%"
        text: String(Audio.volumePercent).padStart(3, " ") + "%"
        onClicked: Session.togglePanel(root.panelName)
        onWheel: delta => delta > 0 ? Audio.increment(0.05) : Audio.decrement(0.05)
        onMiddleClicked: Audio.toggleMute()
    }

    Bevel {
        visible: Brightness.ready
        Layout.alignment: Qt.AlignVCenter
        Layout.preferredWidth: Theme.px * 2
        Layout.preferredHeight: Theme.buttonHeight - 2 * Theme.spacingSm
        style: "ridge"
        depth: 1
    }

    Button {
        visible: Brightness.ready
        flat: true
        toggled: root.open
        icon: "sun"
        text: String(Brightness.percentage).padStart(3, " ") + "%"
        onClicked: Session.togglePanel(root.panelName)
        onWheel: delta => delta > 0 ? Brightness.increment(5) : Brightness.decrement(5)
    }

    VolumePanel {
        name: root.panelName
        anchorItem: root
        screen: QsWindow.window?.screen ?? null
    }
}
