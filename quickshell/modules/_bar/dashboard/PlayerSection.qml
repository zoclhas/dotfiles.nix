import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Widgets

import qs.services
import qs.modules.components

StyledRect {
    id: root

    color: Colors.surfaceVariant
    radius: Style.innerRadius(4)
    clip: true

    property real localPosition: Media.position
    readonly property real progress: Media.length > 0 ? root.localPosition / Media.length : 0

    Connections {
        target: Media
        function onPositionChanged() {
            root.localPosition = Media.position;
        }
    }

    Timer {
        interval: 1000
        running: Media.isPlaying
        repeat: true
        onTriggered: root.localPosition = Math.min(root.localPosition + 1, Media.length)
    }

    function formatDuration(seconds) {
        if (!seconds || seconds < 0)
            return "0:00";
        const m = Math.floor(seconds / 60);
        const s = Math.floor(seconds % 60);
        return m + ":" + (s < 10 ? "0" : "") + s;
    }

    Image {
        id: bgArt
        anchors.fill: parent
        source: Media.artUrl
        visible: false
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
    }

    MultiEffect {
        anchors.fill: bgArt
        source: bgArt
        visible: Media.artUrl !== ""
        autoPaddingEnabled: false
        blurEnabled: true
        blur: 1
        blurMax: 48
        saturation: 0.1
        opacity: 0.25
    }

    Rectangle {
        anchors.fill: parent
        // color: Colors.surfaceVariant
        color: 'transparent'
        opacity: Media.artUrl !== "" ? 0.55 : 1
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.spacingMd
        spacing: Style.spacingSm

        Item {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 140
            Layout.preferredHeight: 140

            WavyCircularScrubber {
                anchors.fill: parent
                value: root.progress
                playing: Media.isPlaying
                onSeekRequested: value => Media.seek(value * Media.length)
            }

            ClippingRectangle {
                anchors.centerIn: parent
                width: 90
                height: 90
                radius: width / 2
                color: Colors.surface

                Image {
                    anchors.fill: parent
                    source: Media.artUrl
                    fillMode: Image.PreserveAspectCrop
                    visible: Media.artUrl !== ""
                }

                Text {
                    anchors.centerIn: parent
                    visible: Media.artUrl === ""
                    text: Icons.play
                    color: Colors.primary
                    font.family: Style.fontFamily
                    font.pixelSize: Style.fs(6)
                }
            }
        }

        MarqueeText {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            text: Media.hasActivePlayer ? Media.title : "Nothing Playing"
            maxChars: 28
            bold: true
            fontPixelSize: Style.fs(1)
            fadeColor: Colors.surfaceVariant
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: Media.artist
            visible: Media.artist !== ""
            color: Colors.onBackground
            opacity: 0.7
            font.family: Style.fontFamily
            font.pixelSize: Style.fs(-1)
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: Style.spacingSm

            Button {
                width: 28
                height: 28
                radius: Style.radius
                baseColor: Qt.rgba(0, 0, 0, 0)
                hoverColor: Colors.surface
                onClicked: Media.toggleShuffle()
                Text {
                    anchors.centerIn: parent
                    text: Icons.shuffle
                    color: Media.activePlayer?.shuffle ? Colors.primary : Colors.onBackground
                    font.family: Style.fontFamily
                    font.pixelSize: Style.fsIcon(0)
                }
            }

            Button {
                width: 32
                height: 32
                radius: Style.radius
                baseColor: Qt.rgba(0, 0, 0, 0)
                hoverColor: Colors.surface
                onClicked: Media.previous()
                Text {
                    anchors.centerIn: parent
                    text: Icons.stepBackward
                    color: Colors.onBackground
                    font.family: Style.fontFamily
                    font.pixelSize: Style.fsIcon(1)
                }
            }

            Button {
                width: 42
                height: 42
                radius: Style.radius
                baseColor: Colors.primary
                hoverColor: Qt.lighter(Colors.primary, 1.1)
                pressColor: Qt.darker(Colors.primary, 1.1)
                onClicked: Media.togglePlaying()
                Text {
                    anchors.centerIn: parent
                    text: Media.isPlaying ? Icons.pause : Icons.play
                    color: Colors.onPrimary
                    font.family: Style.fontFamily
                    font.pixelSize: Style.fsIcon(3)
                }
            }

            Button {
                width: 32
                height: 32
                radius: Style.radius
                baseColor: Qt.rgba(0, 0, 0, 0)
                hoverColor: Colors.surface
                onClicked: Media.next()
                Text {
                    anchors.centerIn: parent
                    text: Icons.stepForward
                    color: Colors.onBackground
                    font.family: Style.fontFamily
                    font.pixelSize: Style.fsIcon(1)
                }
            }

            Button {
                width: 28
                height: 28
                radius: Style.radius
                baseColor: Qt.rgba(0, 0, 0, 0)
                hoverColor: Colors.surface
                onClicked: Media.cycleLoop()
                Text {
                    anchors.centerIn: parent
                    text: Icons.repeat
                    color: (Media.activePlayer?.loopState ?? 0) !== 0 ? Colors.primary : Colors.onBackground
                    font.family: Style.fontFamily
                    font.pixelSize: Style.fsIcon(0)
                }
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            visible: Media.hasActivePlayer
            text: root.formatDuration(root.localPosition) + " / " + root.formatDuration(Media.length)
            color: Colors.onBackground
            opacity: 0.6
            font.family: Style.fontFamily
            font.pixelSize: Style.fs(-2)
        }
    }
}
