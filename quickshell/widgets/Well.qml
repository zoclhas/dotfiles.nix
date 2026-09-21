import QtQuick

import qs.widgets
import qs.services

Item {
    id: root

    default property alias data: row.data
    property int padding: Theme.spacingSm
    property alias spacing: row.spacing
    property color faceColor: Theme.face

    implicitWidth: row.implicitWidth + 2 * root.padding + 2 * bevel.insetX
    implicitHeight: Theme.buttonHeight

    Bevel {
        id: bevel
        anchors.fill: parent
        style: "inset"
        depth: 1
        faceColor: root.faceColor
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: Theme.spacingSm
    }
}
