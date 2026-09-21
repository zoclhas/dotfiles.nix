import QtQuick
import Quickshell

import qs.widgets
import qs.services

Column {
    id: root

    required property int notifId
    property string appIcon: ""
    property string summary: ""
    property string body: ""
    property string image: ""
    property var actions: null
    property bool hasInlineReply: false
    property string inlineReplyPlaceholder: ""

    property bool list: false
    property bool read: false

    property bool expanded: false
    property bool replyOpen: false

    readonly property int actionCount: {
        let n = 0;
        const total = root.actions?.count ?? 0;
        for (let i = 0; i < total; i++) {
            if (root.actions.get(i).text)
                n++;
        }
        return n;
    }

    readonly property string code: Notifications.codeIn(root.summary + " " + root.body)
    readonly property bool truncated: summaryText.truncated || bodyText.truncated

    property int cursorButton: -1
    onCursorButtonChanged: root.applyCursor()

    signal toggleExpanded

    function buttons() {
        const r = [];
        for (const f of [actionFlow, ctrlFlow]) {
            for (let i = 0; i < f.children.length; i++) {
                const c = f.children[i];
                if (c.visible && c.cursor !== undefined)
                    r.push(c);
            }
        }
        return r;
    }
    function applyCursor() {
        const b = root.buttons();
        for (let i = 0; i < b.length; i++)
            b[i].cursor = i === root.cursorButton;
    }
    function activateButton(i) {
        const b = root.buttons();
        if (i >= 0 && i < b.length)
            b[i].clicked();
    }

    spacing: Theme.spacingMd

    function sendReply() {
        if (reply.text.trim() === "")
            return;
        Notifications.sendInlineReply(root.notifId, reply.text);
        reply.text = "";
        root.replyOpen = false;
    }

    Item {
        width: parent.width
        height: Math.max(pic.visible ? pic.height : 0, textCol.implicitHeight)

        Image {
            id: pic
            visible: source.toString().length > 0 && status !== Image.Error
            width: 40
            height: 40
            fillMode: Image.PreserveAspectFit
            smooth: false
            sourceSize: Qt.size(80, 80)
            source: root.image.length > 0 ? root.image : (root.appIcon.length > 0 ? Quickshell.iconPath(root.appIcon, true) : "")
        }

        Column {
            id: textCol
            x: pic.visible ? pic.width + Theme.spacingMd : 0
            width: parent.width - x
            spacing: Theme.spacingXs

            RText {
                id: summaryText
                width: parent.width
                visible: text.length > 0
                text: root.summary
                font.bold: true
                wrapMode: Text.Wrap
                maximumLineCount: root.expanded ? 1000 : 2
                elide: root.expanded ? Text.ElideNone : Text.ElideRight
            }
            RText {
                id: bodyText
                width: parent.width
                visible: text.length > 0
                text: root.body
                textFormat: Text.StyledText
                wrapMode: Text.Wrap
                maximumLineCount: root.expanded ? 1000 : (root.list ? 3 : 6)
                elide: root.expanded ? Text.ElideNone : Text.ElideRight
                verticalAlignment: Text.AlignTop
            }
            RText {
                visible: root.truncated || root.expanded
                text: root.expanded ? "[-] show less" : "[+] read more"
                opacity: 0.7
            }
        }

        MouseArea {
            anchors.fill: parent
            enabled: root.truncated || root.expanded
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: root.toggleExpanded()
        }
    }

    Flow {
        id: actionFlow
        visible: root.actionCount > 0
        width: parent.width
        spacing: Theme.spacingSm

        Repeater {
            model: root.actions

            delegate: Button {
                required property int index
                required property var model
                visible: model.text.length > 0

                text: model.text
                gloss: index === 0
                minWidth: 72
                onClicked: Notifications.invokeAction(root.notifId, model.identifier)
            }
        }
    }

    Flow {
        id: ctrlFlow
        visible: root.code !== "" || root.hasInlineReply || root.list
        width: parent.width
        spacing: Theme.spacingSm

        Button {
            visible: root.code !== ""
            text: "Code " + root.code
            onClicked: Notifications.copy(root.code)
        }
        Button {
            visible: root.hasInlineReply
            text: "Reply"
            icon: "reply"
            toggled: root.replyOpen
            onClicked: root.replyOpen = !root.replyOpen
        }
        Button {
            text: "Copy text"
            onClicked: Notifications.copy(root.body || root.summary)
        }
        Button {
            visible: root.list
            icon: "check"
            text: root.read ? "Unread" : "Read"
            onClicked: root.read ? Notifications.markUnread(root.notifId) : Notifications.markRead(root.notifId)
        }
        Button {
            visible: root.list
            icon: "archive"
            text: "Archive"
            onClicked: Notifications.archive(root.notifId)
        }
        Button {
            visible: root.list
            icon: "close"
            onClicked: Notifications.dismiss(root.notifId)
        }
    }

    Row {
        visible: root.replyOpen && root.hasInlineReply
        width: parent.width
        spacing: Theme.spacingSm

        Field {
            id: reply
            width: parent.width - send.width - parent.spacing
            placeholder: root.inlineReplyPlaceholder || "Reply"
            onAccepted: root.sendReply()
            onVisibleChanged: if (visible)
                forceActiveFocus()
        }
        Button {
            id: send
            text: "Send"
            implicitHeight: reply.height
            onClicked: root.sendReply()
        }
    }
}
