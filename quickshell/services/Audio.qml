pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

import qs.services

Singleton {
  id: root

  readonly property real maxVolume: Style.volumeMax / 100

  readonly property PwNode sink: Pipewire.defaultAudioSink
  readonly property PwNode source: Pipewire.defaultAudioSource

  readonly property real volume: sink?.audio?.volume ?? 0
  readonly property bool muted: sink?.audio?.muted ?? false
  readonly property int volumePercent: Math.round(volume * 100)

  readonly property bool micMuted: source?.audio?.muted ?? false

  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
  }

  function setVolume(v) {
    if (!sink?.audio) return;
    sink.audio.volume = Math.max(0, Math.min(root.maxVolume, v));
  }

  function increment(step) {
    root.setVolume(root.volume + (step ?? 0.05));
  }

  function decrement(step) {
    root.setVolume(root.volume - (step ?? 0.05));
  }

  function toggleMute() {
    if (sink?.audio) sink.audio.muted = !sink.audio.muted;
  }

  function toggleMicMute() {
    if (source?.audio) source.audio.muted = !source.audio.muted;
  }

  IpcHandler {
    target: "audio"

    function increment(step: real): void { root.increment(step); }
    function decrement(step: real): void { root.decrement(step); }
    function setVolume(value: real): void { root.setVolume(value); }
    function toggleMute(): void { root.toggleMute(); }
    function toggleMicMute(): void { root.toggleMicMute(); }
  }
}
