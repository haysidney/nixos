{ config, lib, pkgs, ... }:
{
  imports =
    [
      ./plasma-xorg.nix
    ];
  systemd.tmpfiles.rules = [
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  security.polkit.enable = true;

  # Plasma
  programs.dconf.enable = true; # Fixes gtk themes
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.defaultSession = "plasmawayland";

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    #wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-kde ];
  };

  environment.systemPackages = with pkgs; [
  ];
}
