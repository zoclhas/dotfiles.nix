import QtQuick
import Quickshell

import qs.widgets
import qs.services

PopupPanel {
    id: root

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    onOpenChanged: if (open)
        calendar.view = new Date()

    onKeyPressed: event => {
        switch (event.key) {
        case Qt.Key_Left:
        case Qt.Key_H:
        case Qt.Key_PageUp:
            calendar.shift(-1);
            break;
        case Qt.Key_Right:
        case Qt.Key_L:
        case Qt.Key_PageDown:
            calendar.shift(1);
            break;
        case Qt.Key_Up:
        case Qt.Key_K:
            calendar.shift(-12);
            break;
        case Qt.Key_Down:
        case Qt.Key_J:
            calendar.shift(12);
            break;
        case Qt.Key_Home:
        case Qt.Key_T:
            calendar.view = new Date();
            break;
        default:
            return;
        }
        event.accepted = true;
    }

    Dialog {
        title: "Date & Time"
        icon: "calendar"
        minWidth: 340
        onCloseClicked: root.dismiss()

        Column {
            width: 310
            spacing: Theme.spacingMd

            RText {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: Qt.formatTime(clock.date, "hh:mm:ss")
                font.pixelSize: 36
                font.bold: true
            }
            RText {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: Qt.formatDate(clock.date, "dddd, d MMMM yyyy")
            }

            Calendar {
                id: calendar
                width: parent.width
                height: 244
            }
        }
    }
}
