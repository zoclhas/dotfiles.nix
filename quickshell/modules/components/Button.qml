import QtQuick

import qs.services

StyledRect {
  id: root

  signal clicked(var eventPoint)
  signal rightClicked(var eventPoint)

  property bool down: tapHandler.pressed
  property bool hovered: hoverHandler.hovered
  property bool buttonEnabled: true
  property bool focusVisible: false

  property color baseColor: Colors.surfaceVariant
  property color hoverColor: Qt.lighter(baseColor, 1.2)
  property color pressColor: Qt.darker(baseColor, 1.1)

  color: !buttonEnabled ? baseColor : (down ? pressColor : (hovered ? hoverColor : baseColor))
  radius: Style.radius
  opacity: buttonEnabled ? 1 : 0.5

  borderEnabled: activeFocus && focusVisible
  borderColor: Colors.primary
  borderWidth: (activeFocus && focusVisible) ? 2 : Style.borderWidth

  activeFocusOnTab: buttonEnabled

  onActiveFocusChanged: {
    if (activeFocus) root.focusVisible = true;
  }

  scale: down ? 0.94 : 1
  Behavior on scale {
    NumberAnimation { duration: Style.quickDuration; easing.type: Easing.OutCubic }
  }

  HoverHandler {
    id: hoverHandler
    enabled: root.buttonEnabled
    cursorShape: Qt.PointingHandCursor
  }

  TapHandler {
    id: tapHandler
    enabled: root.buttonEnabled
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onTapped: (eventPoint, button) => {
      root.forceActiveFocus();
      root.focusVisible = false;
      if (button === Qt.RightButton) root.rightClicked(eventPoint);
      else root.clicked(eventPoint);
    }
  }

  Keys.onReturnPressed: root.clicked(null)
  Keys.onEnterPressed: root.clicked(null)
  Keys.onSpacePressed: root.clicked(null)
  Keys.onRightPressed: event => {
    const next = root.nextItemInFocusChain(true);
    if (next) { next.forceActiveFocus(); event.accepted = true; }
  }
  Keys.onLeftPressed: event => {
    const prev = root.nextItemInFocusChain(false);
    if (prev) { prev.forceActiveFocus(); event.accepted = true; }
  }
  Keys.onDownPressed: event => {
    const next = root.nextItemInFocusChain(true);
    if (next) { next.forceActiveFocus(); event.accepted = true; }
  }
  Keys.onUpPressed: event => {
    const prev = root.nextItemInFocusChain(false);
    if (prev) { prev.forceActiveFocus(); event.accepted = true; }
  }
}
