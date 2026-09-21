import QtQuick

import qs.widgets
import qs.services

PopupPanel {
    id: root

    component Header: RText {
        font.bold: true
    }

    component Level: Row {
        id: level

        property string iconName
        property real from: 0
        property real to: 1
        property real value: 0
        property real stepSize: 0
        property string valueText
        signal moved(real v)

        width: parent.width
        spacing: Theme.spacingMd

        Item {
            width: Math.max(levelIcon.width, Theme.iconSize)
            height: levelIcon.height
            anchors.verticalCenter: parent.verticalCenter
            PixelIcon {
                id: levelIcon
                anchors.centerIn: parent
                name: level.iconName
                scale: 2
            }
        }
        Slider {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - Math.max(levelIcon.width, Theme.iconSize) - 44 - 2 * parent.spacing
            from: level.from
            to: level.to
            value: level.value
            stepSize: level.stepSize
            onMoved: v => level.moved(v)
        }
        RText {
            width: 44
            height: parent.height
            horizontalAlignment: Text.AlignRight
            text: level.valueText
        }
    }

    onKeyPressed: event => {
        switch (event.key) {
        case Qt.Key_Left:
        case Qt.Key_H:
            Audio.decrement(0.05);
            break;
        case Qt.Key_Right:
        case Qt.Key_L:
            Audio.increment(0.05);
            break;
        case Qt.Key_M:
            Audio.toggleMute();
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
        width: 380
        height: implicitHeight
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
                    name: "volume"
                    scale: 2
                    color: Theme.accentText
                }
                RText {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Volume & Display"
                    color: Theme.accentText
                }
            }
            Button {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                implicitHeight: parent.height - 2 * Theme.px
                padding: Theme.spacingSm
                text: "x"
                onClicked: root.dismiss()
            }
        }

        Column {
            id: body
            x: Theme.spacingMd
            y: titleBar.height + Theme.spacingMd
            width: parent.width - 2 * Theme.spacingMd
            spacing: Theme.spacingMd

            Item {
                width: parent.width
                height: outputHeader.implicitHeight
                Header {
                    id: outputHeader
                    text: "Output"
                }
                Check {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Mute"
                    checked: Audio.muted
                    onToggled: Audio.toggleMute()
                }
            }

            Level {
                iconName: Audio.muted ? "volumeMuted" : (Audio.volume > 0.5 ? "volume" : "volumeLow")
                to: Audio.maxVolume
                value: Audio.volume
                valueText: Audio.volumePercent + "%"
                onMoved: v => Audio.setVolume(v)
            }

            Repeater {
                model: Audio.sinks
                delegate: MenuItem {
                    required property var modelData
                    width: body.width
                    icon: modelData === Audio.sink ? "check" : ""
                    label: Audio.label(modelData)
                    toggled: modelData === Audio.sink
                    onClicked: Audio.setSink(modelData)
                }
            }

            Separator {
                width: parent.width
            }

            Item {
                width: parent.width
                height: inputHeader.implicitHeight
                Header {
                    id: inputHeader
                    text: "Input"
                }
                Check {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Mute"
                    checked: Audio.micMuted
                    onToggled: Audio.toggleMicMute()
                }
            }

            Repeater {
                model: Audio.sources
                delegate: MenuItem {
                    required property var modelData
                    width: body.width
                    icon: modelData === Audio.source ? "check" : ""
                    label: Audio.label(modelData)
                    toggled: modelData === Audio.source
                    onClicked: Audio.setSource(modelData)
                }
            }

            Separator {
                width: parent.width
                visible: Brightness.ready || KeyboardBacklight.maxLevel > 0
            }

            Column {
                width: parent.width
                spacing: Theme.spacingMd
                visible: Brightness.ready

                Header {
                    text: "Display brightness"
                }
                Level {
                    iconName: "sun"
                    from: 1
                    to: 100
                    value: Brightness.percentage
                    valueText: Brightness.percentage + "%"
                    onMoved: v => Brightness.setPercentage(v)
                }
            }

            Column {
                width: parent.width
                spacing: Theme.spacingMd
                visible: KeyboardBacklight.maxLevel > 0

                Header {
                    text: "Keyboard backlight"
                }
                Level {
                    iconName: "keyboard"
                    to: KeyboardBacklight.maxLevel
                    stepSize: 1
                    value: KeyboardBacklight.level
                    valueText: KeyboardBacklight.levelNames[KeyboardBacklight.level] ?? ""
                    onMoved: v => KeyboardBacklight.setLevel(v)
                }
            }
        }
    }
}
