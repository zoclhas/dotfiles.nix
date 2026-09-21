import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.widgets
import qs.services

Item {
    id: root

    required property var menu
    property bool isSub: false
    property var openEntry: null

    signal back
    signal finished

    readonly property Item shown: root.openEntry !== null && sub.item ? sub.item : list
    implicitWidth: root.shown.implicitWidth
    implicitHeight: root.shown.implicitHeight

    QsMenuOpener {
        id: opener
        menu: root.menu
    }

    ColumnLayout {
        id: list
        visible: root.openEntry === null
        width: root.width
        spacing: 0

        TrayMenuEntry {
            visible: root.isSub
            Layout.fillWidth: true
            text: "Back"
            back: true
            onActivated: root.back()
        }
        Separator {
            visible: root.isSub
            Layout.fillWidth: true
        }

        Repeater {
            model: opener.children

            delegate: Loader {
                id: row
                required property var modelData
                Layout.fillWidth: true
                sourceComponent: modelData.isSeparator ? sep : entry

                Component {
                    id: sep
                    Separator {}
                }
                Component {
                    id: entry
                    TrayMenuEntry {
                        text: row.modelData.text
                        iconName: row.modelData.icon
                        enabled: row.modelData.enabled
                        submenu: row.modelData.hasChildren
                        checkable: row.modelData.buttonType !== QsMenuButtonType.None
                        checked: row.modelData.checkState === Qt.Checked
                        onActivated: {
                            if (row.modelData.hasChildren) {
                                root.openEntry = row.modelData;
                            } else {
                                row.modelData.triggered();
                                root.finished();
                            }
                        }
                    }
                }
            }
        }
    }

    Loader {
        id: sub
        visible: root.openEntry !== null
        width: root.width
    }

    Connections {
        target: sub.item
        ignoreUnknownSignals: true
        function onBack() {
            root.openEntry = null;
        }
        function onFinished() {
            root.finished();
        }
    }

    onOpenEntryChanged: {
        if (root.openEntry !== null)
            sub.setSource("TrayMenuLevel.qml", {
                menu: root.openEntry,
                isSub: true
            });
        else
            sub.source = "";
    }
}
