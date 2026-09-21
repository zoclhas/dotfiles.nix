{ pkgs, ... }:

{
  home.packages = with pkgs; [
    awww
    claude-code
    deno
    gh
    hypridle
    hyprlock
    jq
    mongosh
    prismlauncher
    rustup
    waybar
    wlogout
    wireshark

    texliveFull

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
