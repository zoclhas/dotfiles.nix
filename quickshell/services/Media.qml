pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
  id: root

  readonly property var players: Mpris.players.values
  readonly property MprisPlayer activePlayer: {
    const withArt = root.players.find(p => p.isPlaying);
    if (withArt) return withArt;
    return root.players.length > 0 ? root.players[0] : null;
  }

  readonly property bool hasActivePlayer: root.activePlayer !== null && root.activePlayer !== undefined
  readonly property bool isPlaying: root.activePlayer?.isPlaying ?? false
  readonly property string title: root.activePlayer?.trackTitle ?? ""
  readonly property string artist: root.activePlayer?.trackArtist ?? ""
  readonly property string artUrl: root.activePlayer?.trackArtUrl ?? ""
  readonly property real position: root.activePlayer?.position ?? 0
  readonly property real length: root.activePlayer?.length ?? 0

  function togglePlaying() { root.activePlayer?.togglePlaying(); }
  function next() { if (root.activePlayer?.canGoNext) root.activePlayer.next(); }
  function previous() { if (root.activePlayer?.canGoPrevious) root.activePlayer.previous(); }
  function seek(position) { if (root.activePlayer?.canSeek) root.activePlayer.position = position; }
  function toggleShuffle() { if (root.activePlayer?.shuffleSupported) root.activePlayer.shuffle = !root.activePlayer.shuffle; }
  function cycleLoop() {
    if (!root.activePlayer?.loopSupported) return;
    const order = [MprisLoopState.None, MprisLoopState.Track, MprisLoopState.Playlist];
    const idx = order.indexOf(root.activePlayer.loopState);
    root.activePlayer.loopState = order[(idx + 1) % order.length];
  }
}
