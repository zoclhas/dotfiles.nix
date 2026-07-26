{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Apps
    gh
    prismlauncher
    deno
    rustup

    # Rice
    awww
    waybar
    swaynotificationcenter
    wlogout
    hyprlock
    hypridle
    swayosd

    claude-code

    (callPackage ../../packages/cider/cider.nix { })
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
