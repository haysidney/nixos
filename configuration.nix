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
      "${impermanence}/nixos.nix"
      "${home-manager}/nixos"
    ];

  environment.persistence."/nix/persist/system" = {
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
  fileSystems."/nix".neededForBoot = true;
  systemd.tmpfiles.rules = [ "d /mnt 0755 root root" ];

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

   # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  environment.etc = {
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
        ["bluez5.enable-sbc-xq"] = true,
        ["bluez5.enable-msbc"] = true,
        ["bluez5.enable-hw-volume"] = true,
        ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
    '';
  };
  hardware.bluetooth.enable = true;

  users.users.sidney = {
#    initialPassword = "1234";
    # Hashed password I yoinked from /etc/shadow after setting my desired password
    passwordFile = "/nix/persist/passwords/sidney";
    isNormalUser = true;
    extraGroups = [ "wheel" "keyd" "docker" ];
    packages = with pkgs; [
      firefox
    ];
  };
  users.users.root = {
#    initialPassword = "1234";
    passwordFile = "/nix/persist/passwords/root";
  };

#  services.flatpak.enable = true;
  nixpkgs.config.allowUnfree = true;
  nix.extraOptions = "experimental-features = nix-command flakes";
  environment.systemPackages = with pkgs; [
    keyd
    htop
    trash-cli
    rmtrash
    xfce.mousepad
    bat
    tree
    vim
    neovim
    xclip
    lynx
    tmux
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
    unstable.gamescope
    bleeding.xivlauncher
    (unstable-08-19-2023.st.overrideAttrs (oldAttrs: rec {
      patches = [
        /nix/persist/home/.config/nixos/extras/st-font-size.diff
        /nix/persist/home/.config/nixos/extras/st-delkey.diff
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

  environment.sessionVariables = {
     EDITOR = "vim";
     NIXPKGS_ALLOW_UNFREE = "1";
     XL_SECRET_PROVIDER = "FILE"; # For XIVLauncher
     NIXOS_CONFIG = "/nix/persist/home/.config/nixos/configuration.nix";
#    XDG_CURRENT_DESKTOP = "i3";
  };

  services.keyd = {
    enable = true;
    ids = [
      "*"
      "-1532:00b4"
      "-068e:00b5"
    ];
    settings = {
      main = {
        capslock = "f13";
      };
      meta = {
        "1" = "M-1";
        "2" = "M-2";
        "3" = "M-3";
        "4" = "M-4";
      };
      altgr = {
        enter = "macro(rightalt+enter)";
        j = "left";
        k = "down";
        l = "right";
        i = "up";
        o = "backspace";
        u = "backspace";
        p = "delete";
        h = "home";
        ";" = "end";

        "2" = "<";
        "4" = ">";
        "3" = "|";
        w = "{";
        r = "}";
        e = "'";
        s = "(";
        f = ")";
        d = "\"";
        x = "[";
        v = "]";
        c = "`";

        left = "previoussong";
        right = "nextsong";
        up = "volumeup";
        down = "volumedown";
        rightshift = "playpause";
      };
    };
  };

  virtualisation.docker.enable = true;

#  services = {
#    syncthing = {
#      enable = true;
#      user = "sidney";
#      systemService = false;
#      configDir = "/home/sidney/.config/syncthing";
#      overrideDevices = true;      # overrides any devices added or deleted through the WebUI
#      overrideFolders = true;      # overrides any folders added or deleted through the WebUI
#      devices = {
#        "bolir" = { id = "GHROYUS-VNHV4KO-EFIKLD4-BWWBALY-QENGLTT-VYPNPJV-3S6W4VP-PXIUZQD"; };
#      };
#      folders = {
#        "NixOS Persist" = {        # Name of folder in Syncthing, also the folder ID
#          path = "/nix/persist";   # Which folder to add to Syncthing
#          devices = [ "bolir" ];   # Which devices to share the folder with
#        };
#      };
#    };
#  };

  programs.ssh.extraConfig = ''
    Host github
      Hostname github.com
      IdentityFile /home/sidney/.ssh/id_ed25519_github
      PreferredAuthentications publickey
      User git
  '';

  system.copySystemConfiguration = true;
  system.stateVersion = "23.05";

  programs.fuse.userAllowOther = true;
  home-manager.users.sidney = { pkgs, ... }: {
    home.stateVersion = "23.05";
    imports = [ "${impermanence}/home-manager.nix" ];

    programs = {
      home-manager.enable = true;
      git = {
        enable = true;
        userName  = "Sidney Hays";
        userEmail = "tech@sidneyhays.com";
        extraConfig = {
          core = {
          };
        };
      };
    };

    home.persistence."/nix/persist/home" = {
      removePrefixDirectory = false;
      allowOther = true;
      directories = [
        ".mozilla"
        ".pki"
        ".ssh"
        ".config/nixos"
        ".config/htop"
        ".config/1Password"
        ".config/discord"
        ".config/keyd"
        ".config/spotify"
        ".cache/spotify"
        ".config/syncthing"
        ".local/state/wireplumber"
      ];
      files = [
        ".bash_history"
        ".bashrc"
        ".vimrc"
        ".tmux.conf"
        ".xinitrc"
        ".Xresources"
        ".config/i3/config"
        ".config/i3status/config"
        ".config/picom/picom.conf"
      ];
    };

    ### Xorg
#    home.file.".xinitrc".source = ./dotfiles/.xinitrc;
#    home.file.".Xresources".source = ./dotfiles/.Xresources;
    # i3
#    xdg.configFile."i3/config".source = ./dotfiles/.i3;
#    xdg.configFile."i3status/config".source = ./dotfiles/.i3status;
#    xdg.configFile."picom/picom.conf".source = ./dotfiles/.picom;

    ### App Configs
#    home.file.".bashrc".source = ./dotfiles/.bashrc;
#    home.file.".tmux.conf".source = ./dotfiles/.tmux;
#    home.file.".vimrc".source = ./dotfiles/.vimrc;
  };
}

