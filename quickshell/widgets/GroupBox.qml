import QtQuick

import qs.services

Item {
    id: root

    default property alias data: inner.data
    property string title: ""

    readonly property real labelH: label.implicitHeight

    Bevel {
        x: 0
        y: root.labelH / 2
        width: root.width
        height: root.height - root.labelH / 2
        style: "groove"
        faceColor: Theme.face
    }

    Rectangle {
        visible: root.title.length > 0
        x: Theme.spacingMd
        width: label.implicitWidth + 2 * Theme.spacingSm
        height: label.implicitHeight
        color: Theme.face

        RText {
            id: label
            anchors.centerIn: parent
            text: root.title
        }
    }

    Item {
        id: inner
        x: Theme.spacingMd
        y: root.labelH + Theme.spacingSm
        width: root.width - 2 * Theme.spacingMd
        height: root.height - y - Theme.spacingMd
    }
}
