{ config, lib, pkgs, modulesPath, ... }:
let

in
{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

#  boot.kernelPackages = pkgs.linuxPackages_latest;
#  boot.kernelPackages = pkgs.linuxPackages_6_3;
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" "amdgpu" ];
  boot.extraModulePackages = [ ];

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
      neededForBoot = true;
    };
  fileSystems."/persist" =
    {
      device = "/dev/nvme0n1p2";
      fsType = "btrfs";
      options = [ "subvol=niximperm@persist" ];
      neededForBoot = true;
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
  hardware = {
    bluetooth.enable = true;
    opengl.driSupport = true;
    # For 32 bit applications
    opengl.driSupport32Bit = true;
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  environment = {
    sessionVariables = { AMD_VULKAN_ICD = "RADV"; };
    systemPackages = with pkgs; [
      asusctl
      blender-hip
      brightnessctl
    ];
  };
  services = {
    auto-cpufreq.enable = true;
    xserver.videoDrivers = [ "amdgpu" ];
    supergfxd.enable = true;
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}"
  ];
}
