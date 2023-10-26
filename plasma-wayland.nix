{ config, lib, pkgs, ... }:
{
  systemd.tmpfiles.rules = [
    "L+ /home/sidney/.config/kcminputrc          - sidney users - /persist/home/.config/kcminputrc"
  ];

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "colemak";

  services.xserver.displayManager.startx.enable = true;
  services.xserver.displayManager.defaultSession = "plasmawayland";

  environment.systemPackages = with pkgs; [
  ];
}
