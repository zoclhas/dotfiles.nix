import QtQuick

import qs.widgets
import qs.services

PopupPanel {
    id: root

    component Header: RText {
        font.bold: true
    }

    component Level: Item {
        id: level

        property string iconName
        property real from: 0
        property real to: 1
        property real value: 0
        property real stepSize: 0
        property string valueText
        property bool highlighted: false
        signal moved(real v)

        width: parent.width
        implicitHeight: levelRow.implicitHeight
        height: implicitHeight

        Rectangle {
            visible: level.highlighted
            anchors.fill: parent
            anchors.margins: -Theme.px
            color: "transparent"
            border.width: Theme.px
            border.color: Theme.accent
        }

        Row {
            id: levelRow
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
    }

    readonly property var rows: {
        const r = ["vol", "mute"];
        Audio.sinks.forEach((_, i) => r.push("sink:" + i));
        r.push("micmute");
        Audio.sources.forEach((_, i) => r.push("source:" + i));
        if (Brightness.ready)
            r.push("bright");
        if (KeyboardBacklight.maxLevel > 0)
            r.push("kbd");
        return r;
    }
    property int cursor: 0
    readonly property string cur: root.rows[Math.min(root.cursor, root.rows.length - 1)] ?? ""

    onOpenChanged: if (open)
        root.cursor = 0

    function adjust(dir) {
        if (root.cur === "bright")
            Brightness.setPercentage(Brightness.percentage + 5 * dir);
        else if (root.cur === "kbd")
            KeyboardBacklight.setLevel(Math.max(0, Math.min(KeyboardBacklight.maxLevel, KeyboardBacklight.level + dir)));
        else
            Audio.setVolume(Audio.volume + 0.05 * dir);
    }

    function activate() {
        const c = root.cur;
        if (c === "vol" || c === "mute")
            Audio.toggleMute();
        else if (c === "micmute")
            Audio.toggleMicMute();
        else if (c === "kbd")
            KeyboardBacklight.next();
        else if (c.startsWith("sink:"))
            Audio.setSink(Audio.sinks[parseInt(c.slice(5))]);
        else if (c.startsWith("source:"))
            Audio.setSource(Audio.sources[parseInt(c.slice(7))]);
    }

    onKeyPressed: event => {
        const n = root.rows.length;
        switch (event.key) {
        case Qt.Key_Up:
        case Qt.Key_K:
        case Qt.Key_Backtab:
            root.cursor = (Math.min(root.cursor, n - 1) + n - 1) % n;
            break;
        case Qt.Key_Down:
        case Qt.Key_J:
        case Qt.Key_Tab:
            root.cursor = (Math.min(root.cursor, n - 1) + 1) % n;
            break;
        case Qt.Key_Left:
        case Qt.Key_H:
            root.adjust(-1);
            break;
        case Qt.Key_Right:
        case Qt.Key_L:
            root.adjust(1);
            break;
        case Qt.Key_Return:
        case Qt.Key_Enter:
        case Qt.Key_Space:
            root.activate();
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
                anchors.rightMargin: Theme.spacingSm
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
                    highlighted: root.cur === "mute"
                    checked: Audio.muted
                    onToggled: Audio.toggleMute()
                }
            }

            Level {
                highlighted: root.cur === "vol"
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
                    required property int index
                    highlighted: root.cur === "sink:" + index
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
                    highlighted: root.cur === "micmute"
                    checked: Audio.micMuted
                    onToggled: Audio.toggleMicMute()
                }
            }

            Repeater {
                model: Audio.sources
                delegate: MenuItem {
                    required property var modelData
                    required property int index
                    highlighted: root.cur === "source:" + index
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
                    highlighted: root.cur === "bright"
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
                    highlighted: root.cur === "kbd"
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
