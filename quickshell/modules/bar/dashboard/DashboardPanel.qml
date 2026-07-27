import QtQuick
import QtQuick.Layouts

import qs.services

Item {
    id: root

    RowLayout {
        anchors.fill: parent
        anchors.margins: Style.spacingLg
        spacing: Style.spacingLg

        PlayerSection {
            Layout.preferredWidth: 240
            Layout.fillHeight: true
        }

        ColumnLayout {
            Layout.preferredWidth: 280
            Layout.fillHeight: true
            spacing: Style.spacingSm

            QuickToggles {
                Layout.fillWidth: true
            }

            CalendarSection {
                Layout.fillWidth: true
            }

            Item {
                Layout.fillHeight: true
            }
        }

        NotificationsSection {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 220
        }
    }
}
