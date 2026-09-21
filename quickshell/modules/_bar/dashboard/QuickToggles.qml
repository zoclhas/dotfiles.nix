import QtQuick
import QtQuick.Layouts

import qs.services
import qs.modules.components

RowLayout {
  id: root

  spacing: Style.spacingXs

  component ToggleTile: Button {
    property bool tileActive: false
    Layout.fillWidth: true
    Layout.preferredHeight: 44
    radius: Style.radius
    baseColor: tileActive ? Colors.primary : Colors.surfaceVariant
    hoverColor: tileActive ? Qt.lighter(Colors.primary, 1.1) : Qt.lighter(Colors.surfaceVariant, 1.2)
    pressColor: tileActive ? Qt.darker(Colors.primary, 1.1) : Qt.darker(Colors.surfaceVariant, 1.1)
    shadowEnabled: false
  }

  ToggleTile {
    id: wifiTile
    tileActive: Network.wifiEnabled
    onClicked: Network.toggleWifi()
    Text {
      anchors.centerIn: parent
      text: Network.wifiEnabled
        ? (Network.wifiSignal > 66 ? Icons.wifiStrength4 : Network.wifiSignal > 33 ? Icons.wifiStrength3 : Icons.wifiStrength2)
        : Icons.wifiOff
      color: wifiTile.tileActive ? Colors.onPrimary : Colors.onBackground
      font.family: Style.fontFamily
      font.pixelSize: Style.fsIcon(5)
    }
  }

  ToggleTile {
    id: bluetoothTile
    tileActive: BluetoothService.enabled
    onClicked: BluetoothService.toggle()
    Text {
      anchors.centerIn: parent
      text: bluetoothTile.tileActive ? Icons.bluetooth : Icons.bluetoothOff
      color: bluetoothTile.tileActive ? Colors.onPrimary : Colors.onBackground
      font.family: Style.fontFamily
      font.pixelSize: Style.fsIcon(5)
    }
  }

  ToggleTile {
    id: volumeTile
    tileActive: !Audio.muted
    onClicked: Audio.toggleMute()
    Text {
      anchors.centerIn: parent
      text: Audio.muted ? Icons.volumeOff : (Audio.volumePercent > 60 ? Icons.volumeHigh : Icons.volumeLow)
      color: volumeTile.tileActive ? Colors.onPrimary : Colors.onBackground
      font.family: Style.fontFamily
      font.pixelSize: Style.fsIcon(5)
    }
  }

  ToggleTile {
    id: micTile
    tileActive: !Audio.micMuted
    onClicked: Audio.toggleMicMute()
    Text {
      anchors.centerIn: parent
      text: Audio.micMuted ? Icons.microphoneOff : Icons.microphone
      color: micTile.tileActive ? Colors.onPrimary : Colors.onBackground
      font.family: Style.fontFamily
      font.pixelSize: Style.fsIcon(5)
    }
  }

  ToggleTile {
    tileActive: true
    onClicked: PowerProfileService.cycle()
    Text {
      anchors.centerIn: parent
      text: PowerProfileService.current === "Performance" ? Icons.rabbit
        : PowerProfileService.current === "PowerSaver" ? Icons.leaf : Icons.gauge
      color: Colors.onPrimary
      font.family: Style.fontFamily
      font.pixelSize: Style.fsIcon(5)
    }
  }
}
