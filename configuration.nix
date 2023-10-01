# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ]:
  
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
   #  "/swap".options = [ "noatime" ];
  };


  nixpkgs.config.allowUnfree = true;
  # Windows time compat
  time.hardwareClockInLocalTime = true;
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    settings.auto-optimise-store = true;
    # free up to 1GiB from store when less that 100MiB left
    extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
  };
  
  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.systemd-boot.configurationLimit = 10;
  # boot.loader.efi.canTouchEfiVariables = true;
  
  boot = {
    loader.grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      theme = pkgs.nixos-grub2-theme;
    };
    kernelParams = ["quiet" "splash"];
    plymouth.enable = true;
  };

  networking.hostName = "benlaptopn"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.


  # Set your time zone.
  time.timeZone = "Europe/London";

  console = {
    font = "iso01-12x22";
    # keyMap = "gb";
    useXkbConfig = true; # use xkbOptions in tty.
   };


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  # hardware.pulseaudio.enable = true;
  services.pipewire.enable = true;

  services.dbus.enable = true;
  services.flatpak.enable = true;

  services.xserver = {
    enable = true;
    layout = "gb";
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
    displayManager.lightdm = {
      enable = true;
      greeters.slick.enable = true;
      greeters.slick.theme.name = "Catppuccin-Mocha-Standard-Blue-Dark";
      greeters.slick.theme.package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        #size = "compact";
        tweaks = [ "rimless" ];
        variant = "mocha";
      };
      greeters.slick.cursorTheme.name = "Phinger Cursors";
      greeters.slick.extraConfig = ''
         enable-hidpi=on
      '';
      extraConfig = ''
         minimum-vt=1
	 #logind-check-graphical=true
      '';
    };
  };

  systemd.services."display-manager".preStart = "sleep 5";
  systemd.user = {
    services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "no";
          RestartSec = 1;
          TimeoutStopSec = 10;
      };
    };
  };


  security = {
    polkit.enable = true;
    pam.services.swaylock = {};
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.ben = {
     isNormalUser = true;
     extraGroups = [ "wheel" "input" "networkmanager" ]; # Enable ‘sudo’ for the user.
     description = "Ben Carmichael";
     initialPassword = "password";
     shell = pkgs.zsh;
     packages = with pkgs; [
     ];
   };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     polkit_gnome
     xorg.xhost # for polkit apps
     at-spi2-core
     neovim 
     wget
     kitty
     rclone
     ranger
     gh
     git
     eza
     acpica-tools
     p7zip
     # Hyprland stuff
     waybar
     wofi
     hyprpaper
     # hyprshot
     swaylock-effects
     swayidle
     networkmanagerapplet
     blueman
     brightnessctl
     font-awesome
     udiskie
     distrobox
     copyq
     nwg-look
     swaynotificationcenter
     gnome.gnome-software
     cinnamon.nemo
     catppuccin-gtk
     phinger-cursors
     gtk3
     qt6.qtwayland # cursors?
     libsForQt5.qt5.qtwayland
     glib # gsettings for nwg-look
     gsettings-desktop-schemas
     less # pager
     firefox
     gparted
     gnome-multi-writer
     ntfs3g
     xsettingsd
   ];

  programs = {
    hyprland.enable = true;
    zsh.enable = true;
};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}

