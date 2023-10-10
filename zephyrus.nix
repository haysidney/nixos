{ config, lib, pkgs, modulesPath, ... }:
let
  ryzen_smu = config.boot.kernelPackages.callPackage ./ryzen_smu.nix {};
in
{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

#  boot.kernelPackages = pkgs.linuxPackages_latest;
#  boot.kernelPackages = pkgs.linuxPackages_6_3;
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ "ryzen_smu" ];
  boot.kernelModules = [ "kvm-amd" "amdgpu" ];
  boot.extraModulePackages = [ ryzen_smu ];

  fileSystems."/" =
    {
      device = "none";
      fsType = "tmpfs";
      options = ["size=8G" "mode=755"];
    };
  fileSystems."/nix" =
    {
      device = "/dev/nvme0n1p2";
      fsType = "btrfs";
      options = [ "subvol=niximperm@" ];
    };
  fileSystems."/home/sidney" =
    {
#      device = "/dev/disk/by-uuid/72b13570-da63-40c8-ad39-6918cdb9f257";
#      fsType = "btrfs";
#      options = [ "subvol=nix@home" ];
      device = "none";
      fsType = "tmpfs";
      options = ["size=16G" "mode=777"];
    };
  fileSystems."/boot" =
    {
      device = "/dev/nvme0n1p1";
      fsType = "vfat";
    };
  fileSystems."/data" =
    {
      device = "/dev/nvme0n1p2";
      fsType = "btrfs";
      options = [ "subvol=@data" ];
    };
  fileSystems."/home/sidney/.xlcore" =
    {
      device = "/data/FFXIV/xlcore";
      fsType = "none";
      options = [ "bind" ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp5s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  environment.systemPackages = with pkgs; [
    asusctl
    blender-hip
    ryzenadj
    brightnessctl
  ];
  services.supergfxd.enable = true;
  services.asusd.enable = true;
  services.asusd.enableUserService = true;
  services.auto-cpufreq.enable = true;
#  services.tlp.enable = true;
#  services.tlp.settings = {
#    CPU_DRIVER_OPMODE_ON_AC="passive";
#    CPU_DRIVER_OPMODE_ON_BAT="passive";
#  };
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.opengl.driSupport = true;
  # For 32 bit applications
  hardware.opengl.driSupport32Bit = true;

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}"
  ];



  systemd = {
    services.asus-ryzen-power = {
      enable = true;
      script = ''
        if [ -z "$POW" ]; then
            POW="m"
        fi
        if [[ "$POW" == "m" ]]; then
          /run/current-system/sw/bin/ryzenadj -b 80000
          /run/current-system/sw/bin/ryzenadj -c 70000
          /run/current-system/sw/bin/ryzenadj -f 85
          /run/current-system/sw/bin/asusctl -c 80
        elif [[ "$POW" == "l" ]]; then
          /run/current-system/sw/bin/ryzenadj -b 8000
          /run/current-system/sw/bin/ryzenadj -c 5000
          /run/current-system/sw/bin/ryzenadj -f 85
          /run/current-system/sw/bin/asusctl -c 80
        fi
      '';
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 60;
      };
      wantedBy = [ "default.target" ];
    };
  };
}
