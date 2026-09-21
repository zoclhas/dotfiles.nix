import QtQuick
import Quickshell

import qs.services

Item {
    id: root

    property string text: ""
    property string icon: ""
    property bool iconStrike: false
    property real iconScale: Theme.px
    property string iconSource: ""
    property bool gloss: false
    property bool flat: false
    property bool toggled: false
    property bool highlighted: false

    property bool cursor: false
    property int padding: Theme.spacingLg
    property real minWidth: 0

    readonly property bool hovered: mouse.containsMouse
    readonly property bool down: mouse.pressed || root.toggled
    readonly property color labelColor: !root.enabled ? Theme.textDisabled : (root.gloss ? Theme.accentText : Theme.text)

    signal clicked
    signal middleClicked
    signal rightClicked
    signal wheel(int delta)

    implicitHeight: Theme.buttonHeight
    readonly property bool hasIcon: root.icon.length > 0 || root.iconSource.length > 0
    readonly property bool hasText: root.text.length > 0
    readonly property real iconPart: root.hasIcon ? Glyphs.cellW * root.iconScale + (root.hasText ? Theme.spacingSm : 0) : 0
    readonly property real naturalWidth: root.iconPart + (root.hasText ? label.implicitWidth : 0)

    implicitWidth: Math.max(root.minWidth, root.naturalWidth + 2 * root.padding + 2 * bevel.insetX)

    Bevel {
        id: bevel
        anchors.fill: parent
        style: root.down ? "inset" : (root.flat && !root.hovered && !root.highlighted ? "flat" : "outset")
        depth: 1
        gloss: root.gloss && !root.flat
        faceColor: root.toggled && root.flat ? Theme.faceLight : Theme.face

        Row {
            id: row
            anchors.centerIn: parent
            anchors.verticalCenterOffset: root.mouse_down_offset
            anchors.horizontalCenterOffset: root.mouse_down_offset
            spacing: Theme.spacingSm

            PixelIcon {
                visible: root.icon.length > 0
                anchors.verticalCenter: parent.verticalCenter
                name: root.icon
                color: root.labelColor
                strike: root.iconStrike
                scale: root.iconScale
            }
            Image {
                visible: root.iconSource.length > 0
                anchors.verticalCenter: parent.verticalCenter
                width: Theme.iconSize
                height: Theme.iconSize
                source: root.iconSource
                sourceSize: Qt.size(Theme.iconSize, Theme.iconSize)
                smooth: false
            }
            RText {
                id: label
                visible: root.hasText
                anchors.verticalCenter: parent.verticalCenter
                text: root.text
                color: root.labelColor
                engraved: !root.enabled
                elide: Text.ElideRight
                width: Math.max(0, Math.min(implicitWidth, root.width - 2 * root.padding - 2 * bevel.insetX - root.iconPart))
            }
        }
    }

    readonly property int mouse_down_offset: mouse.pressed ? Theme.px / 2 : 0

    Rectangle {
        visible: root.cursor
        anchors.fill: parent
        anchors.margins: Theme.px
        color: "transparent"
        border.width: Theme.px
        border.color: Theme.accent
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        onWheel: wheel => root.wheel(wheel.angleDelta.y)
        onClicked: event => {
            if (!root.enabled)
                return;
            if (event.button === Qt.MiddleButton)
                root.middleClicked();
            else if (event.button === Qt.RightButton)
                root.rightClicked();
            else
                root.clicked();
        }
    }
}
