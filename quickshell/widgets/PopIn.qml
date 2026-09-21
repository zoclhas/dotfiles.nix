import QtQuick

import qs.services

Item {
    id: root

    default property alias data: holder.data
    readonly property alias contentItem: holder

    property real originX: 0.5
    property real originY: 1
    property int wireSteps: 3
    property int wipeSteps: 4
    property int stepMs: 40

    property bool open: true
    readonly property bool animating: anim.running
    readonly property bool hidden: !root.open && !anim.running

    readonly property int total: root.wireSteps + root.wipeSteps
    property real stage: root.open ? root.total : 0
    readonly property int step: Math.floor(root.stage)
    readonly property bool done: root.step >= root.total
    readonly property bool wiring: root.step < root.wireSteps

    function _run(to) {
        anim.stop();
        if (Theme.powerSaving || root.stepMs <= 0) {
            root.stage = to;
            return;
        }
        anim.from = root.stage;
        anim.to = to;
        anim.duration = Math.abs(to - root.stage) * root.stepMs;
        anim.start();
    }

    function play() {
        root.stage = 0;
        root._run(root.total);
    }

    onOpenChanged: {
        if (root.open)
            root.play();
        else
            root._run(0);
    }

    NumberAnimation {
        id: anim
        target: root
        property: "stage"
        easing.type: Easing.Linear
    }

    Item {
        id: wire

        readonly property real f: (root.step + 1) / (root.wireSteps + 1)

        visible: root.wiring && !root.hidden && root.width > 0
        width: Theme.snap(root.width * wire.f)
        height: Theme.snap(root.height * wire.f)
        x: Theme.snap((root.width - width) * root.originX)
        y: Theme.snap((root.height - height) * root.originY)

        Rectangle { width: parent.width; height: Theme.px; color: Theme.text }
        Rectangle { y: parent.height - Theme.px; width: parent.width; height: Theme.px; color: Theme.text }
        Rectangle { width: Theme.px; height: parent.height; color: Theme.text }
        Rectangle { x: parent.width - Theme.px; width: Theme.px; height: parent.height; color: Theme.text }
    }

    Item {
        id: clipBox

        readonly property real frac: root.done ? 1 : (root.wiring ? 0 : (root.step - root.wireSteps + 1) / root.wipeSteps)

        visible: !root.hidden
        clip: !root.done
        width: root.width
        height: Theme.snap(root.height * clipBox.frac)
        y: (root.height - height) * root.originY

        Item {
            id: holder
            y: -clipBox.y
            width: root.width
            height: root.height
        }
    }
}
