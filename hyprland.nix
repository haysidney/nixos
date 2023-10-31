{ config, lib, pkgs, ... }:
{
  systemd.tmpfiles.rules = [
    "L+ /home/sidney/.cache/rofi3.druncache - sidney users - /persist/home/.cache/rofi3.druncache"
    "L+ /home/sidney/.config/hypr           - sidney users - /persist/home/.config/hypr"
  ];

  security.polkit.enable = true;

  nixpkgs = {
    overlays = [
      (final: prev: {
        waybar = prev.waybar.overrideAttrs (old: {
          src = prev.fetchFromGitHub {
            owner = "Alexays";
            repo = "Waybar";
            rev = "05a2af2d7c57ce320053b73ed86a58449b5332f1";
            sha256 = "KeNmibp1WKS813xx/EJiY2uoBw+tBTnTK/mtm0EQBHQ=";
          };
        });
      })
    ];
  };

  programs = {
    dconf.enable = true;
    hyprland.enable = true;
    waybar.enable = true;
    bash.shellAliases = {
      starth="dbus-run-session Hyprland >~/hyprlog 2>&1";
    };
  };

  services.dbus.enable = true;
  services.flatpak.enable = true;
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
      "xdg/waybar/style.css".source = ./extras/waybar.css;
      "hypr/polkit.sh" = {
        mode = "0755";
        text = ''
          ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
        '';
      };
    };
    sessionVariables = {
      XCURSOR_SIZE = "48";
      XCURSOR_THEME = "Bibata-Modern-Ice";
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland-egl";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    };
    systemPackages = with pkgs; [
      polkit_gnome
      xwaylandvideobridge
      wlprop
      wl-clipboard
      rofi-wayland
      swww
      slurp
      grimblast
    ];
  };
}
