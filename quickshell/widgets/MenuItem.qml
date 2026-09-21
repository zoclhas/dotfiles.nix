import QtQuick

Button {
    id: root

    property string detail: ""

    flat: true
    implicitWidth: Math.max(minWidth, naturalWidth + 2 * padding)
    text: root.detail.length > 0 ? root.label + "  [" + root.detail + "]" : root.label
    property string label: ""
}
