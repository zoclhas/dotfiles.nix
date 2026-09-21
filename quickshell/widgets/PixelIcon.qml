import QtQuick

import qs.services

Item {
    id: root

    property string name: "app"
    property color color: Theme.text
    property bool strike: false
    property color strikeColor: Theme.danger
    property real scale: 2

    implicitWidth: Math.max(Math.round(Glyphs.cellW * root.scale), Math.ceil(glyphText.implicitWidth))
    implicitHeight: Math.round(Glyphs.cellH * root.scale)
    width: implicitWidth
    height: implicitHeight

    readonly property string offGlyph: Glyphs.off[root.name] ?? ""
    readonly property string glyph: root.strike && root.offGlyph.length > 0 ? root.offGlyph : (Glyphs.icons[root.name] ?? Glyphs.icons.app)
    readonly property bool slash: root.strike && root.offGlyph.length === 0

    Text {
        id: glyphText
        anchors.centerIn: parent
        text: root.glyph
        color: root.strike && root.offGlyph.length > 0 ? root.strikeColor : root.color
        font.family: Glyphs.family
        font.pixelSize: Math.round(Glyphs.cellH * root.scale)
        renderType: Text.NativeRendering
    }

    Repeater {
        model: root.slash ? 8 : 0

        Rectangle {
            required property int index
            x: (root.width - 8 * root.scale) / 2 + index * root.scale
            y: (root.height - 8 * root.scale) / 2 + index * root.scale
            width: root.scale
            height: root.scale
            color: root.strikeColor
        }
    }
}
