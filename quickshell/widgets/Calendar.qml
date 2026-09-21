import QtQuick

import qs.services

GroupBox {
    id: root

    property date view: new Date()

    property int cursorButton: -1

    readonly property real innerW: root.width - 2 * Theme.spacingMd
    readonly property real innerH: root.height - root.labelH - Theme.spacingSm - Theme.spacingMd
    readonly property int navH: Theme.buttonHeight
    readonly property int cell: Math.max(24, Math.floor(root.innerW / 7))
    readonly property int headH: 20
    readonly property int rowH: Math.max(20, Math.floor((root.innerH - root.navH - root.headH - 2 * Theme.spacingXs) / 6))
    readonly property date today: new Date()

    readonly property int firstOffset: (new Date(root.view.getFullYear(), root.view.getMonth(), 1).getDay() + 6) % 7
    readonly property int daysInMonth: new Date(root.view.getFullYear(), root.view.getMonth() + 1, 0).getDate()

    title: Qt.formatDate(root.view, "MMMM yyyy")

    function shift(months) {
        root.view = new Date(root.view.getFullYear(), root.view.getMonth() + months, 1);
    }

    Column {
        spacing: Theme.spacingXs

        Row {
            spacing: Theme.spacingXs

            Button {
                icon: "left"
                cursor: root.cursorButton === 0
                padding: Theme.spacingSm
                onClicked: root.shift(-1)
            }
            Button {
                icon: "right"
                cursor: root.cursorButton === 1
                padding: Theme.spacingSm
                onClicked: root.shift(1)
            }
        }

        Grid {
            columns: 7

            Repeater {
                model: ["M", "T", "W", "T", "F", "S", "S"]

                RText {
                    required property string modelData
                    width: root.cell
                    height: root.headH
                    horizontalAlignment: Text.AlignHCenter
                    text: modelData
                    opacity: 0.7
                }
            }

            Repeater {
                model: 42

                Item {
                    id: day
                    required property int index
                    readonly property int n: day.index - root.firstOffset + 1
                    readonly property bool valid: day.n >= 1 && day.n <= root.daysInMonth
                    readonly property bool isToday: day.valid && root.view.getFullYear() === root.today.getFullYear() && root.view.getMonth() === root.today.getMonth() && day.n === root.today.getDate()

                    width: root.cell
                    height: root.rowH

                    PixelRect {
                        anchors.fill: parent
                        anchors.margins: 1
                        color: day.isToday ? Theme.selection : "transparent"
                    }
                    RText {
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: day.valid ? day.n : ""
                        color: day.isToday ? Theme.selectionText : Theme.text
                    }
                }
            }
        }
    }
}
