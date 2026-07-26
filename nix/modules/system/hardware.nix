{ config, ... }:

{
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true; # steam/proton need this
  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];

  # hybrid amd+nvidia (prime offload)
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings.General = {
    Enable = "Source,Sink,Media,Socket";
    # exposes codec switching + battery reporting, needed for AAC/mSBC negotiation
    Experimental = true;
  };
}
