pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

import qs.services

Singleton {
  id: root

  property bool active: false
  property string kind: "volume"
  property real value: 0
  property bool muted: false
  readonly property real maxForKind: kind === "volume" ? Style.volumeMax : 100

  function present(newKind, newValue, newMuted) {
    root.kind = newKind;
    root.value = newValue;
    root.muted = newMuted ?? false;
    root.active = true;
    hideTimer.restart();
  }

  Timer {
    id: hideTimer
    interval: Style.osdHideDelay
    onTriggered: root.active = false
  }

  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
  }

  property real _lastVolume: -1
  property bool _lastMuted: false

  Connections {
    target: Audio.sink?.audio ?? null
    function onVolumeChanged() {
      const pct = Audio.volumePercent;
      if (root._lastVolume !== -1 && pct !== root._lastVolume) root.present("volume", pct, Audio.muted);
      root._lastVolume = pct;
    }
    function onMutedChanged() {
      if (Audio.muted !== root._lastMuted) root.present("volume", Audio.volumePercent, Audio.muted);
      root._lastMuted = Audio.muted;
    }
  }

  property bool _lastMicMuted: false

  Connections {
    target: Audio.source?.audio ?? null
    function onMutedChanged() {
      if (Audio.micMuted !== root._lastMicMuted) root.present("mic", 0, Audio.micMuted);
      root._lastMicMuted = Audio.micMuted;
    }
  }

  property int _lastBrightness: -1

  Connections {
    target: Brightness
    function onPercentageChanged() {
      if (!Brightness.ready) return;
      if (root._lastBrightness !== -1 && Brightness.percentage !== root._lastBrightness) {
        root.present("brightness", Brightness.percentage, false);
      }
      root._lastBrightness = Brightness.percentage;
    }
  }

  property int _lastKbdBacklight: -1

  Connections {
    target: KeyboardBacklight
    function onLevelChanged() {
      if (!KeyboardBacklight.ready) return;
      if (root._lastKbdBacklight !== -1 && KeyboardBacklight.level !== root._lastKbdBacklight) {
        root.present("kbdBacklight", KeyboardBacklight.percentage, KeyboardBacklight.level === 0);
      }
      root._lastKbdBacklight = KeyboardBacklight.level;
    }
  }

  IpcHandler {
    target: "osd"
    function trigger(kind: string, value: real): void { root.present(kind, value); }
    function hide(): void { root.active = false; }
  }
}
