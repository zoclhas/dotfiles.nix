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

    property bool isPopup: false

    color: {
        const c = Qt.color(Colors.surfaceVariant);
        return Qt.rgba(c.r, c.g, c.b, Style.backgroundOpacity);
    }
    shadowBlur: Style.shadowBlur
    radius: Style.radius
    borderEnabled: root.urgency === 2
    borderColor: Colors.error
    shadowEnabled: root.isPopup

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

        Text {
            Layout.fillWidth: true
            text: root.summary
            color: Colors.onBackground
            font.family: Style.fontFamily
            font.pixelSize: Style.fs(-1)
            font.bold: true
            wrapMode: Text.Wrap
            maximumLineCount: 2
            elide: Text.ElideRight
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
            maximumLineCount: 3
            elide: Text.ElideRight
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
    }

    Process {
        id: copyProc
        function copy(text) {
            command = ["wl-copy", text];
            running = true;
        }
    }
}
