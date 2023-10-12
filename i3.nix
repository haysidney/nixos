{ config, lib, pkgs, ... }:
{

  services.xserver = {
    enable = true;
    excludePackages = [
      pkgs.xterm
    ];
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
    # Configure keymap in X11
    layout = "us";
    xkbVariant = "colemak";
    displayManager.startx.enable = true;
    displayManager.defaultSession = "none+i3";
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
     ];
    };
  };
  security.polkit.enable = true;

  # i3
  programs.dconf.enable = true;
  services.picom = {
    enable = true;
    settings = {
      unredir-if-possible = true;
    };
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
