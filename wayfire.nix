{ config, lib, pkgs, ... }:
{
  systemd.tmpfiles.rules = [
    "L+ /home/sidney/.config/wayfire.ini - sidney users - /persist/home/.config/wayfire.ini"
  ];

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
#  };
  security.polkit.enable = true;

  fonts.enableDefaultPackages = true;

  programs = {
    dconf.enable = true;
    wayfire = {
      enable = true;
      plugins = with pkgs.wayfirePlugins; [
        wf-shell
        wcm
        wayfire-plugins-extra
      ];
    };
  };

  nixpkgs = {
    overlays = [
      (final: prev: {
        wayfire = prev.wayfire.overrideAttrs (old: {
          src = prev.fetchFromGitHub {
            owner = "WayfireWM";
            repo = "wayfire";
            rev = "v0.8.0";
            sha256 = "YI8N1rY71b2ulv7tAdah7sibG4qq3kY0/hyS0cls5to=";
            fetchSubmodules = true;
          };
          patches = [ ./extras/wayfire-invertedscrolling.diff ];
        });
      })
    ];
  };

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  environment = {
    etc = {
      "i3/elevated.sh" = {
        mode = "0755";
        text = ''
          pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY HOME=$HOME solaar -w hide
        '';
      };
    };
    systemPackages = with pkgs; [
      polkit_gnome
      wdisplays
    ];
  };
}
