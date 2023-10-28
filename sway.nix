{ config, lib, pkgs, ... }:
{

#  services.xserver = {
#    enable = true;
#    excludePackages = [
#      pkgs.xterm
#    ];
#    # Enable touchpad support (enabled default in most desktopManager).
#    libinput.enable = true;
#    # Configure keymap in X11
#    layout = "us";
#    xkbVariant = "colemak";
#    displayManager.startx.enable = true;
#    displayManager.defaultSession = "i3";
#    windowManager.i3 = {
#      enable = true;
#      configFile = ./extras/i3.conf;
#      extraPackages = with pkgs; [
#        dmenu
#        i3status
#        autotiling
#     ];
#    };
#  };
  security.polkit.enable = true;

  programs = {
    dconf.enable = true;
    sway = {
      enable = true;
      wrapperFeatures = {
        base = true;
        gtk = true;
      };
    };
  };

  services.dbus.enable = true;
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
#    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
#
  # bash script to let dbus know about important env variables and
  # propagate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts  
  # some user services to make sure they have the correct environment variables
#  dbus-sway-environment = pkgs.writeTextFile {
#    name = "dbus-sway-environment";
#    destination = "/bin/dbus-sway-environment";
#    executable = true;
#
#    text = ''
#      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
#      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
#      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
#    '';
#  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
#  configure-gtk = pkgs.writeTextFile {
#    name = "configure-gtk";
#    destination = "/bin/configure-gtk";
#    executable = true;
#    text = let
#      schema = pkgs.gsettings-desktop-schemas;
#      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
#    in ''
#      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
#      gnome_schema=org.gnome.desktop.interface
#      gsettings set $gnome_schema gtk-theme 'Dracula'
#    '';
#  };

  environment = {
    sessionVariables = {
      XDG_CURRENT_DESKTOP = "sway";
      XCURSOR_SIZE = "64";
      XCURSOR_THEME = "Bibata-Modern-Ice";
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
      GDK_SCALE = "1.5";
      QT_FONT_DPI = "120";
    };
    etc = {
      "sway/config".source = ./extras/sway.conf;
      "i3status.conf".source = ./extras/i3status.conf;
    };
    systemPackages = with pkgs; [
      polkit_gnome
#      dbus-sway-environment
#      configure-gtk
      xwaylandvideobridge
      mako
      libnotify
      wl-clipboard
      rofi
      i3status
      autotiling
    ];
  };
}
