{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/base.nix
    ../../modules/system/hardware.nix
    ../../modules/system/desktop.nix
    ../../modules/system/programs.nix
    ../../modules/system/packages.nix
  ];

  networking.hostName = "nora";

  stdenv.hostPlatform.system.stateVersion = "26.05";
}
