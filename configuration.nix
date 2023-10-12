{ config, pkgs, ... }:
# https://nixos.wiki/wiki/Impermanence
# https://lazamar.co.uk/nix-versions/
let
  impermanence = builtins.fetchTarball "https://github.com/nix-community/impermanence/archive/master.tar.gz";
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
  unstable-08-19-2023 = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/976fa3369d722e76f37c77493d99829540d43845.tar.gz";
  }) {};
  unstable = unstable-08-19-2023;
  bleeding = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/master.tar.gz";
  }) {};
in
{
  imports =
    [
      ./zephyrus.nix
      ./i3.nix
#      ./plasma.nix
      "${impermanence}/nixos.nix"
      "${home-manager}/nixos"
    ];

  systemd.tmpfiles.rules = [
    "d  /mnt                               0755 root root"
    "d  /home/sidney/.cache                0755 sidney users"
    "L+ /home/sidney/.cache/spotify           - sidney users - /persist/home/.cache/spotify"
    "d  /home/sidney/.config               0755 sidney users"
    "L+ /home/sidney/.config/nixos            - sidney users - /persist/home/.config/nixos"
    "L+ /home/sidney/.config/htop             - sidney users - /persist/home/.config/htop"
    "L+ /home/sidney/.config/1Password        - sidney users - /persist/home/.config/1Password"
    "L+ /home/sidney/.config/discord          - sidney users - /persist/home/.config/discord"
    "L+ /home/sidney/.config/keyd             - sidney users - /persist/home/.config/keyd"
    "L+ /home/sidney/.config/spotify          - sidney users - /persist/home/.config/spotify"
    "L+ /home/sidney/.config/i3               - sidney users - /persist/home/.config/i3"
    "L+ /home/sidney/.config/i3status         - sidney users - /persist/home/.config/i3status"
    "d  /home/sidney/.local                0755 sidney users"
    "d  /home/sidney/.local/share          0755 sidney users"
    "L+ /home/sidney/.local/share/Steam       - sidney users - /persist/home/.local/share/Steam"
    "L+ /home/sidney/.local/share/vulkan      - sidney users - /persist/home/.local/share/vulkan"
    "d  /home/sidney/.local/state          0755 sidney users"
    "L+ /home/sidney/.local/state/wireplumber - sidney users - /persist/home/.local/state/wireplumber"
    "L+ /home/sidney/.gitconfig               - sidney users - /persist/home/.gitconfig"
    "L+ /home/sidney/.steam                   - sidney users - /persist/home/.steam"
    "L+ /home/sidney/.mozilla                 - sidney users - /persist/home/.mozilla"
    "L+ /home/sidney/.pki                     - sidney users - /persist/home/.pki"
    "L+ /home/sidney/.ssh                     - sidney users - /persist/home/.ssh"
    "L+ /home/sidney/Desktop                  - sidney users - /persist/home/Desktop"
    "L+ /home/sidney/Documents                - sidney users - /persist/home/Documents"
    "L+ /home/sidney/Downloads                - sidney users - /persist/home/Downloads"
    "L+ /home/sidney/Music                    - sidney users - /persist/home/Music"
    "L+ /home/sidney/Pictures                 - sidney users - /persist/home/Pictures"
    "L+ /home/sidney/Source                   - sidney users - /persist/home/Source"
    "L+ /home/sidney/Videos                   - sidney users - /persist/home/Videos"
    "L+ /home/sidney/.bash_history            - sidney users - /persist/home/.bash_history"
    "L+ /home/sidney/.vimrc                   - sidney users - /persist/home/.vimrc"
    "L+ /home/sidney/.xinitrc                 - sidney users - /persist/home/.xinitrc"
    "L+ /home/sidney/.Xresources              - sidney users - /persist/home/.Xresources"
  ];
  environment = {
    persistence."/persist/system" = {
      directories = [
        "/etc/nixos"
        "/etc/NetworkManager"
        "/var/log"
        "/var/lib"
      ];
      files = [
        "/etc/machine-id"
      ];
    };
    etc = {
      "keyd/default.conf".text = ''
        [ids]
        *
        -1532:00b4
        -068e:00b5

        [main]
        capslock = f13
        # Explicitly define these so that FFXIV doesn't
        # prevent me from switching workspaces
        [meta]
        1 = M-1
        2 = M-2
        3 = M-3
        4 = M-4

        [altgr]
        # Don't get in the way of r_alt enter
        enter = macro(rightalt+enter)

        j = left
        k = down
        l = right
        i = up
        o = backspace
        u = backspace
        p = delete
        h = home
        ; = end

        2 = <
        4 = >
        3 = |
        w = {
        r = }
        e = '
        s = (
        f = )
        d = "
        x = [
        v = ]
        c = `

        left = previoussong
        right = nextsong
        up = volumeup
        down = volumedown
        rightshift = playpause
      '';
      "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
        bluez_monitor.properties = {
          ["bluez5.enable-sbc-xq"] = true,
          ["bluez5.enable-msbc"] = true,
          ["bluez5.enable-hw-volume"] = true,
          ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
        }
      '';
    };
    systemPackages = with pkgs; [
      vim
      keyd
      htop
      trash-cli
      rmtrash
      xfce.mousepad
      bat
      tree
      neovim
      xclip
      lynx
      parted
      udisks2
      pavucontrol
      feh
      killall
      pulseaudio
      ranger
      w3m
      p7zip
      discord
      distrobox
      transmission
      _1password-gui
      spotify
      bibata-cursors
      bibata-cursors-translucent
      bleeding.xivlauncher
      (unstable-08-19-2023.st.overrideAttrs (oldAttrs: rec {
        patches = [
          ./extras/st-font-size.diff
          ./extras/st-delkey.diff
          (fetchpatch {
            url = "https://st.suckless.org/patches/alpha/st-alpha-20220206-0.8.5.diff";
            sha256 = "01/KBNbBKcFcfbcpMnev/LCzHpON3selAYNo8NUPbF4=";
          })
          (fetchpatch {
            url = "https://st.suckless.org/patches/w3m/st-w3m-0.8.3.diff";
            sha256 = "nVSG8zuRt3oKQCndzm+3ykuRB1NMYyas0Ne3qCG59ok=";
          })
        ];
      }))
    ];
    sessionVariables = {
       EDITOR = "vim";
       NIXPKGS_ALLOW_UNFREE = "1";
       XL_SECRET_PROVIDER = "FILE"; # For XIVLauncher
       NIXOS_CONFIG = "/persist/home/.config/nixos/configuration.nix";
       WWW_HOME = "https://lite.duckduckgo.com/lite";
#      XDG_CURRENT_DESKTOP = "i3";
    };
    interactiveShellInit = "bind -s 'set completion-ignore-case on'";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "America/Indiana/Indianapolis";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "colemak";
  #   useXkbConfig = true; # use xkbOptions in tty.
  };

  users.groups = {
    keyd = {
      members = [ "sidney" ];
    };
  };
  users.users.sidney = {
#    initialPassword = "1234";
    # Hashed password I yoinked from /etc/shadow after setting my desired password
    passwordFile = "/persist/passwords/sidney";
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    packages = with pkgs; [
      firefox
    ];
  };
  users.users.root = {
#    initialPassword = "1234";
    passwordFile = "/persist/passwords/root";
  };

  security = {
    sudo.extraConfig = "Defaults lecture = never";
    # For sound
    rtkit.enable = true;
  };

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    ananicy = {
      enable = true;
      settings = {
        check_freq=10;
        # Verbose msg: true/false
        cgroup_load=true;
        type_load=true;
        rule_load=true;
        apply_nice=true;
        apply_ioclass=true;
        apply_ionice=true;
        apply_sched=true;
        apply_oom_score_adj=true;
        apply_cgroup=true;
        check_disks_schedulers=true;
      };
      extraRules = ''
        {"name": "gamescope", "nice": -20}
      '';
    };
    switcherooControl.enable = true;
  };
  systemd.services = {
    keyd = {
      enable = true;
      description = "keyd key remapping daemon";
      unitConfig = {
        Requires = "local-fs.target";
        After = "local-fs.target";
      };
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.keyd}/bin/keyd";
      };
      wantedBy = [ "default.target" ];
    };
  };
  nixpkgs.config.allowUnfree = true;
  nix.extraOptions = "experimental-features = nix-command flakes";

  virtualisation.docker.enable = true;

  system.copySystemConfiguration = true;
  system.stateVersion = "23.05";

  programs = {
    steam.enable = true;
    git.enable = true;
    bash = {
      promptInit = ''
        # Provide a nice prompt if the terminal supports it.
        if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then
          PROMPT_COLOR="1;31m"
          ((UID)) && PROMPT_COLOR="1;32m"
          if [ -n "$INSIDE_EMACS" ] || [ "$TERM" = "eterm" ] || [ "$TERM" = "eterm-color" ]; then
            # Emacs term mode doesn't support xterm title escape sequence (\e]0;)
            PS1="\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
          else
            PS1="\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\\$\[\033[0m\] "
          fi
          if test "$TERM" = "xterm"; then
            PS1="\[\033]2;\h:\u:\w\007\]$PS1"
          fi
        fi
      '';
      shellAliases = {
        c="clear";
        cdd="cd ~";
        ls="ls --color=auto";
        ll="ls -la";
        grep="grep --color=auto";
        df="df -h";
        vi="vim";
        dd="dd status=progress";
        j="autojump";
        aq="asciiquarium";
        mail="neomutt";
        mb="mbsync -a";
        i3config="vim ~/.config/i3/config";
        swayconfig="vim ~/.config/sway/config";
        t="tmux new-session \; split-window -v \; select-pane -t 1 \; split-window -h \; select-pane -t 1 \; attach";
        rainfall="python3 /home/sidney/build/rainfall/source/rainfall.py";
        # NixOS
        nixconfig="vim ~/.config/nixos/configuration.nix";
        imperm="sudo tree -x /";
        archenter="distrobox enter archlinux-latest";
      };
    };
    tmux = {
      enable = true;
      extraConfig = ''
         # Make escape faster for vim.
         set -sg escape-time 10
         #setw -g mouse on
         # Fix Ranger Crash
         set -g default-terminal "screen-256color"
         # Start windows and panes at 1, not 0
         set -g base-index 1
         setw -g pane-base-index 1
         # switch panes using Alt-arrow without prefix
         bind -n M-Left select-pane -L
         bind -n M-Right select-pane -R
         bind -n M-Up select-pane -U
         bind -n M-Down select-pane -D
         # split panes using | and -
         bind \\ split-window -h
         bind ] split-window -v
         bind-key -n C-S-Left previous-window
         #bind-key -n C-S-Right next-window
         bind -n C-S-Right  run-shell 'current_window=$(tmux display-message -p '#I'); next_window=$(($current_window + 1)); tmux select-window -t :$next_window; if [ "$?" -ne "0" ]; then tmux new-window -t :$next_window; fi'
      '';
    };
    gamescope = {
      enable = true;
      args = [
        "--rt"
        "--immediate-flips"
        "-W 2560"
        "-H 1600"
        "-f"
        "-o 10"
      ];
    };
  };
}

