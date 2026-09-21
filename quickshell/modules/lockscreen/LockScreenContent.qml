import QtQuick
import Quickshell
import Quickshell.Services.Pam

import qs.widgets
import qs.services
import qs.modules.bar.start

Rectangle {
    id: root

    required property bool lockSecure

    color: Theme.desktop

    property string message: ""
    property bool failed: false
    property int attempts: 0

    function submit() {
        if (pam.active || password.text.length === 0)
            return;
        root.failed = false;
        root.message = "";
        pam.start();
    }

    function clear() {
        password.text = "";
        root.failed = false;
        root.message = "";
    }

    function grabFocus() {
        password.forceActiveFocus();
        pop.play();
    }
    onLockSecureChanged: if (root.lockSecure)
        root.grabFocus()
    Component.onCompleted: if (root.lockSecure)
        root.grabFocus()

    Keys.onEscapePressed: root.clear()

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    RText {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: Theme.spacingXl
        text: Qt.formatTime(clock.date, "hh:mm") + "  " + Qt.formatDate(clock.date, "dddd d MMMM")
        color: Theme.desktopText
        font.pixelSize: 28
        font.bold: true
    }

    Image {
        anchors.fill: parent
        visible: Session.wallpaper.length > 0
        source: Session.wallpaper.length > 0 ? "file://" + Session.wallpaper : ""
        fillMode: Image.PreserveAspectCrop
        opacity: 0.35
        cache: false
        asynchronous: true
    }

    MediaBox {
        visible: Media.hasActivePlayer
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: Theme.spacingXl
        width: 270
    }

    PopIn {
        id: pop
        anchors.centerIn: parent
        width: dialog.implicitWidth
        height: dialog.implicitHeight
        originX: 0.5
        originY: 0.5
        wireSteps: 4
        wipeSteps: 6
        stepMs: 27

        Dialog {
            id: dialog
            anchors.fill: parent
            title: "Log back in"
            icon: "lock"
            showClose: false
            minWidth: 380

            Column {
                width: 340
                spacing: Theme.spacingLg

                Row {
                    spacing: Theme.spacingLg

                    PixelIcon {
                        anchors.verticalCenter: parent.verticalCenter
                        name: "user"
                        scale: 4
                    }
                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: Theme.spacingXs
                        RText {
                            text: Quickshell.env("USER")
                            font.bold: true
                        }
                    }
                }

                Column {
                    spacing: Theme.spacingXs
                    width: 340

                    RText {
                        text: "Password:"
                    }
                    Field {
                        id: password
                        width: parent.width
                        echoMode: TextInput.Password
                        error: root.failed
                        enabled: !pam.active
                        onAccepted: root.submit()
                    }
                }

                Row {
                    visible: pam.active || root.message.length > 0
                    width: 340
                    spacing: Theme.spacingMd

                    PixelIcon {
                        visible: root.failed
                        anchors.verticalCenter: parent.verticalCenter
                        name: "alert"
                        color: Theme.danger
                    }
                    RText {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - (root.failed ? Theme.iconSize + parent.spacing : 0)
                        text: pam.active ? "Checking…" : root.message
                        color: root.failed ? Theme.danger : Theme.text
                        wrapMode: Text.Wrap
                    }
                }

                Row {
                    x: 340 - width
                    spacing: Theme.spacingMd

                    Button {
                        text: "OK"
                        gloss: true
                        minWidth: 90
                        enabled: !pam.active
                        onClicked: root.submit()
                    }
                    Button {
                        text: "Clear"
                        minWidth: 90
                        onClicked: root.clear()
                    }
                }
            }
        }
    }

    PamContext {
        id: pam
        configDirectory: Qt.resolvedUrl("../../config/pam").toString().replace("file://", "")
        config: "password.conf"

        onPamMessage: {
            if (responseRequired) {
                respond(password.text);
            } else if (messageIsError && message.length > 0) {
                root.message = message;
            }
        }

        onCompleted: result => {
            if (result === PamResult.Success) {
                Session.unlock();
                return;
            }
            root.failed = true;
            root.attempts += 1;
            if (result === PamResult.MaxTries)
                root.message = "Too many failed attempts. Wait a moment, then try again.";
            else if (result === PamResult.Error)
                root.message = "Could not verify the password (authentication error).";
            else
                root.message = "The password is incorrect. Please try again." + (root.attempts > 1 ? " (attempt " + root.attempts + ")" : "");
            password.text = "";
            password.forceActiveFocus();
        }
    }
}
