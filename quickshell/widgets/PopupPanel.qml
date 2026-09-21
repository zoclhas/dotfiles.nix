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
    property real _anchorCenter: root.width / 2
    function _place() {
        if (!root.anchorItem)
            return;
        const left = root.anchorItem.mapToItem(null, 0, 0).x;
        root._anchorRight = left + root.anchorItem.width;
        root._anchorCenter = left + root.anchorItem.width / 2;
    }
    property int bottomInset: Theme.barHeight
    property int sideInset: 0

    property bool leftAlign: false

    property bool centerAlign: false

    property bool escapeCloses: true

    default property alias content: pop.data

    property alias overlay: overlayLayer.data

    signal keyPressed(var event)

    function dismiss(fromFocusLoss) {
        if (!root.open)
            return;
        if (fromFocusLoss === true)
            Session.noteFocusDismiss(root.name);
        Session.panel = "";
    }

    visible: root.open || pop.animating
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
                root.dismiss(true);
        }

        Keys.onEscapePressed: event => {
            if (root.escapeCloses)
                root.dismiss();
            else
                event.accepted = false;
        }
        Keys.onPressed: event => root.keyPressed(event)

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.AllButtons
            onPressed: mouse => {
                const p = mapToItem(pop, mouse.x, mouse.y);
                if (p.x < 0 || p.y < 0 || p.x > pop.width || p.y > pop.height)
                    root.dismiss();
            }
        }

        PopIn {
            id: pop
            open: root.open
            wireSteps: 4
            wipeSteps: 6
            stepMs: 27
            originX: root.leftAlign ? 0 : (root.centerAlign ? 0.5 : 1)
            originY: 1
            anchors.bottom: parent.bottom
            x: root.leftAlign ? root.sideInset : Math.max(root.sideInset, Math.min(root.width - width - root.sideInset, root.centerAlign ? root._anchorCenter - width / 2 : root._anchorRight - width))
            width: pop.contentItem.childrenRect.width
            height: pop.contentItem.childrenRect.height
        }

        Item {
            id: overlayLayer
            anchors.fill: parent
        }
    }
}
