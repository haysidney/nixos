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
  services.xserver.displayManager.defaultSession = "none+i3";
  security.polkit.enable = true;

  # i3
  programs.dconf.enable = true;
  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages = with pkgs; [
      dmenu
      i3status
   ];
  };
  services.picom = {
    enable = true;
    settings = { };
    vSync = true;
  };

  services.dbus.enable = true;
#  xdg.portal = {
#    enable = true;
#    #wlr.enable = true;
#    xdgOpenUsePortal = true;
#    # gtk portal needed to make gtk apps happy
#    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
#  };

  environment.systemPackages = with pkgs; [
  ];
}
