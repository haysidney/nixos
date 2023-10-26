{ config, lib, pkgs, ... }:
{
  imports =
    [
      ./plasma-wayland.nix
    ];
  systemd.tmpfiles.rules = [
    "L+ /home/sidney/.config/plasma-org.kde.plasma.desktop-appletsrc - sidney users - /persist/home/.config/plasma-org.kde.plasma.desktop-appletsrc"
    "L+ /home/sidney/.config/plasmashellrc                           - sidney users - /persist/home/.config/plasmashellrc"
    "L+ /home/sidney/.config/kwinrc                                  - sidney users - /persist/home/.config/kwinrc"
    "L+ /home/sidney/.config/kglobalshortcutsrc                      - sidney users - /persist/home/.config/kglobalshortcutsrc"
    "L+ /home/sidney/.config/khotkeysrc                              - sidney users - /persist/home/.config/khotkeysrc"
    "L+ /home/sidney/.config/powermanagementprofilesrc               - sidney users - /persist/home/.config/powermanagementprofilesrc"
    "L+ /home/sidney/.config/powerdevilrc                            - sidney users - /persist/home/.config/powerdevilrc"
    "L+ /home/sidney/.config/kdeglobals                              - sidney users - /persist/home/.config/kdeglobals"
    "L+ /home/sidney/.config/kwinrc                                  - sidney users - /persist/home/.config/kwinrc"
    "L+ /home/sidney/.local/share/aurorae                            - sidney users - /persist/home/.local/share/aurorae"
    "L+ /home/sidney/.local/share/color-schemes                      - sidney users - /persist/home/.local/share/color-schemes"
    "L+ /home/sidney/.local/share/knewstuff3                         - sidney users - /persist/home/.local/share/knewstuff3"
    "L+ /home/sidney/.local/share/kscreen                            - sidney users - /persist/home/.local/share/kscreen"
    "L+ /home/sidney/.local/share/plasma                             - sidney users - /persist/home/.local/share/plasma"
    "L+ /home/sidney/.local/share/wallpapers                         - sidney users - /persist/home/.local/share/wallpapers"
    "L+ /home/sidney/.local/share/krunnerstaterc                     - sidney users - /persist/home/.local/share/krunnerstaterc"
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
