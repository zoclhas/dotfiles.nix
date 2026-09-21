import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications

import qs.widgets
import qs.services

PanelWindow {
    id: root

    required property ShellScreen targetScreen
    screen: root.targetScreen

    property int notifId: -1
    property string appName: ""
    property string appIcon: ""
    property string summary: ""
    property string body: ""
    property string image: ""
    property int urgency: 1
    property var actions: null
    property bool hasInlineReply: false
    property string inlineReplyPlaceholder: ""

    property real stackOffset: 0
    property bool expanded: false
    readonly property bool critical: root.urgency === NotificationUrgency.Critical

    signal heightReported(int notifId, real height)

    anchors {
        bottom: true
        right: true
    }
    margins.bottom: Theme.barHeight + Theme.spacingMd + root.stackOffset
    margins.right: Theme.spacingMd

    implicitWidth: dialog.implicitWidth
    implicitHeight: dialog.implicitHeight
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "zochell-notification"

    WlrLayershell.keyboardFocus: cardBody.replyOpen ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    Component.onCompleted: {
        root.heightReported(root.notifId, dialog.implicitHeight);
        pop.play();
    }
    Connections {
        target: dialog
        function onImplicitHeightChanged() {
            root.heightReported(root.notifId, dialog.implicitHeight);
        }
    }

    PopIn {
        id: pop
        anchors.fill: parent
        originX: 1
        originY: 1

        Dialog {
            id: dialog
            anchors.fill: parent
            minWidth: 340
            title: root.appName
            icon: root.critical ? "alert" : "bell"
            onCloseClicked: Notifications.dismiss(root.notifId)

            NotificationBody {
                id: cardBody
                width: 300
                notifId: root.notifId
                appIcon: root.appIcon
                summary: root.summary
                body: root.body
                image: root.image
                actions: root.actions
                hasInlineReply: root.hasInlineReply
                inlineReplyPlaceholder: root.inlineReplyPlaceholder
                expanded: root.expanded
                onToggleExpanded: root.expanded = !root.expanded
            }
        }
    }
}
