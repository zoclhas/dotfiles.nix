import QtQuick
import Quickshell

import qs.services

Item {
    id: root

    required property ShellScreen targetScreen

    property var heights: ({})

    function offsetFor(index) {
        let y = 0;
        for (let i = 0; i < index; i++) {
            const id = Notifications.popups.get(i).notifId;
            y += (root.heights[id] ?? 100) + Theme.spacingMd;
        }
        return y;
    }

    function reportHeight(id, height) {
        const next = Object.assign({}, root.heights);
        next[id] = height;
        root.heights = next;
    }

    Instantiator {
        model: Notifications.popups

        delegate: NotificationWindow {
            required property int index
            required property var model

            targetScreen: root.targetScreen
            stackOffset: root.offsetFor(index)

            notifId: model.notifId
            appName: model.appName
            appIcon: model.appIcon
            summary: model.summary
            body: model.body
            image: model.image
            urgency: model.urgency
            actions: model.actions
            hasInlineReply: model.hasInlineReply
            inlineReplyPlaceholder: model.inlineReplyPlaceholder

            onHeightReported: (id, h) => root.reportHeight(id, h)
        }
    }
}
