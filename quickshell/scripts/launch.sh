#!/usr/bin/env sh

icon_theme=$(gsettings get org.gnome.desktop.interface icon-theme 2>/dev/null | tr -d "'")
gtk_theme=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null | tr -d "'")

if [ -n "$icon_theme" ]; then
  export QS_ICON_THEME="$icon_theme"
fi
if [ -n "$gtk_theme" ]; then
  export GTK_THEME="$gtk_theme"
fi
export QT_QPA_PLATFORMTHEME="${QT_QPA_PLATFORMTHEME:-gtk3}"

exec quickshell
