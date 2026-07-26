{ pkgs, ... }:

{
  services.xserver.enable = true;
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  programs.xwayland.enable = true;
  programs.niri.enable = true;

  # niri has no built-in xwayland; spawn this from niri config to run X11 apps
  environment.systemPackages = [ pkgs.xwayland-satellite ];

  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.lilex
    nerd-fonts.jetbrains-mono
    cm_unicode
    material-symbols
  ];
}
