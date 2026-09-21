import QtQuick

import qs.services

Bevel {
    id: root

    property real value: 0
    property color fillColor: Theme.accent
    property int segmentWidth: 8
    property int segmentGap: Theme.px

    property bool bevel: true
    readonly property int pad: root.bevel ? Theme.px : 0

    style: root.bevel ? "inset" : "flat"
    depth: root.bevel ? 1 : 0
    faceColor: Theme.well

    readonly property int slots: Math.max(1, Math.floor((root.width - 2 * root.insetX - 2 * root.pad + root.segmentGap) / (root.segmentWidth + root.segmentGap)))
    readonly property int lit: Math.round(Math.max(0, Math.min(1, root.value)) * root.slots)

    Row {
        anchors.centerIn: parent
        spacing: root.segmentGap

        Repeater {
            model: root.slots

            Rectangle {
                required property int index
                width: root.segmentWidth
                height: root.height - 2 * root.insetY - 2 * root.pad
                color: index < root.lit ? root.fillColor : "transparent"
            }
        }
    }
}
