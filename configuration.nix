{ config, pkgs, ... }:
# https://nixos.wiki/wiki/Impermanence
# https://lazamar.co.uk/nix-versions/
let
  impermanence = builtins.fetchTarball "https://github.com/nix-community/impermanence/archive/master.tar.gz";
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
  unstable-08-19-2023 = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/976fa3369d722e76f37c77493d99829540d43845.tar.gz";
  }) {};
  unstable-10-05-2023 = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/893851c2c859d32b3a24177981105e0366bf9151.tar.gz";
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
#      ./sway.nix
#      ./dwm.nix
#      ./plasma.nix
      "${impermanence}/nixos.nix"
      "${home-manager}/nixos"
    ];

  systemd.tmpfiles.rules = [
    "d  /mnt                               0755 root root"
    "d  /home/sidney/.cache                0755 sidney users"
    "L+ /home/sidney/.cache/spotify           - sidney users - /persist/home/.cache/spotify"
    "L+ /home/sidney/.cert                    - sidney users - /persist/home/.cert"
    "d  /home/sidney/.config               0755 sidney users"
    "L+ /home/sidney/.config/nixos            - sidney users - /persist/home/.config/nixos"
    "L+ /home/sidney/.config/htop             - sidney users - /persist/home/.config/htop"
    "L+ /home/sidney/.config/btop             - sidney users - /persist/home/.config/btop"
    "L+ /home/sidney/.config/1Password        - sidney users - /persist/home/.config/1Password"
    "L+ /home/sidney/.config/discord          - sidney users - /persist/home/.config/discord"
    "L+ /home/sidney/.config/GIMP             - sidney users - /persist/home/.config/GIMP"
    "L+ /home/sidney/.config/keepassxc        - sidney users - /persist/home/.config/keepassxc"
    "L+ /home/sidney/.config/keyd             - sidney users - /persist/home/.config/keyd"
    "L+ '/home/sidney/.config/Ledger Live'    - sidney users - /persist/home/.config/Ledger Live"
    "L+ /home/sidney/.config/obs-studio       - sidney users - /persist/home/.config/obs-studio"
    "L+ /home/sidney/.config/openttd          - sidney users - /persist/home/.config/openttd"
    "L+ /home/sidney/.config/solaar           - sidney users - /persist/home/.config/solaar"
    "L+ /home/sidney/.config/spotify          - sidney users - /persist/home/.config/spotify"
    "L+ /home/sidney/.config/transmission     - sidney users - /persist/home/.config/transmission"
    "d  /home/sidney/.local                0755 sidney users"
    "d  /home/sidney/.local/share          0755 sidney users"
    "L+ /home/sidney/.local/share/bottles     - sidney users - /persist/home/.local/share/bottles"
    "L+ /home/sidney/.local/share/openttd     - sidney users - /persist/home/.local/share/openttd"
    "L+ /home/sidney/.local/share/Steam       - sidney users - /persist/home/.local/share/Steam"
    "L+ /home/sidney/.local/share/vulkan      - sidney users - /persist/home/.local/share/vulkan"
    "d  /home/sidney/.local/state          0755 sidney users"
    "L+ /home/sidney/.local/state/wireplumber - sidney users - /persist/home/.local/state/wireplumber"
    "L+ /home/sidney/.gitconfig               - sidney users - /persist/home/.gitconfig"
    "L+ /home/sidney/.steam                   - sidney users - /persist/home/.steam"
    "L+ /home/sidney/.mozilla                 - sidney users - /persist/home/.mozilla"
    "L+ /home/sidney/.pki                     - sidney users - /persist/home/.pki"
    "L+ /home/sidney/.ssh                     - sidney users - /persist/home/.ssh"
    "L+ /home/sidney/.surf                    - sidney users - /persist/home/.surf"
    "L+ /home/sidney/.vim                     - sidney users - /persist/home/.vim"
    "L+ /home/sidney/Desktop                  - sidney users - /persist/home/Desktop"
    "L+ /home/sidney/Documents                - sidney users - /persist/home/Documents"
    "L+ /home/sidney/Downloads                - sidney users - /persist/home/Downloads"
    "L+ /home/sidney/Music                    - sidney users - /persist/home/Music"
    "L+ /home/sidney/Pictures                 - sidney users - /persist/home/Pictures"
    "L+ /home/sidney/Source                   - sidney users - /persist/home/Source"
    "L+ /home/sidney/Videos                   - sidney users - /persist/home/Videos"
    "L+ /home/sidney/.bash_history            - sidney users - /persist/home/.bash_history"
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
        0b05:19b6

        [main]
        capslock = f13
        volumeup = command(/run/current-system/sw/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%)
        volumedown = command(/run/current-system/sw/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%)
        mute = command(/run/current-system/sw/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle)
        micmute = command(/run/current-system/sw/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle)
        brightnessup = command(/run/current-system/sw/bin/brightnessctl set +10%)
        brightnessdown = command(/run/current-system/sw/bin/brightnessctl set 10%-)
        play = command(/run/current-system/sw/bin/playerctl play-pause)
        pause = command(/run/current-system/sw/bin/playerctl play-pause)
        playpause = command(/run/current-system/sw/bin/playerctl play-pause)
        next = command(/run/current-system/sw/bin/playerctl next)
        nextsong = command(/run/current-system/sw/bin/playerctl next)
        prev = command(/run/current-system/sw/bin/playerctl previous)
        previoussong = command(/run/current-system/sw/bin/playerctl previous)
        # Asus Zephyrus Specific
        f21 = command(DISPLAY=:0 XAUTHORITY=/home/sidney/.Xauthority /etc/keyd/touchpadtoggle.sh)
        prog3 = command(/run/current-system/sw/bin/asusctl led-mode -n)
        kbdillumup = command(/run/current-system/sw/bin/asusctl -n)
        kbdillumdown = command(/run/current-system/sw/bin/asusctl -p)
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
      "keyd/touchpadtoggle.sh" = {
        mode = "0755";
        text = ''
          /run/current-system/sw/bin/xinput set-prop "ASUE120A:00 04F3:319B Touchpad" "Device Enabled" $((1-$(/run/current-system/sw/bin/xinput list-props "ASUE120A:00 04F3:319B Touchpad" | /run/current-system/sw/bin/grep "Device Enabled" | /run/current-system/sw/bin/grep -o "[01]$")))
        '';
      };
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
      (vim-full.customize {
        vimrcConfig.packages.myVimPackage = with pkgs.vimPlugins; {
          # loaded on launch
          start = [
            onedark-vim
            vim-commentary
            vim-visual-multi
            SudoEdit-vim
            Recover-vim
            vim-lastplace
            vim-misc
            vim-airline
            vim-css-color
            (pkgs.vimUtils.buildVimPlugin {
              name = "vim-session";
              src = pkgs.fetchFromGitHub {
                owner = "xolox";
                repo = "vim-session";
                rev = "2.13.1";
                sha256 = "a+yRjpShuMMHspa2VtqkUUlNyR96TiiAKuldDKAb02Q=";
              };
            })
            (pkgs.vimUtils.buildVimPlugin {
              name = "vim-textobj-user";
              src = pkgs.fetchFromGitHub {
                owner = "kana";
                repo = "vim-textobj-user";
                rev = "0.7.6";
                sha256 = "bIdIIUS836aCY1mqlUrgJJ/UkFuTjnYUsk9PKfvElpc=";
              };
            })
            (pkgs.vimUtils.buildVimPlugin {
              name = "vim-textobj-line";
              src = pkgs.fetchFromGitHub {
                owner = "kana";
                repo = "vim-textobj-line";
                rev = "0.0.2";
                sha256 = "k6kjmwNqmklVaCigMzBL7xpuMAezqT2G3ZcPtCp791Y=";
              };
            })
            (pkgs.vimUtils.buildVimPlugin {
              name = "vim-textobj-entire";
              src = pkgs.fetchFromGitHub {
                owner = "kana";
                repo = "vim-textobj-entire";
                rev = "0.0.4";
                sha256 = "te7ljHY7lzu+fmbakTkPKxF312+Q0LozTLazxQvSYE8=";
              };
            })
            (pkgs.vimUtils.buildVimPlugin {
              name = "vim-textobj-indent";
              src = pkgs.fetchFromGitHub {
                owner = "kana";
                repo = "vim-textobj-indent";
                rev = "0.0.6";
                sha256 = "oFzUPG+IOkbKZ2gU/kduQ3G/LsLDlEjFhRP0BHBE+1Q=";
              };
            })
          ];
          # manually loadable by calling `:packadd $plugin-name`
          # however, if a Vim plugin has a dependency that is not explicitly listed in
          # opt that dependency will always be added to start to avoid confusion.
#          opt = [ phpCompletion elm-vim ];
          # To automatically load a plugin when opening a filetype, add vimrc lines like:
          # autocmd FileType php :packadd phpCompletion
        };
        vimrcConfig.customRC = ''
          colorscheme onedark
          set nocp
          set number
          set relativenumber
          syntax on
          set autoindent
          set mouse=a
          set wrap!
          set showcmd
          set tabstop=2
          set shiftwidth=2
          set expandtab
          " Remember buffers if opened without a file
          set viminfo+=%,n/persist/home/.viminfo
          set path+=**
          set wildmenu
          set wildignorecase
          set wildmode=list:longest,full
          set splitbelow
          set splitright
          set pastetoggle=<C-x>
          set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
          set backspace=indent,eol,start
          set list
          set ttimeoutlen=50

          nnoremap \ :set wrap!<CR>
          noremap \| :set list!<CR>

          nmap <S-Up> v<Up>
          nmap <S-Down> v<Down>
          nmap <S-Left> v<Left>
          nmap <S-Right> v<Right>
          vmap <S-Up> <Up>
          vmap <S-Down> <Down>
          vmap <S-Left> <Left>
          vmap <S-Right> <Right>
          imap <S-Up> <Esc>v<Up>
          imap <S-Down> <Esc>v<Down>
          imap <S-Left> <Esc>v<Left>
          imap <S-Right> <Esc>v<Right>

          hi Normal guibg=NONE ctermbg=NONE

          set noshowmode
          let g:session_autosave = 'no'
          let g:airline_symbols_ascii = 1
        '';
      })
      keyd
      htop
      btop
      tldr
      trash-cli
      rmtrash
      xfce.mousepad
      bat
      tree
      xclip
      lynx
      surf
      parted
      pavucontrol
      feh
      flameshot
      neofetch
      killall
      pulseaudio
      ranger
      w3m
      p7zip
      rar
      discord
      distrobox
      bottles
      python312
      transmission_4-gtk
      tremc
      mpv
      _1password-gui
      keepassxc
      spotify
      openttd
      gimp-with-plugins
      obs-studio
      bibata-cursors
      bibata-cursors-translucent
      bleeding.xivlauncher
      unstable-10-05-2023.ledger-live-desktop
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
          (fetchpatch {
            url = "https://st.suckless.org/patches/anysize/st-anysize-20220718-baa9357.diff";
            sha256 = "yx9VSwmPACx3EN3CAdQkxeoJKJxQ6ziC9tpBcoWuWHc=";
          })
          (fetchpatch {
            url = "https://st.suckless.org/patches/dynamic-cursor-color/st-dynamic-cursor-color-0.9.diff";
            sha256 = "JugrLvbnacZ6SfVl+V6tLM30LEKWBnRi6WM9oJR9OAA=";
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
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

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
    hashedPasswordFile = "/persist/passwords/sidney";
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "plugdev" ];
    packages = with pkgs; [
      firefox
    ];
  };
  users.users.root = {
#    initialPassword = "1234";
    hashedPasswordFile = "/persist/passwords/root";
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
      extraRules = [
        {
          name = "gamescope";
          nice = -20;
        }
      ];
    };
    udev.extraRules = ''
      # HW.1 / Nano
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1b7c|2b7c|3b7c|4b7c", TAG+="uaccess", TAG+="udev-acl"
      # Blue
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0000|0000|0001|0002|0003|0004|0005|0006|0007|0008|0009|000a|000b|000c|000d|000e|000f|0010|0011|0012|0013|0014|0015|0016|0017|0018|0019|001a|001b|001c|001d|001e|001f", TAG+="uaccess", TAG+="udev-acl"
      # Nano S
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0001|1000|1001|1002|1003|1004|1005|1006|1007|1008|1009|100a|100b|100c|100d|100e|100f|1010|1011|1012|1013|1014|1015|1016|1017|1018|1019|101a|101b|101c|101d|101e|101f", TAG+="uaccess", TAG+="udev-acl"
      # Aramis
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0002|2000|2001|2002|2003|2004|2005|2006|2007|2008|2009|200a|200b|200c|200d|200e|200f|2010|2011|2012|2013|2014|2015|2016|2017|2018|2019|201a|201b|201c|201d|201e|201f", TAG+="uaccess", TAG+="udev-acl"
      # HW2
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0003|3000|3001|3002|3003|3004|3005|3006|3007|3008|3009|300a|300b|300c|300d|300e|300f|3010|3011|3012|3013|3014|3015|3016|3017|3018|3019|301a|301b|301c|301d|301e|301f", TAG+="uaccess", TAG+="udev-acl"
      # Nano X
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0004|4000|4001|4002|4003|4004|4005|4006|4007|4008|4009|400a|400b|400c|400d|400e|400f|4010|4011|4012|4013|4014|4015|4016|4017|4018|4019|401a|401b|401c|401d|401e|401f", TAG+="uaccess", TAG+="udev-acl"
      # Nano SP
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0005|5000|5001|5002|5003|5004|5005|5006|5007|5008|5009|500a|500b|500c|500d|500e|500f|5010|5011|5012|5013|5014|5015|5016|5017|5018|5019|501a|501b|501c|501d|501e|501f", TAG+="uaccess", TAG+="udev-acl"
      # Ledger Stax
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="6011", TAG+="uaccess", TAG+="udev-acl"
    '';
    switcherooControl.enable = true;
    udisks2.enable = true;
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
            PS1="\n\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
          else
            PS1="\n\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\\$\[\033[0m\] "
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
        startsway="dbus-run-session sway >~/swaylog 2>&1";
        pkexec="pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY HOME=$HOME";
        t=''tmux new-session \; split-window -v \; select-pane -t 1 \; split-window -h \; select-pane -t 1 \; attach'';
        rainfall="python3 /home/sidney/build/rainfall/source/rainfall.py";
        # LLM
        initllm="docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama";
        startllm="docker start ollama";
        llm="docker exec -it ollama ollama run";
        stopllm="docker stop ollama";
        # NixOS
        nixconfig="vim ~/.config/nixos/configuration.nix";
        nixnow="nix-shell -p";
        nixnowunstable="nix-shell -I https://github.com/NixOS/nixpkgs/archive/master.tar.gz -p";
        # Enter dev environment for package
        nixdev="nix-shell '<nixpkgs>' -A";
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
        "-W 2560"
        "-H 1600"
        "-f"
        "-o 10"
        "--cursor /persist/home/.config/nixos/extras/bibata-modern-ice-medium.png"
      ];
    };
  };
}

