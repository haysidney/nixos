{ config, lib, pkgs, ... }:
{
  systemd.tmpfiles.rules = [
    "L+ /home/sidney/.cache/rofi3.druncache - sidney users - /persist/home/.cache/rofi3.druncache"
    "L+ /home/sidney/.config/hypr           - sidney users - /persist/home/.config/hypr"
  ];

  security.polkit.enable = true;

  fonts.enableDefaultPackages = true;

  programs = {
    dconf.enable = true;
    hyprland.enable = true;
    waybar.enable = true;
  };

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
#    wlr.settings = {
#      screencast = {
#        output_name = "eDP-2";
#        max_fps = 30;
##        exec_before = "disable_notifications.sh";
##        exec_after = "enable_notifications.sh";
#        chooser_type = "simple";
#        chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
#      };
#    };
    xdgOpenUsePortal = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  environment = {
    etc = {
      "xdg/waybar/config".source = ./extras/waybar.conf;
      "i3/elevated.sh" = {
        mode = "0755";
        text = ''
          pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY HOME=$HOME solaar -w hide
        '';
      };
    };
    sessionVariables = {
      XCURSOR_SIZE = "64";
      XCURSOR_THEME = "Bibata-Modern-Ice";
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
    };
    systemPackages = with pkgs; [
      polkit_gnome
      xwaylandvideobridge
      mako
      libnotify
      wl-clipboard
      rofi
      swww
      slurp
    ];
  };
}
