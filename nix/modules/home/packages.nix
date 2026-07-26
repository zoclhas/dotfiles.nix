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

    (callPackage ../../packages/cider/cider.nix { })
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
