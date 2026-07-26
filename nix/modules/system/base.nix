{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  # unset: not managed here, set once via `sudo timedatectl set-timezone <zone>`
  time.timeZone = null;

  # en_GB: metric units, no country tied to it in the repo
  i18n.defaultLocale = "en_GB.UTF-8";

  users.users."zoc" = {
    isNormalUser = true;
    description = "zoc";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = [ ];
    shell = pkgs.fish;
  };
}
