import QtQuick

import qs.widgets
import qs.services

GroupBox {
    id: root

    title: "Now Playing"
    height: labelH + Theme.spacingSm + col.implicitHeight + Theme.spacingMd

    property int cursorButton: -1

    function fmt(sec) {
        const s = Math.max(0, Math.floor(sec));
        return Math.floor(s / 60) + ":" + String(s % 60).padStart(2, "0");
    }

    Timer {
        interval: 1000
        running: root.visible && Media.isPlaying
        repeat: true
        onTriggered: Media.activePlayer?.positionChanged()
    }

    Column {
        id: col
        width: parent.width
        spacing: Theme.spacingSm

        Row {
            width: parent.width
            spacing: Theme.spacingMd

            Bevel {
                visible: art.status === Image.Ready
                width: 56
                height: 56
                style: "inset"
                depth: 1

                Image {
                    id: art
                    anchors.fill: parent
                    source: Media.artUrl
                    fillMode: Image.PreserveAspectCrop
                    smooth: false
                    asynchronous: true
                    sourceSize: Qt.size(112, 112)
                }
            }

            Column {
                width: parent.width - (art.status === Image.Ready ? 56 + parent.spacing : 0)
                spacing: Theme.spacingXs

                RText {
                    width: parent.width
                    text: Media.title || "Unknown"
                    font.bold: true
                    elide: Text.ElideRight
                }
                RText {
                    width: parent.width
                    text: Media.artist
                    elide: Text.ElideRight
                    opacity: 0.8
                }
                RText {
                    text: root.fmt(Media.position) + " / " + root.fmt(Media.length)
                    opacity: 0.8
                }
            }
        }

        SegmentBar {
            width: parent.width
            height: 16
            value: Media.length > 0 ? Media.position / Media.length : 0
        }

        Row {
            spacing: Theme.spacingXs
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                icon: "prev"
                cursor: root.cursorButton === 0
                padding: Theme.spacingMd
                onClicked: Media.previous()
            }
            Button {
                icon: Media.isPlaying ? "pause" : "play"
                cursor: root.cursorButton === 1
                gloss: true
                padding: Theme.spacingLg
                onClicked: Media.togglePlaying()
            }
            Button {
                icon: "next"
                cursor: root.cursorButton === 2
                padding: Theme.spacingMd
                onClicked: Media.next()
            }
        }
    }
}
