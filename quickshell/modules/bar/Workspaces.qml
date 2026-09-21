import QtQuick

import qs.widgets
import qs.services

Row {
    id: root

    required property string screenName

    padding: Theme.px
    spacing: Theme.px

    Repeater {
        model: Niri.workspaces

        delegate: Button {
            id: ws

            required property int index
            required property string output
            required property bool isFocused
            required property bool isUrgent
            required property var id
            required property string name

            visible: ws.output === root.screenName
            width: visible ? implicitWidth : 0
            flat: true
            toggled: ws.isFocused
            padding: Theme.spacingSm
            minWidth: Theme.buttonHeight
            icon: Glyphs.icons["ws-" + ws.name] !== undefined ? "ws-" + ws.name : ""
            iconScale: 1.5
            text: Glyphs.icons["ws-" + ws.name] !== undefined ? "" : ws.index
            onClicked: Niri.focusWorkspaceById(ws.id)
        }
    }
}
