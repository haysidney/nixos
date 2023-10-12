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
    displayManager.defaultSession = "i3";
    windowManager.i3 = {
      enable = true;
      configFile = ./extras/i3.conf;
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

        exec i3 -c /etc/i3/config
      '';
    };
    systemPackages = with pkgs; [
    ];
  };
}
