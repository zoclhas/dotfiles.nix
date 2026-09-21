import QtQuick

import qs.services

Text {
    id: root

    property bool engraved: false
    property int sizeOffset: 0

    color: root.engraved ? Theme.textDisabled : Theme.text
    style: root.engraved ? Text.Raised : Text.Normal
    styleColor: Theme.faceHighlight

    font.family: Theme.fontFamily
    font.pixelSize: Theme.fs(root.sizeOffset)
    font.hintingPreference: Font.PreferFullHinting
    renderType: Text.NativeRendering
    verticalAlignment: Text.AlignVCenter
}
