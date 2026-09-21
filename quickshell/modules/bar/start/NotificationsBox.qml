import QtQuick

import qs.widgets
import qs.services
import qs.modules.notifications

GroupBox {
    id: root

    title: "Notifications"

    property bool focused: false
    property int cursor: 0

    property int button: -1
    readonly property alias view: list

    property var expandedIds: ({})
    function toggleExpand(id) {
        const next = Object.assign({}, root.expandedIds);
        next[id] = !next[id];
        root.expandedIds = next;
    }
    function bodyAt(i) {
        return list.itemAtIndex(i)?.bodyItem ?? null;
    }
    function buttonCount(i) {
        return root.bodyAt(i)?.buttons().length ?? 0;
    }
    function activateButton(i, b) {
        root.bodyAt(i)?.activateButton(b);
    }
    function copyCode(id) {
        for (let i = 0; i < Notifications.list.count; i++) {
            const n = Notifications.list.get(i);
            if (n.notifId === id) {
                const c = Notifications.codeIn(n.summary + " " + n.body);
                Notifications.copy(c !== "" ? c : (n.body || n.summary));
                return;
            }
        }
    }

    property date now: new Date()
    Timer {
        interval: 30000
        running: root.visible
        repeat: true
        onTriggered: root.now = new Date()
    }

    function ago(ms) {
        const s = Math.max(0, Math.round((root.now.getTime() - ms) / 1000));
        if (s < 60)
            return "now";
        if (s < 3600)
            return Math.floor(s / 60) + "m ago";
        if (s < 86400)
            return Math.floor(s / 3600) + "h ago";
        return Math.floor(s / 86400) + "d ago";
    }

    onCursorChanged: list.positionViewAtIndex(Math.max(0, Math.min(root.cursor, list.count - 1)), ListView.Contain)

    Rectangle {
        visible: root.focused
        x: -Theme.spacingMd
        y: -(root.labelH + Theme.spacingSm)
        width: root.width
        height: root.height
        color: "transparent"
        border.width: Theme.px
        border.color: Theme.accent
    }

    Column {
        width: parent.width
        height: parent.height
        spacing: Theme.spacingSm

        Row {
            width: parent.width

            RText {
                width: parent.width - clear.width
                height: clear.height
                text: Notifications.list.count + (Notifications.list.count === 1 ? " item" : " items")
                opacity: 0.7
            }
            Button {
                id: clear
                text: "Clear all"
                icon: "trash"
                enabled: Notifications.list.count > 0
                onClicked: Notifications.dismissAll()
            }
        }

        Separator {
            width: parent.width
        }

        RText {
            visible: Notifications.list.count === 0
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            height: 80
            text: "No notifications"
            opacity: 0.7
        }

        Item {
            visible: Notifications.list.count > 0
            width: parent.width
            height: parent.height - y

            ListView {
                id: list
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: bar.visible ? bar.left : parent.right
                anchors.rightMargin: bar.visible ? Theme.spacingSm : 0
                clip: true
                spacing: Theme.spacingSm
                model: Notifications.list
                boundsBehavior: Flickable.StopAtBounds

                delegate: Item {
                    id: row

                    required property int index
                    required property int notifId
                    required property string appName
                    required property string appIcon
                    required property string summary
                    required property string body
                    required property double time
                    required property bool read
                    required property var actions
                    required property bool hasInlineReply
                    required property string inlineReplyPlaceholder

                    width: list.width
                    height: card.height
                    readonly property Item bodyItem: cardBody

                    Bevel {
                        id: card
                        width: parent.width
                        height: content.implicitHeight + 2 * Theme.spacingMd + 2 * insetY
                        style: "inset"
                        depth: 1
                        faceColor: row.read ? Theme.face : Theme.well

                        Column {
                            id: content
                            x: Theme.spacingMd - card.insetX
                            y: Theme.spacingMd - card.insetY
                            width: parent.width - 2 * (Theme.spacingMd - card.insetX)
                            spacing: Theme.spacingXs

                            Row {
                                width: parent.width
                                spacing: Theme.spacingSm

                                PixelIcon {
                                    anchors.verticalCenter: parent.verticalCenter
                                    name: "bell"
                                    scale: 1
                                    color: row.read ? Theme.textDisabled : Theme.accent
                                }
                                RText {
                                    width: parent.width - Glyphs.cellW - timeText.width - 2 * parent.spacing
                                    text: row.appName
                                    font.bold: !row.read
                                    elide: Text.ElideRight
                                    color: row.read ? Theme.text : Theme.wellText
                                }
                                RText {
                                    id: timeText
                                    text: root.ago(row.time)
                                    opacity: 0.7
                                    color: row.read ? Theme.text : Theme.wellText
                                }
                            }
                            NotificationBody {
                                id: cardBody
                                width: parent.width
                                list: true
                                cursorButton: root.focused && row.index === root.cursor ? root.button : -1
                                notifId: row.notifId
                                appIcon: ""
                                summary: row.summary
                                body: row.body
                                actions: row.actions
                                read: row.read
                                hasInlineReply: row.hasInlineReply
                                inlineReplyPlaceholder: row.inlineReplyPlaceholder
                                expanded: root.expandedIds[row.notifId] === true
                                onToggleExpanded: root.toggleExpand(row.notifId)
                            }
                        }
                    }

                    Rectangle {
                        visible: root.focused && row.index === root.cursor
                        anchors.fill: card
                        anchors.margins: -Theme.px
                        color: "transparent"
                        border.width: Theme.px
                        border.color: Theme.accent
                    }
                }
            }

            ScrollBar {
                id: bar
                target: list
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
            }
        }
    }
}
