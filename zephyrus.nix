{ config, lib, pkgs, modulesPath, ... }:
let

in
{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  systemd.tmpfiles.rules = [
    "L+ /home/sidney/.cache/mesa_shader_cache - sidney users - /persist/home/.cache/mesa_shader_cache"
  ];

  boot.kernelPackages = pkgs.linuxPackages_6_6;
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" "amdgpu" "msr" "v4l2loopback" ];
  boot.extraModulePackages = [ pkgs.linuxKernel.packages.linux_6_6.v4l2loopback ];
  boot.kernelParams = [
    "amd_pstate=active"
  ];

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
    opengl.enable = true;
    opengl.driSupport = true;
    # For 32 bit applications
    opengl.driSupport32Bit = true;
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  environment = {
    sessionVariables = { AMD_VULKAN_ICD = "RADV"; };
    systemPackages = with pkgs; [
      brightnessctl
      linuxKernel.packages.linux_6_6.cpupower
      solaar
    ];
    etc = {
      "asusd/ac_command" = {
        mode = "0744";
        text = ''
          /run/current-system/sw/bin/asusctl profile -P Balanced
          ${pkgs.linuxKernel.packages.linux_6_6.cpupower}/bin/cpupower frequency-set -g powersave
          # When the scaling governor is set to performance we can't edit the epp hint
          /run/current-system/sw/bin/bash -c "echo "power" | /run/current-system/sw/bin/tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference"
        '';
      };
      "asusd/bat_command" = {
        mode = "0744";
        text = ''
          /run/current-system/sw/bin/asusctl profile -P Quiet
          ${pkgs.linuxKernel.packages.linux_6_6.cpupower}/bin/cpupower frequency-set -g powersave
          /run/current-system/sw/bin/bash -c "echo "power" | /run/current-system/sw/bin/tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference"
        '';
      };
    };
  };
  programs = {
    bash.shellAliases = {
      xrandrnative = "xrandr -s 2560x1600 && xrandr --dpi 96";
      xrandr1200 = "xrandr -s 1920x1200 && xrandr --dpi 96";
      xrandr1050 = "xrandr -s 1680x1050 && xrandr --dpi 96";
    };
  };
  services = {
    supergfxd.enable = true;
    asusd = {
      enable = true;
      enableUserService = true;
      asusdConfig = ''
        (
            bat_charge_limit: 80,
            panel_od: false,
            disable_nvidia_powerd_on_battery: false,
            ac_command: "/run/current-system/sw/bin/bash -c /etc/asusd/ac_command",
            bat_command: "/run/current-system/sw/bin/bash -c /etc/asusd/bat_command",
        )
      '';
      auraConfig = ''
        (
            brightness: High,
            current_mode: Static,
            builtins: {
                Static: (
                    mode: Static,
                    zone: None,
                    colour1: (r: 255, g: 255, b: 255),
                    colour2: (r: 0, g: 0, b: 0),
                    speed: Med,
                    direction: Right,
                ),
                Breathe: (
                    mode: Breathe,
                    zone: None,
                    colour1: (r: 255, g: 255, b: 255),
                    colour2: (r: 0, g: 0, b: 0),
                    speed: Med,
                    direction: Right,
                ),
                Rainbow: (
                    mode: Rainbow,
                    zone: None,
                    colour1: (r: 255, g: 255, b: 255),
                    colour2: (r: 0, g: 0, b: 0),
                    speed: Med,
                    direction: Right,
                ),
                Pulse: (
                    mode: Pulse,
                    zone: None,
                    colour1: (r: 255, g: 255, b: 255),
                    colour2: (r: 0, g: 0, b: 0),
                    speed: Med,
                    direction: Right,
                ),
            },
            multizone: None,
            multizone_on: false,
            enabled: AuraDevRog2((
                keyboard: (
                    zone: Keyboard,
                    boot: true,
                    awake: true,
                    sleep: true,
                    shutdown: true,
                ),
                logo: (
                    zone: Logo,
                    boot: true,
                    awake: true,
                    sleep: true,
                    shutdown: true,
                ),
                lightbar: (
                    zone: Lightbar,
                    boot: true,
                    awake: true,
                    sleep: true,
                    shutdown: true,
                ),
                lid: (
                    zone: Lid,
                    boot: true,
                    awake: true,
                    sleep: true,
                    shutdown: true,
                ),
                rear_glow: (
                    zone: RearGlow,
                    boot: true,
                    awake: true,
                    sleep: true,
                    shutdown: true,
                ),
            )),
        )
      '';
    };
  };
}
