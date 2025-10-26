# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

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
  services.printing.enable = true;

  # Enable Greeter
  #services.greetd = {
  #  enable = true;
  #  settings = {
  #    default_session = {
  #      command = "{$pkgs.greetd.tuigreet}/bin/tuigreet --cmd niri-session";
  #      user = "greeter";
  #    };
  #  };
  #};

  # Desktop Portal
  xdg.portal.enable = true;

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
 # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tom = {
    shell = pkgs.fish;
    isNormalUser = true;
    home = "/home/tom";
    description = "Tom Passarelli";
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  programs.niri.enable = true;
  programs.firefox.enable = true;

  programs.fish = {
    enable = true;

    shellAliases = {
      ll = "ls -l";
      gs = "git status";
      vi = "nvim";
    };
  };

  programs.git = {
    enable = true;
    config = {
      user.name = "tompassarelli";
      user.email = "tom.passarelli@protonmail.com";
      init.defaultBranch = "main";
      pull.rebase = "true";
    };
  };

  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  nixpkgs.config.allowUnfree = true;
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [

    #region Essentials
    # Framework (comment/remove this section if not using a Framework Computer)
    framework-tool       # swiss army knife
    fwupd                # update drivers/bios

    # Editor
    vim                  # default general purpose text editor
    ripgrep              # search
    fd                   # find files

    # Code
    unstable.zed-editor  # open source editor
    claude-code          # anthropic claude cli
    nodejs               # big scriptin

    # Fonts
    papirus-icon-theme   # nice icon set

    # System Input
    wl-clipboard         # clipboard utilities
    brightnessctl        # control brightness
    evremap              # remap hardware input (ex. caps -> ctrl)

    # Data Transfer & Requests
    wget                 # download things
    curl                 # test APIs, debug HTTP, pipe stuff

    # Version Control
    gh                   # github cli thats faster to work with than raw git

    #endregion Essentials

    #region Desktop Environment

    # terminal
    kitty                # gpu accelerated term with tabs

    # system monitor
    fastfetch            # print your system config in the terminal
    htop                 # power, cpu, etc usage
    mako                 # notifications

    # legacy app support
    xwayland-satellite   # (required as of 2025 for a few apps, like bitwarden)

    # network
    networkmanagerapplet # frontend for networkmanaager

    # app launcher/switcher
    rofi-wayland         # it works, its fast

    # screen lock
    swaylock             # lock screen: Super + Alt + L
    swayidle             # auto-lock after idle

    # screen background
    swaybg               # wallpaper setter

    # screenshots
    grim                 # primary screenshot tool
    slurp                # region selector for screenshots

    # passwords
    bitwarden            # an open source password manager

    # project management
    obsidian             # take notes; requires unfree nix option
    todoist-electron     # todo/calendar; requires unfree nix  option
    protonmail-desktop   # email

    # game dev
    godot_4              # game engine
    blender              # 3D modeling
    gimp                 # image editor

    # social media
    discord              # a garbage piece of software that we tolerate

    # music
    spotify              # play sounds
    youtube-music        # play videos, that make sounds
    #endregion Desktop Environment

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

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}
