import QtQuick

import qs.services

Item {
    id: root

    property alias text: input.text
    property alias echoMode: input.echoMode
    property string placeholder: ""
    property bool error: false
    readonly property alias input: input

    signal accepted

    implicitHeight: Theme.buttonHeight + Theme.spacingSm
    implicitWidth: 200

    function forceActiveFocus() {
        input.forceActiveFocus();
    }

    Bevel {
        anchors.fill: parent
        style: "inset"
        faceColor: Theme.well
    }

    TextInput {
        id: input
        anchors.fill: parent
        anchors.margins: Theme.spacingMd
        verticalAlignment: TextInput.AlignVCenter
        color: root.error ? Theme.danger : Theme.wellText
        selectionColor: Theme.selection
        selectedTextColor: Theme.selectionText
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fs(0)
        renderType: Text.NativeRendering
        passwordCharacter: "*"
        clip: true
        onAccepted: root.accepted()

        RText {
            anchors.verticalCenter: parent.verticalCenter
            visible: input.text.length === 0 && !input.preeditText
            text: root.placeholder
            color: Theme.wellText
            opacity: 0.5
        }
    }
}
