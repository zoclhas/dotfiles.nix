import QtQuick

import qs.services

Row {
    id: root

    property string label: ""
    property real value: 0
    property string detail: ""
    property real labelWidth: 44
    property real detailWidth: 72
    property color fillColor: Theme.accent

    spacing: Theme.spacingSm

    RText {
        width: root.labelWidth
        height: 16
        text: root.label
    }
    SegmentBar {
        width: root.width - root.labelWidth - root.detailWidth - 2 * root.spacing
        height: 16
        value: root.value
        fillColor: root.fillColor
    }
    RText {
        width: root.detailWidth
        height: 16
        horizontalAlignment: Text.AlignRight
        text: root.detail
    }
}
