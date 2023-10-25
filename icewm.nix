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
    displayManager.defaultSession = "icewm";
    windowManager.icewm.enable = true;
  };
  security.polkit.enable = true;

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
#  xdg.portal = {
#    enable = true;
#    #wlr.enable = true;
#    xdgOpenUsePortal = true;
#    # gtk portal needed to make gtk apps happy
#    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
#  };

  environment = {
    etc = {
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
        dbus-run-session icewm-session >~/icewmlog 2>&1
      '';
      "icewm/elevated.sh" = {
        mode = "0755";
        text = ''
          pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY HOME=$HOME solaar -w hide
        '';
      };
    };
    systemPackages = with pkgs; [
      polkit_gnome
      xorg.xhost
    ];
  };
}
