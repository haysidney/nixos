{ config, lib, pkgs, ... }:
{
  systemd.tmpfiles.rules = [
    "L+ /home/sidney/.Xresources - sidney users - /persist/home/.Xresources"
  ];

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
    displayManager.defaultSession = "i3";
    windowManager.i3 = {
      enable = true;
      configFile = ./extras/i3.conf;
      extraPackages = with pkgs; [
        dmenu
        i3status
        autotiling
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
      backend = "glx";
    };
    vSync = true;
  };

  services.dbus.enable = true;
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  environment = {
    etc = {
      "i3status.conf".source = ./extras/i3status.conf;
      "X11/xinit/xinitrc".text = ''
        #!/bin/sh

        userresources=$HOME/.Xresources
        usermodmap=$HOME/.Xmodmap
        sysresources=/etc/X11/xinit/.Xresources
        sysmodmap=/etc/X11/xinit/.Xmodmap

        # merge in defaults and keymaps

        if [ -f $sysresources ]; then







            xrdb -merge $sysresources

        fi

        if [ -f $sysmodmap ]; then
            xmodmap $sysmodmap
        fi

        if [ -f "$userresources" ]; then







            xrdb -merge "$userresources"

        fi

        if [ -f "$usermodmap" ]; then
            xmodmap "$usermodmap"
        fi

        # start some nice programs

        if [ -d /etc/X11/xinit/xinitrc.d ] ; then
         for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
          [ -x "$f" ] && . "$f"
         done
         unset f
        fi

        #twm &
        #xclock -geometry 50x50-1+1 &
        #xterm -geometry 80x50+494+51 &
        #xterm -geometry 80x20+494-0 &
        #exec xterm -geometry 80x66+0+0 -name login

        xhost local:root &&

        ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
        dbus-run-session i3 -c /etc/i3/config >~/i3log 2>&1
      '';
    };
    sessionVariables = {
      XDG_CURRENT_DESKTOP = "i3";
    };
    systemPackages = with pkgs; [
      polkit_gnome
      xorg.xhost
      feh
    ];
  };
}
