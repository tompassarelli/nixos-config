# Edit this configuration file to define what should be installed on your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
  username = "tom"; # set to your username
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./modules/bluetooth.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Define network hostname
  networking.hostName = "whiterabbit";

  # Choose network manager
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # power monitor
  services.upower.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # allow apps to request elevated permission
  security.polkit.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Desktop Portal
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ 
    pkgs.xdg-desktop-portal-gtk  # for GTK apps, Electron apps (Discord, Obsidian, etc.)
    pkgs.xdg-desktop-portal-wlr  # for screen sharing on wlroots compositors
    pkgs.kdePackages.xdg-desktop-portal-kde  # for Qt apps (KDE apps, VLC, Qt Creator, etc.)
  ];
  xdg.portal.config.common.default = [ "wlr" "gtk" ];

  # Fontconfig
  fonts.fontconfig.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    # alsa.enable = true; # can be useful if enncountering issues with older apps/games
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Keyring
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  # Kanata keyboard remapping (replaces evremap)
  boot.kernelModules = [ "uinput" ];  # Load uinput module early
  hardware.uinput.enable = true;     # Required for kanata to access uinput
  
  # Proper udev rules for uinput access
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';
  users.groups.uinput = {};
  
  # Create dedicated kanata user with proper permissions
  users.users.kanata = {
    isSystemUser = true;
    group = "kanata";
    extraGroups = [ "input" "uinput" ];
  };
  users.groups.kanata = {};

  services.kanata = {
    enable = true;
    keyboards.main = {
      devices = [ "/dev/input/event0" ];  # AT Translated Set 2 keyboard
      extraDefCfg = "process-unmapped-keys yes"; # req for tap-hold-press, or need a set of explicit passthrough keys 
      config = ''
        ;; Define aliases
        (defalias
          escctrl (tap-hold-press 200 200 esc lctl)
        )

        ;; Source layer 
        (defsrc caps lalt)

        ;; Base layer
        (deflayer base
          @escctrl lmet
        )
      '';
    };
  };

  # Use dedicated user instead of DynamicUser (better security than root)
  systemd.services.kanata-main.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = "kanata";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    shell = pkgs.fish;
    isNormalUser = true;
    home = "/home/${username}";
    description = "Tom Passarelli";
    extraGroups = [ "wheel" "networkmanager" ]; # Enable 'sudo' for the user.
  };

  # Create user directories on boot
  systemd.tmpfiles.rules = [
    "d /home/${username}/Pictures/Screenshots 0755 ${username} users -"
  ];

  # System-wide theming with Stylix
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
  };

  # Define what programs we want
  programs.niri.enable = true;
  programs.firefox.enable = true;
  programs.fish.enable = true;

  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };


  # Packages
  # You can use https://search.nixos.org/ to find more pkgs (and options).
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    builders-use-substitutes = true;
    extra-substituters = [
      "https://anyrun.cachix.org"
    ];
    extra-trusted-public-keys = [
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    ];
  };
  environment.systemPackages = with pkgs; [

    # Framework (comment/remove this section if not using a Framework Computer)
    framework-tool       # swiss army knife
    fwupd                # update drivers/bios

    # Editor / Search
    vim                  # default general purpose text editor
    ripgrep              # search
    fd                   # find files
    unzip                # relax and decompress

    # Data Transfer & Requests
    wget                 # download things
    curl                 # test APIs, debug HTTP, pipe stuff

    # Convert images
    imagemagick          # work with images
    ghostscript          # for adobe

    # Code
    unstable.zed-editor  # open source editor
    claude-code          # anthropic claude cli
    nodejs               # big scriptin
    python3              # for waybar overview script
    ungoogled-chromium   # fallback
    
    # Rust
    rustc                # rust compiler
    cargo                # rust package manager
    rust-analyzer        # rust language server
    clippy               # rust linter
    rustfmt              # rust formatter
    pkg-config           # helps find system libraries during compilation

    # Icons & Themes
    papirus-icon-theme   # nice icon set
    adwaita-icon-theme   # default GNOME icons (needed for nautilus)
    gnome-themes-extra   # includes Adwaita-dark theme

    # System Input
    wl-clipboard         # clipboard utilities
    brightnessctl        # control brightness

    # Version Control
    gh                   # github cli

    # System Monitor
    fastfetch            # print your system config in the terminal
    btop                 # power, cpu, etc usage

    # Legacy app support
    xwayland-satellite   # (required as of 2025 for a few apps, like bitwarden)

    # Network
    networkmanagerapplet # frontend for networkmanaager
    
    # App Launcher / Command Palette
    rofi-wayland         # it works, its fast
    waybar               # status bar

    # File Manager
    nautilus             # gtk file manager (needed for file dialogs)

    # screen lock
    swaylock             # lock screen: Super + Alt + L
    swayidle             # auto-lock after idle

    # screen background
    swaybg               # wallpaper setter

    # screenshots
    grim                 # primary screenshot tool
    slurp                # region selector for screenshots

    # Personal productivity
    obsidian
    todoist-electron
    protonmail-desktop
    bitwarden

    # Creative tools
    godot_4
    blender
    gimp
    obs-studio          # screen recording/streaming

    # Social/Communication
    discord
    zoom-us

    # Music
    spotify
    youtube-music

    # Media viewers
    imv              # image viewer
    mpv              # video player
    zathura          # PDF viewer

    # User utilities
    tree
    dust             # disk usage analyzer (better than ncdu for overview)
    walker           # modern wayland app launcher
    eza              # modern ls replacement
    procs            # modern ps replacement
    tealdeer         # tldr for quick command examples
    delta            # beautiful git diffs

    # System utilities
    pavucontrol      # audio control GUI

  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # more info: ./documentation/systemStateVersion
  # ALERT: DO NOT EDIT (exceptional cases apply)
  system.stateVersion = "25.05"; # READ THE COMMENT ABOVE
}
