import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

import qs.services
import qs.modules.components

StyledRect {
    id: root

    required property int notifId
    required property string appName
    required property string appIcon
    required property string summary
    required property string body
    required property string image
    required property int urgency
    required property double time
    required property var actionIdentifiers
    required property var actionTexts
    required property bool read
    required property bool hasInlineReply
    required property string inlineReplyPlaceholder

    property bool isPopup: false

    property bool expanded: false
    property bool replyOpen: false

    readonly property string detectedCode: {
        const src = `${root.summary} ${root.body}`;
        const keyed = src.match(/\b(?:OTP|otp|code|pin|passcode|password|verification)\b[^0-9]{0,12}(\d{4,8})/i);
        if (keyed)
            return keyed[1];
        const bare = src.match(/\b\d{4,8}\b/);
        return bare ? bare[0] : "";
    }

    function sendReply() {
        if (replyInput.text.trim() === "")
            return;
        Notifications.sendInlineReply(root.notifId, replyInput.text);
        replyInput.text = "";
        root.replyOpen = false;
    }

    color: {
        const c = Qt.color(Colors.surfaceVariant);
        return Qt.rgba(c.r, c.g, c.b, Style.backgroundOpacity);
    }
    shadowBlur: Style.shadowBlur
    radius: Style.radius
    borderEnabled: root.urgency === 2
    borderColor: Colors.error
    shadowEnabled: root.isPopup
    opacity: root.read ? 0.6 : 1

    Behavior on opacity {
        NumberAnimation { duration: Style.quickDuration; easing.type: Easing.OutCubic }
    }

    implicitHeight: col.implicitHeight + Style.spacingMd * 2

    ColumnLayout {
        id: col
        anchors.fill: parent
        anchors.margins: Style.spacingMd
        spacing: Style.spacingXs

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.spacingSm

            IconImage {
                id: appIconImage
                implicitSize: 16
                source: root.appIcon ? Quickshell.iconPath(root.appIcon, true) : ""
            }

            Text {
                visible: appIconImage.status !== Image.Ready
                text: Icons.bell
                color: Colors.onBackground
                opacity: 0.6
                font.family: Style.fontFamily
                font.pixelSize: Style.fsIcon(-4)
            }

            Text {
                Layout.fillWidth: true
                text: root.appName
                color: Colors.onBackground
                opacity: 0.7
                font.family: Style.fontFamily
                font.pixelSize: Style.fs(-2)
                elide: Text.ElideRight
            }

            Button {
                width: 18
                height: 18
                radius: Style.radius
                baseColor: Qt.rgba(0, 0, 0, 0)
                hoverColor: Colors.surface
                onClicked: copyProc.copy(root.body || root.summary)
                Text {
                    anchors.centerIn: parent
                    text: Icons.contentCopy
                    color: Colors.onBackground
                    font.family: Style.fontFamily
                    font.pixelSize: Style.fs(-3)
                }
            }

            Button {
                width: 18
                height: 18
                radius: Style.radius
                baseColor: Qt.rgba(0, 0, 0, 0)
                hoverColor: Colors.surface
                onClicked: Notifications.dismiss(root.notifId)
                Text {
                    anchors.centerIn: parent
                    text: Icons.close
                    color: Colors.onBackground
                    font.family: Style.fontFamily
                    font.pixelSize: Style.fs(-3)
                }
            }
        }

        Item {
            Layout.fillWidth: true
            implicitHeight: textCol.implicitHeight

            HoverHandler {
                cursorShape: Qt.PointingHandCursor
            }
            TapHandler {
                onTapped: root.expanded = !root.expanded
            }

            ColumnLayout {
                id: textCol
                width: parent.width
                spacing: Style.spacingXs

                Text {
                    Layout.fillWidth: true
                    text: root.summary
                    color: Colors.onBackground
                    font.family: Style.fontFamily
                    font.pixelSize: Style.fs(-1)
                    font.bold: true
                    wrapMode: Text.Wrap
                    maximumLineCount: root.expanded ? 1000 : 2
                    elide: root.expanded ? Text.ElideNone : Text.ElideRight
                }

                Text {
                    Layout.fillWidth: true
                    visible: root.body !== ""
                    text: root.body
                    color: Colors.onBackground
                    opacity: 0.8
                    font.family: Style.fontFamily
                    font.pixelSize: Style.fs(-2)
                    wrapMode: Text.Wrap
                    maximumLineCount: root.expanded ? 1000 : 3
                    elide: root.expanded ? Text.ElideNone : Text.ElideRight
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            visible: (root.actionIdentifiers?.length ?? 0) > 0
            spacing: Style.spacingXs

            Repeater {
                model: root.actionIdentifiers

                delegate: Button {
                    id: actionButton
                    required property string modelData
                    required property int index

                    Layout.fillWidth: true
                    height: 24
                    radius: Style.radius
                    baseColor: Colors.surface
                    hoverColor: Qt.lighter(Colors.surface, 1.3)
                    onClicked: Notifications.invokeAction(root.notifId, actionButton.modelData)

                    Text {
                        anchors.centerIn: parent
                        text: root.actionTexts[actionButton.index] ?? ""
                        color: Colors.onBackground
                        font.family: Style.fontFamily
                        font.pixelSize: Style.fs(-2)
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.spacingXs

            Button {
                visible: root.detectedCode !== ""
                Layout.fillWidth: true
                height: 30
                radius: Style.radius
                baseColor: Colors.surface
                hoverColor: Qt.lighter(Colors.surface, 1.3)
                onClicked: copyProc.copy(root.detectedCode)
                RowLayout {
                    anchors.centerIn: parent
                    spacing: Style.spacingXs
                    Text {
                        text: Icons.key
                        color: Colors.onBackground
                        font.family: Style.fontFamily
                        font.pixelSize: Style.fsIcon(-4)
                    }
                    Text {
                        text: root.detectedCode
                        color: Colors.onBackground
                        font.family: Style.fontFamily
                        font.pixelSize: Style.fs(-1)
                    }
                }
            }

            Button {
                Layout.fillWidth: true
                height: 30
                radius: Style.radius
                baseColor: Colors.surface
                hoverColor: Qt.lighter(Colors.surface, 1.3)
                onClicked: Notifications.archive(root.notifId)
                RowLayout {
                    anchors.centerIn: parent
                    spacing: Style.spacingXs
                    Text {
                        text: Icons.archive
                        color: Colors.onBackground
                        font.family: Style.fontFamily
                        font.pixelSize: Style.fsIcon(-4)
                    }
                    Text {
                        text: "Archive"
                        color: Colors.onBackground
                        font.family: Style.fontFamily
                        font.pixelSize: Style.fs(-1)
                    }
                }
            }

            Button {
                Layout.fillWidth: true
                height: 30
                radius: Style.radius
                baseColor: root.read ? Colors.primary : Colors.surface
                hoverColor: root.read ? Qt.lighter(Colors.primary, 1.1) : Qt.lighter(Colors.surface, 1.3)
                onClicked: root.read ? Notifications.markUnread(root.notifId) : Notifications.markRead(root.notifId)
                RowLayout {
                    anchors.centerIn: parent
                    spacing: Style.spacingXs
                    Text {
                        text: Icons.emailOpen
                        color: root.read ? Colors.onPrimary : Colors.onBackground
                        font.family: Style.fontFamily
                        font.pixelSize: Style.fsIcon(-4)
                    }
                    Text {
                        text: root.read ? "Unread" : "Read"
                        color: root.read ? Colors.onPrimary : Colors.onBackground
                        font.family: Style.fontFamily
                        font.pixelSize: Style.fs(-1)
                    }
                }
            }

            Button {
                visible: root.hasInlineReply
                Layout.fillWidth: true
                height: 30
                radius: Style.radius
                baseColor: root.replyOpen ? Colors.primary : Colors.surface
                hoverColor: root.replyOpen ? Qt.lighter(Colors.primary, 1.1) : Qt.lighter(Colors.surface, 1.3)
                onClicked: root.replyOpen = !root.replyOpen
                RowLayout {
                    anchors.centerIn: parent
                    spacing: Style.spacingXs
                    Text {
                        text: Icons.reply
                        color: root.replyOpen ? Colors.onPrimary : Colors.onBackground
                        font.family: Style.fontFamily
                        font.pixelSize: Style.fsIcon(-4)
                    }
                    Text {
                        text: "Reply"
                        color: root.replyOpen ? Colors.onPrimary : Colors.onBackground
                        font.family: Style.fontFamily
                        font.pixelSize: Style.fs(-1)
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            visible: root.replyOpen && root.hasInlineReply
            spacing: Style.spacingXs

            StyledRect {
                Layout.fillWidth: true
                height: 28
                radius: Style.radius
                color: Colors.surface

                TextInput {
                    id: replyInput
                    anchors.fill: parent
                    anchors.margins: Style.spacingXs
                    verticalAlignment: TextInput.AlignVCenter
                    color: Colors.onBackground
                    font.family: Style.fontFamily
                    font.pixelSize: Style.fs(-2)
                    clip: true
                    Keys.onReturnPressed: root.sendReply()

                    Text {
                        visible: replyInput.text === "" && !replyInput.activeFocus
                        text: root.inlineReplyPlaceholder || "Reply"
                        color: Colors.onBackground
                        opacity: 0.5
                        font.family: Style.fontFamily
                        font.pixelSize: Style.fs(-2)
                    }
                }
            }

            Button {
                width: 28
                height: 28
                radius: Style.radius
                baseColor: Colors.primary
                hoverColor: Qt.lighter(Colors.primary, 1.1)
                onClicked: root.sendReply()
                Text {
                    anchors.centerIn: parent
                    text: Icons.send
                    color: Colors.onPrimary
                    font.family: Style.fontFamily
                    font.pixelSize: Style.fs(-3)
                }
            }
        }
    }

    Process {
        id: copyProc
        function copy(text) {
            command = ["wl-copy", text];
            running = true;
        }
    }
}
