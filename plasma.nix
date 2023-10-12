{ config, lib, pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "colemak";

  ### Desktop Specific

  services.xserver.displayManager.startx.enable = true;
  services.xserver.displayManager.defaultSession = "plasma";
  security.polkit.enable = true;

  # Plasma
  programs.dconf.enable = true; # Fixes gtk themes
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

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
