import QtQuick

import qs.services

Item {
    id: root

    default property alias data: contentItem.data
    readonly property alias contentItem: contentItem

    property string style: "outset"
    property int depth: style === "flat" ? 0 : 2

    property color faceColor: Theme.face
    property bool gloss: false
    property color glossColor: Theme.accent
    property bool gradient: false
    property color faceColorEnd: Theme.accentAlt

    property bool hEdges: true
    property bool vEdges: true

    readonly property int insetX: root.vEdges ? root.depth * Theme.px : 0
    readonly property int insetY: root.hEdges ? root.depth * Theme.px : 0

    function _ring(k) {
        const H = Theme.faceHighlight, L = Theme.faceLight, S = Theme.faceShadow, D = Theme.faceDark;
        const thin = root.depth === 1;
        switch (root.style) {
        case "outset":
            return k === 0 ? [H, thin ? S : D] : [L, S];
        case "inset":
            return k === 0 ? [S, H] : [D, L];
        case "groove":
            return k === 0 ? [S, H] : [H, S];
        case "ridge":
            return k === 0 ? [H, S] : [S, H];
        }
        return [faceColor, faceColor];
    }

    Repeater {
        model: root.depth

        delegate: Item {
            id: ring
            required property int index
            readonly property real dx: root.vEdges ? index * Theme.px : 0
            readonly property real dy: root.hEdges ? index * Theme.px : 0
            readonly property var tones: root._ring(index)

            PixelRect {
                x: ring.dx
                y: ring.dy
                width: root.width - 2 * ring.dx
                height: root.height - 2 * ring.dy
                color: ring.tones[1]
            }

            PixelRect {
                x: ring.dx
                y: ring.dy
                width: root.width - 2 * ring.dx - (root.vEdges ? Theme.px : 0)
                height: root.height - 2 * ring.dy - (root.hEdges ? Theme.px : 0)
                color: ring.tones[0]
            }
        }
    }

    PixelRect {
        id: face
        x: root.insetX
        y: root.insetY
        width: root.width - 2 * root.insetX
        height: root.height - 2 * root.insetY

        readonly property color g: root.glossColor
        color: root.gloss ? Qt.lighter(g, 1.35) : root.faceColor
        colorTopEnd: root.gloss ? Qt.lighter(g, 1.08) : (root.gradient ? root.faceColorEnd : root.faceColor)
        colorBottomStart: root.gloss ? Qt.darker(g, 1.15) : (root.gradient ? root.faceColorEnd : root.faceColor)
        colorBottom: root.gloss ? Qt.lighter(g, 1.15) : (root.gradient ? root.faceColorEnd : root.faceColor)
        split: root.gloss ? 0.5 : 1
        horizontal: root.gradient && !root.gloss
    }

    PixelRect {
        visible: root.gloss
        x: root.insetX + Theme.px
        y: root.insetY + Theme.px
        width: face.width - 2 * Theme.px
        height: Math.max(0, Math.floor(face.height * 0.4 / Theme.px) * Theme.px)
        color: Qt.rgba(1, 1, 1, 0.22)
    }

    Item {
        id: contentItem
        x: root.insetX
        y: root.insetY
        width: root.width - 2 * root.insetX
        height: root.height - 2 * root.insetY
    }
}
