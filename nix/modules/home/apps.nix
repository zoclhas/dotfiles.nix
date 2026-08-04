{ pkgs, inputs, ... }:

let
  soulver-cpp = inputs.soulver-cpp.packages.${pkgs.system}.default;
in
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

  home.packages = [ soulver-cpp ];

  systemd.user.sessionVariables = {
    LD_LIBRARY_PATH = "${soulver-cpp}/lib";
    XDG_DATA_DIRS = "${soulver-cpp}/share:$XDG_DATA_DIRS";
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
      niri = {
        input_path = "~/.config/matugen/templates/niri-colors.kdl";
        output_path = "~/.local/state/niri/generated/colors.kdl";
      };
      kitty = {
        input_path = "~/.config/matugen/templates/kitty-colors.conf";
        output_path = "~/.local/state/kitty/generated/colors.conf";
      };
      ghostty = {
        input_path = "~/.config/matugen/templates/ghostty-colors.conf";
        output_path = "~/.local/state/ghostty/generated/colors.conf";
      };
      kanagawa-mat = {
        input_path = "~/.config/matugen/templates/kanagawa-mat-palette.lua";
        output_path = "~/.local/state/nvim/generated/kanagawa-mat-palette.lua";
      };
    };
  };

  programs.obs-studio = {
    enable = true;

    package = (
      pkgs.obs-studio.override {
        cudaSupport = true;
      }
    );

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi
      obs-gstreamer
      obs-vkcapture
    ];
  };

}
