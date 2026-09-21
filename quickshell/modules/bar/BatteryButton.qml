import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.widgets
import qs.services

Button {
    id: root

    visible: Battery.available
    flat: true
    readonly property string panelName: "battery:" + (QsWindow.window?.screen?.name ?? "")
    toggled: Session.panel === root.panelName
    icon: Glyphs.battery(Battery.percent, Battery.charging)
    text: Battery.percent + "%"
    onClicked: Session.togglePanel(root.panelName)

    readonly property var profiles: [
        {
            key: "PowerSaver",
            label: "Power Saver",
            icon: "leaf"
        },
        {
            key: "Balanced",
            label: "Balanced",
            icon: "gauge"
        },
        {
            key: "Performance",
            label: "Performance",
            icon: "bolt"
        }
    ]
    property int cursor: 0

    function resetCursor() {
        root.cursor = Math.max(0, root.profiles.findIndex(p => p.key === PowerProfileService.current));
    }

    readonly property color barColor: Battery.level === "critical" && !Battery.charging ? Theme.danger : Theme.accent

    PopupPanel {
        id: popup

        name: root.panelName
        anchorItem: root
        screen: QsWindow.window?.screen ?? null
        onOpenChanged: if (open)
            root.resetCursor()
        onKeyPressed: event => {
            const n = root.profiles.length;
            switch (event.key) {
            case Qt.Key_Up:
            case Qt.Key_K:
                root.cursor = (root.cursor + n - 1) % n;
                break;
            case Qt.Key_Down:
            case Qt.Key_J:
            case Qt.Key_Tab:
                root.cursor = (root.cursor + 1) % n;
                break;
            case Qt.Key_Return:
            case Qt.Key_Enter:
            case Qt.Key_Space:
                PowerProfileService.setProfile(root.profiles[root.cursor].key);
                break;
            case Qt.Key_1:
            case Qt.Key_2:
            case Qt.Key_3:
                root.cursor = event.key - Qt.Key_1;
                PowerProfileService.setProfile(root.profiles[root.cursor].key);
                break;
            default:
                return;
            }
            event.accepted = true;
        }

        Bevel {
            id: frame
            style: "outset"
            depth: 2
            width: 340
            height: implicitHeight
            implicitWidth: 340
            implicitHeight: titleBar.height + body.implicitHeight + 2 * insetY + 2 * Theme.spacingMd

            Item {
                id: titleBar
                width: parent.width
                height: Theme.titleBarHeight

                Rectangle {
                    anchors.fill: parent
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop {
                            position: 0
                            color: Theme.accent
                        }
                        GradientStop {
                            position: 1
                            color: Theme.accentAlt
                        }
                    }
                }
                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    x: Theme.spacingSm
                    spacing: Theme.spacingSm
                    PixelIcon {
                        anchors.verticalCenter: parent.verticalCenter
                        name: "battery"
                        scale: 2
                        color: Theme.accentText
                    }
                    RText {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Power"
                        color: Theme.accentText
                    }
                }
                Button {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    implicitHeight: parent.height - 2 * Theme.px
                    padding: Theme.spacingSm
                    text: "x"
                    onClicked: popup.dismiss()
                }
            }

            Column {
                id: body
                x: Theme.spacingMd
                y: titleBar.height + Theme.spacingMd
                width: parent.width - 2 * Theme.spacingMd
                spacing: Theme.spacingMd

                Column {
                    width: parent.width
                    spacing: Theme.spacingMd
                    visible: Battery.available

                    Row {
                        spacing: Theme.spacingMd
                        PixelIcon {
                            anchors.verticalCenter: parent.verticalCenter
                            name: root.icon
                            scale: 3
                            color: root.barColor
                        }
                        RText {
                            anchors.verticalCenter: parent.verticalCenter
                            text: Battery.percent + "%"
                            font.pixelSize: 28
                            font.bold: true
                        }
                    }

                    SegmentBar {
                        width: parent.width
                        height: 24
                        value: Battery.percentage / 100
                        fillColor: root.barColor
                    }

                    RText {
                        width: parent.width
                        wrapMode: Text.Wrap
                        text: {
                            if (Battery.fullyCharged)
                                return "Fully charged";
                            if (Battery.charging)
                                return "Charging" + (Battery.timeToFull > 0 ? ", " + Battery.formatTime(Battery.timeToFull) + " until full" : "");
                            if (Battery.pendingCharge)
                                return "Plugged in, not charging";
                            return "On battery" + (Battery.timeToEmpty > 0 ? ", " + Battery.formatTime(Battery.timeToEmpty) + " remaining" : "");
                        }
                    }
                    RText {
                        visible: Battery.healthPercentage > 0
                        text: "Battery health: " + Math.round(Battery.healthPercentage) + "%"
                        opacity: 0.8
                    }

                    Separator {
                        width: parent.width
                    }
                }

                RText {
                    visible: !Battery.available
                    text: "No battery detected"
                }

                RText {
                    text: "Power profile"
                    font.bold: true
                }

                Repeater {
                    model: root.profiles

                    delegate: MenuItem {
                        required property var modelData
                        required property int index
                        highlighted: root.cursor === index
                        width: body.width
                        icon: modelData.icon
                        iconScale: 1.5
                        label: modelData.label
                        detail: PowerProfileService.current === modelData.key ? "active" : ""
                        toggled: PowerProfileService.current === modelData.key
                        onClicked: {
                            root.cursor = index;
                            PowerProfileService.setProfile(modelData.key);
                        }
                    }
                }
            }
        }
    }
}
