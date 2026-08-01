{ pkgs, ... }:

{
  home.packages = with pkgs; [
    awww
    claude-code
    deno
    gh
    hypridle
    hyprlock
    mongosh
    prismlauncher
    rustup
    swaynotificationcenter
    swayosd
    waybar
    wlogout
    wireshark

    qt6.qtbase
    qt6.qtsvg
    qt6.qttools
    qt6.qtwayland
    qt6.qtdeclarative
    qt6.qtimageformats
    kdePackages.qtmultimedia
    kdePackages.qtshadertools
    kdePackages.syntax-highlighting

    (callPackage ../../packages/cider/cider.nix { })
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
