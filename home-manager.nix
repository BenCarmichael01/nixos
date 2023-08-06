{config, lib, pkgs, ...}: let
	home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in {
  imports = [
    (import "${home-manager}/nixos")
  ];
 # nixpkgs.config.allowUnfree = true;
  home-manager.users.ben = {pkgs, ...}: {
    home.packages = with pkgs; [
      xdg-desktop-portal-hyprland
      # flatpak
      firefox
      neovim
      kitty
      zsh
      rclone # onedrive syncing
      ranger # term file manager
      gh
      waybar # status bar
      wofi
      hyprpaper
      dunst # notifs
      swaylock # lock screen
      swayidle # lock screen on idle
      networkmanagerapplet # network in waybar tray
      brightnessctl
      font-awesome
      udiskie # usb drive auto-mount 
      distrobox
      copyq
      wget
      git
      libadwaita
    ];

    home.stateVersion = "23.11";
    programs.home-manager.enable = true;
  };


}
