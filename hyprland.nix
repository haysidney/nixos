{ config, lib, pkgs, ... }:
{
  systemd.tmpfiles.rules = [
    "L+ /home/sidney/.cache/rofi3.druncache     - sidney users - /persist/home/.cache/rofi3.druncache"
    "L+ /home/sidney/.cache/rofi-3.runcache     - sidney users - /persist/home/.cache/rofi-3.runcache"
    "d  /home/sidney/.config                 0755 sidney users"
    "d  /home/sidney/.config/hypr            0755 sidney users"
    "L+ /home/sidney/.config/hypr/hyprland.conf - sidney users - /persist/home/.config/nixos/extras/hyprland.conf"
  ];

  security.polkit.enable = true;

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
    xdgOpenUsePortal = true;
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
      "hypr/touchpad-toggle.sh" = {
        mode = "0755";
        text = ''
          #!/bin/sh

          HYPRLAND_DEVICE="asue120a:00-04f3:319b-touchpad"

          if [ -z "$XDG_RUNTIME_DIR" ]; then
            export XDG_RUNTIME_DIR=/run/user/$(id -u)
          fi

          export STATUS_FILE="$XDG_RUNTIME_DIR/touchpad.status"

          enable_touchpad() {
            printf "true" > "$STATUS_FILE"
            notify-send -u normal "Enabling Touchpad"
            hyprctl keyword "device:$HYPRLAND_DEVICE:enabled" true
          }

          disable_touchpad() {
            printf "false" > "$STATUS_FILE"
            notify-send -u normal "Disabling Touchpad"
            hyprctl keyword "device:$HYPRLAND_DEVICE:enabled" false
          }

          if ! [ -f "$STATUS_FILE" ]; then
            enable_touchpad
          else
            if [ $(cat "$STATUS_FILE") = "true" ]; then
              disable_touchpad
            elif [ $(cat "$STATUS_FILE") = "false" ]; then
              enable_touchpad
            fi
          fi
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
      wev
      wl-clipboard
      rofi-wayland
      rofimoji
      swww
      grim
      slurp
      swappy
      grimblast
      imv
    ];
  };
}
