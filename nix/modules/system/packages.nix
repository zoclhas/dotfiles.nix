{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    appimage-run
    bat
    bc
    blueman
    bluez
    brightnessctl
    btop
    cloc
    docker
    egl-wayland
    eza
    fastfetch
    fd
    gcc
    git
    gnome-extension-manager
    gnome-tweaks
    gnumake
    grim
    hunspell
    hunspellDicts.en_GB-ise
    imagemagick
    killall
    kitty
    lazygit
    libnotify
    libreoffice-qt
    lm_sensors
    mpv
    file-roller
    nemo-with-extensions
    neovim
    networkmanager
    networkmanager-openvpn
    networkmanagerapplet
    ngrok
    nodejs
    nvtopPackages.msm
    nwg-look
    pavucontrol
    pkg-config
    pv
    (python3.withPackages (python-pkgs: [
      python-pkgs.pandas
      python-pkgs.requests
      python-pkgs.numpy
    ]))
    ripgrep
    sassc
    shfmt
    tmux
    unrar
    unzip
    uv
    vim
    wget
    wl-clipboard
    cliphist
    wl-mirror
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-wlr
    ydotool
    zed-editor
  ];
}
