import QtQuick
import Quickshell.Services.Mpris

import qs.widgets
import qs.services

Item {
    id: root

    readonly property int maxChars: 30
    readonly property var player: Media.activePlayer
    readonly property bool active: root.player && root.player.playbackState !== MprisPlaybackState.Stopped && Media.title.length > 0
    readonly property real progress: Media.length > 0 ? Media.position / Media.length : 0

    readonly property string label: Media.artist.length > 0 ? Media.artist + " - " + Media.title : Media.title

    property int offset: 0
    readonly property bool scrolls: root.label.length > root.maxChars
    readonly property string looped: root.label + "   "
    readonly property string shown: {
        if (!root.scrolls)
            return root.label;
        const s = root.looped + root.looped;
        return s.substr(root.offset % root.looped.length, root.maxChars);
    }

    property bool scrolling: false
    function restart() {
        root.offset = 0;
        root.scrolling = root.scrolls;
    }
    onLabelChanged: root.restart()
    onActiveChanged: if (root.active)
        root.restart()

    visible: root.active
    implicitWidth: 2 * Theme.spacingMd + measure.width
    implicitHeight: Theme.buttonHeight

    TextMetrics {
        id: measure
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fs(0)
        text: "M".repeat(root.maxChars)
    }

    Timer {
        interval: 1000
        repeat: true
        running: root.active && Media.isPlaying
        onTriggered: root.player.positionChanged()
    }

    Timer {
        interval: 300
        repeat: true
        running: root.active && root.scrolls && root.scrolling
        onTriggered: {
            root.offset += 1;
            if (root.offset >= root.looped.length) {
                root.offset = 0;
                if (!mouse.containsMouse)
                    root.scrolling = false;
            }
        }
    }

    Bevel {
        id: face
        anchors.fill: parent
        style: "inset"
        depth: 1
        faceColor: Theme.well

        SegmentBar {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.rightMargin: Theme.spacingSm
            anchors.bottom: parent.bottom
            height: Math.round(parent.height * 0.25)
            bevel: false
            value: root.progress
            fillColor: Theme.mix(Theme.well, Theme.accent, 0.4)
        }

        RText {
            anchors.left: parent.left
            anchors.leftMargin: Theme.spacingMd - face.insetX
            anchors.verticalCenter: parent.verticalCenter
            text: root.shown
            color: Theme.text
            opacity: Media.isPlaying ? 1 : 0.6
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        onContainsMouseChanged: {
            if (containsMouse) {
                root.scrolling = root.scrolls;
            } else {
                root.scrolling = false;
                root.offset = 0;
            }
        }
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        onClicked: event => {
            if (event.button === Qt.RightButton)
                Media.next();
            else if (event.button === Qt.MiddleButton)
                Media.previous();
            else
                Media.togglePlaying();
        }
    }
}
