{ pkgs, ... }:

{
  dconf = {
    enable = true;
    settings = {
      "org/cinnamon/desktop/applications/terminal" = {
        exec = "kitty";
      };

      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          blur-my-shell.extensionUuid
          gsconnect.extensionUuid
          user-themes.extensionUuid
        ];
      };

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  services.flameshot = {
    enable = true;
    settings = {
      General = {
        showStartupLaunchMessage = false;
        showDesktopNotification = true;
        showAbortNotification = false;
      };
    };
  };

  programs.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
    };
  };

  programs.matugen = {
    enable = true;
    variant = "dark";
    jsonFormat = "hex";
    templates = {
      quickshell = {
        input_path = "~/.config/matugen/templates/quickshell-colors.json";
        output_path = "~/.local/state/quickshell/generated/colors.json";
      };
    };
  };
}
