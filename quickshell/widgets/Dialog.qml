import QtQuick

import qs.services

Bevel {
    id: root

    property string title: ""
    property string icon: ""
    property bool showClose: true
    property int minWidth: 0
    property int padding: Theme.spacingMd

    default property alias content: body.data

    signal closeClicked

    style: "outset"
    depth: 2

    implicitWidth: Math.max(root.minWidth, body.childrenRect.width + 2 * (root.insetX + root.padding))
    implicitHeight: titleBar.height + body.childrenRect.height + 2 * (root.insetY + root.padding)

    Item {
        id: titleBar
        width: parent.width
        height: Theme.titleBarHeight

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop {
                    position: 0
                    color: Theme.accent
                }
                GradientStop {
                    position: 1
                    color: Theme.accentAlt
                }
            }
        }
        Row {
            anchors.verticalCenter: parent.verticalCenter
            x: Theme.spacingSm
            spacing: Theme.spacingSm

            PixelIcon {
                visible: root.icon.length > 0
                anchors.verticalCenter: parent.verticalCenter
                name: root.icon
                scale: 2
                color: Theme.accentText
            }
            RText {
                anchors.verticalCenter: parent.verticalCenter
                text: root.title
                color: Theme.accentText
            }
        }
        Button {
            visible: root.showClose
            anchors.right: parent.right
            anchors.rightMargin: Theme.spacingSm
            anchors.verticalCenter: parent.verticalCenter
            implicitHeight: parent.height - 2 * Theme.px
            padding: Theme.spacingSm
            text: "x"
            onClicked: root.closeClicked()
        }
    }

    Item {
        id: body
        x: root.padding
        y: titleBar.height + root.padding
        width: parent.width - 2 * root.padding
        height: childrenRect.height
    }
}
