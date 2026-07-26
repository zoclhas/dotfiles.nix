{ ... }:

{
  imports = [
    ./modules/home/packages.nix
    ./modules/home/apps.nix
  ];

  home.username = "zoc";
  home.homeDirectory = "/home/zoc";

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
