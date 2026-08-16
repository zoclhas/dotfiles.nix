import QtQuick
import QtQuick.Layouts

import qs.services
import qs.modules.components

Item {
    id: root

    property int monthShift: 0
    property date now: new Date()

    Timer {
        interval: 60000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.now = new Date()
    }

    readonly property date viewDate: {
        const d = new Date(root.now);
        d.setDate(1);
        d.setMonth(d.getMonth() + root.monthShift);
        return d;
    }

    readonly property var weeks: {
        const first = new Date(root.viewDate.getFullYear(), root.viewDate.getMonth(), 1);
        const startOffset = (first.getDay() + 6) % 7;
        const gridStart = new Date(first);
        gridStart.setDate(1 - startOffset);

        const today = root.now;
        const rows = [];
        let cursor = new Date(gridStart);
        for (let w = 0; w < 6; w++) {
            const row = [];
            for (let d = 0; d < 7; d++) {
                row.push({
                    day: cursor.getDate(),
                    inMonth: cursor.getMonth() === root.viewDate.getMonth(),
                    isToday: cursor.toDateString() === today.toDateString()
                });
                cursor.setDate(cursor.getDate() + 1);
            }
            rows.push(row);
        }
        return rows;
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: Style.spacingXs

        RowLayout {
            Layout.fillWidth: true

            Button {
                width: 22
                height: 22
                radius: Style.radius
                baseColor: Qt.rgba(0, 0, 0, 0)
                hoverColor: Colors.surfaceVariant
                onClicked: root.monthShift -= 1
                Text {
                    anchors.centerIn: parent
                    text: Icons.chevronLeft
                    color: Colors.onBackground
                    font.family: Style.fontFamily
                    font.pixelSize: Style.fsIcon(-3)
                }
            }

            Text {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: Qt.formatDate(root.viewDate, "MMMM yyyy")
                color: Colors.onBackground
                font.family: Style.fontFamily
                font.pixelSize: Style.fs(0)
                font.bold: true
            }

            Button {
                width: 22
                height: 22
                radius: Style.radius
                baseColor: Qt.rgba(0, 0, 0, 0)
                hoverColor: Colors.surfaceVariant
                onClicked: root.monthShift += 1
                Text {
                    anchors.centerIn: parent
                    text: Icons.chevronRight
                    color: Colors.onBackground
                    font.family: Style.fontFamily
                    font.pixelSize: Style.fsIcon(-3)
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.bottomMargin: Style.spacingXs

            Repeater {
                model: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
                delegate: Text {
                    required property string modelData
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    text: modelData
                    color: Colors.onBackground
                    opacity: 0.5
                    font.family: Style.fontFamily
                    font.pixelSize: Style.fs(-2)
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            Layout.bottomMargin: Style.spacingXs
            color: Colors.outline
            opacity: 0.2
        }

        Repeater {
            model: root.weeks
            delegate: StyledRect {
                id: weekChip
                required property var modelData
                required property int index

                Layout.fillWidth: true
                Layout.preferredHeight: 26
                color: modelData.some(d => d.isToday) ? Colors.surfaceVariant : Qt.rgba(Colors.primary.r, Colors.primary.g, Colors.primary.b, 0.08)
                radius: Style.radius

                RowLayout {
                    anchors.fill: parent

                    Repeater {
                        model: weekChip.modelData

                        delegate: Item {
                            required property var modelData
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            Rectangle {
                                anchors.centerIn: parent
                                width: 20
                                height: 20
                                radius: Style.innerRadius(3)
                                color: modelData.isToday ? Colors.primary : "transparent"

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.day
                                    color: modelData.isToday ? Colors.onPrimary : (modelData.inMonth ? Colors.onBackground : Qt.rgba(1, 1, 1, 0.25))
                                    font.family: Style.fontFamily
                                    font.pixelSize: Style.fs(-2)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
