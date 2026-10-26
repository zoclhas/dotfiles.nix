{ ... }:

{
  imports = [
    ./modules/home/packages.nix
    ./modules/home/apps.nix
    ./modules/home/dotfiles.nix
  ];

  home.username = "zoc";
  home.homeDirectory = "/home/zoc";

  home.stateVersion = "26.05";

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  programs.home-manager.enable = true;
}
