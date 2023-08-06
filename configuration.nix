# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, lib, pkgs, ... }: let
 
  flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";

  hyprland-flake = (import flake-compat {
   src = builtins.fetchTarball "https://github.com/hyprwm/Hyprland/archive/master.tar.gz";
  }).defaultNix;


in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nvidia.nix
      ./home-manager.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = ["quiet"];

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  nixpkgs.config.allowUnfree = true; 
  
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  # Set your time zone.
   time.timeZone = "Europe/London";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  
  services.xserver.displayManager.gdm = {
	enable = true;
	wayland = true;
  };
  #services.xserver.displayManager.lightdm = {
  #  enable = true;
  #  # extraSeatDefaults = "session-wrapper=";
  #  greeters.slick = {
  #    enable = true;
  #  };
  #};

  # Configure keymap in X11
  services.xserver.layout = "gb";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  # hardware.pulseaudio.enable = true;
  services.pipewire.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ben = {
     isNormalUser = true;
     extraGroups = [ "wheel" "input" ]; # Enable ‘sudo’ for the user.
     description = "Ben Carmichael";
     initialPassword = "password";
     packages = with pkgs; [
     ];
   };


#  environment.etc."lightdm/lightdm.conf".text = lib.mkForce ''
#	[LightDM]
#	greeter-user = lightdm
#	greeters-directory = /nix/store/4w3cqs6mwvj0gs584l9phjxmx2yrqxq1-lightdm-gtk-greeter-xgreeters/
#
#	sessions-directory = /nix/store/m2sz06x9y3qfami9dr6ldmm4d67v9y61-desktops/share/xsessions/:/nix/store/m2sz06x9y3qfami9dr6ldmm4d67v9y61-desktops/share/wayland-sessions/
#
#	[Seat:*]
#	# xserver-command = /nix/store/2bvc180xi4kzbfm4c5dhvwcm3cka905g-xserver-wrapper    
#	# session-wrapper = /nix/store/ivav73slg6i8an1if0ghrd51c6h32bn2-xsession-wrapper
#	greeter-session = lightdm-slick-greeter
#
#  '';
#

  services.flatpak.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
    # flatpak
    # xdg-desktop-portal-hyprland
    # wget
    # git
    # libadwaita
    #  zsh
    # rclone # onedrive syncing
    # ranger # term file manager
    # gh
    # waybar # status bar
    # wofi
    # hyprpaper # wallpaper
    # hyprshot # screenshots
    # dunst # notifs
    # swaylock # lock screen
    # swayidle # lock screen on idle
    # networkmanagerapplet # network in waybar tray
    # blueman # bluetooth in waybar tray
    # # blueman-nautilus
    # brightnessctl
    # font-awesome
    # udiskie # usb drive auto-mount 
    # distrobox
    # # greetd
    # gtkgreet
    #lightdm
    #lightdm-slick-greeter
    # copyq
   ];
  
  programs.hyprland = {
	enable = true;
	package = hyprland-flake.packages.${pkgs.system}.hyprland;
	nvidiaPatches = true;
	xwayland = {
		enable = true;
		hidpi = true;
		};
  };
  
  xdg.portal = {
    enable = true;
    #extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland ];
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  security.pam.services.swaylock = {};

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
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}

