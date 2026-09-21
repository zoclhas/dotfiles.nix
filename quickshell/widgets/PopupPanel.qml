import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.services

PanelWindow {
    id: root

    required property string name
    readonly property bool open: Session.panel === root.name
    property Item anchorItem: null
    property real _anchorRight: root.width
    function _place() {
        if (root.anchorItem)
            root._anchorRight = root.anchorItem.mapToItem(null, root.anchorItem.width, 0).x;
    }
    property int bottomInset: Theme.barHeight
    property int sideInset: 0

    default property alias content: holder.data

    signal keyPressed(var event)

    function dismiss() {
        if (root.open)
            Session.panel = "";
    }

    visible: root.open
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    margins.bottom: root.bottomInset

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "zochell-popup-" + root.name.split(":")[0]
    WlrLayershell.keyboardFocus: root.open ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    Connections {
        target: Niri
        function onFocusedWindowChanged() {
            if (Niri.focusedWindow !== null && Niri.focusedWindow !== undefined)
                root.dismiss();
        }
    }

    property bool _hadFocus: false
    onOpenChanged: {
        root._hadFocus = false;
        if (root.open)
            root._place();
    }

    FocusScope {
        anchors.fill: parent
        focus: root.open

        onActiveFocusChanged: {
            if (activeFocus)
                root._hadFocus = true;
            else if (root._hadFocus)
                root.dismiss();
        }

        Keys.onEscapePressed: root.dismiss()
        Keys.onPressed: event => root.keyPressed(event)

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.AllButtons
            onPressed: mouse => {
                const p = mapToItem(holder, mouse.x, mouse.y);
                if (p.x < 0 || p.y < 0 || p.x > holder.width || p.y > holder.height)
                    root.dismiss();
            }
        }

        Item {
            id: holder
            anchors.bottom: parent.bottom
            x: Math.max(root.sideInset, Math.min(root.width - width - root.sideInset, root._anchorRight - width))
            width: childrenRect.width
            height: childrenRect.height
        }
    }
}
