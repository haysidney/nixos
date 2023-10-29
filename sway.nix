{ config, lib, pkgs, ... }:
{
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
    bash.shellAliases = {
      startsway="dbus-run-session sway >~/swaylog 2>&1";
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

  environment = {
    sessionVariables = {
      XDG_CURRENT_DESKTOP = "sway";
      XDG_CURRENT_SESSION = "sway";
      XCURSOR_SIZE = "48";
      XCURSOR_THEME = "Bibata-Modern-Ice";
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland-egl";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    };
    etc = {
      "sway/config".source = ./extras/sway.conf;
      "sway/polkit.sh" = {
        mode = "0755";
        text = ''
          ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
        '';
      };
      "i3status.conf".source = ./extras/i3status.conf;
    };
    systemPackages = with pkgs; [
      polkit_gnome
      xwaylandvideobridge
      wlprop
      mako
      libnotify
      wl-clipboard
      rofi-wayland
      i3status
      autotiling
    ];
  };
}
