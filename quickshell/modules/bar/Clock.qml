import QtQuick
import Quickshell

import qs.widgets

Button {
    id: root

    flat: true
    text: Qt.formatDateTime(clock.date, "ddd d MMM  HH:mm:ss")

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
