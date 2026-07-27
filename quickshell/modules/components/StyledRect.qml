import QtQuick
import QtQuick.Effects
import Quickshell.Widgets

import qs.services

Item {
  id: root

  default property alias data: content.data
  property alias children: content.children
  readonly property alias contentItem: content

  property color color: Colors.surface
  property real radius: Style.radius
  property real topLeftRadius: root.radius
  property real topRightRadius: root.radius
  property real bottomLeftRadius: root.radius
  property real bottomRightRadius: root.radius

  property bool borderEnabled: false
  property color borderColor: Style.borderColor
  property real borderWidth: Style.borderWidth

  property bool shadowEnabled: false
  property real shadowBlur: Style.shadowBlur
  property real shadowSpread: Style.shadowSpread
  property color shadowColor: Style.shadowColor
  property real shadowOffsetX: Style.shadowOffsetX
  property real shadowOffsetY: Style.shadowOffsetY

  implicitWidth: content.implicitWidth
  implicitHeight: content.implicitHeight

  Behavior on topLeftRadius { NumberAnimation { duration: Style.quickDuration; easing.type: Easing.OutCubic } }
  Behavior on topRightRadius { NumberAnimation { duration: Style.quickDuration; easing.type: Easing.OutCubic } }
  Behavior on bottomLeftRadius { NumberAnimation { duration: Style.quickDuration; easing.type: Easing.OutCubic } }
  Behavior on bottomRightRadius { NumberAnimation { duration: Style.quickDuration; easing.type: Easing.OutCubic } }
  Behavior on color { ColorAnimation { duration: Style.quickDuration } }

  RectangularShadow {
    visible: root.shadowEnabled && root.width > 0 && root.height > 0
    anchors.fill: content
    radius: Math.max(root.topLeftRadius, root.topRightRadius, root.bottomLeftRadius, root.bottomRightRadius)
    blur: root.shadowBlur
    spread: root.shadowSpread
    color: root.shadowColor
    offset: Qt.vector2d(root.shadowOffsetX, root.shadowOffsetY)
  }

  ClippingRectangle {
    id: content
    anchors.fill: parent
    color: root.color
    topLeftRadius: root.topLeftRadius
    topRightRadius: root.topRightRadius
    bottomLeftRadius: root.bottomLeftRadius
    bottomRightRadius: root.bottomRightRadius
    border.width: root.borderEnabled ? root.borderWidth : 0
    border.color: root.borderColor
  }
}
