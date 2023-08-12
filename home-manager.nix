{config, lib, pkgs, ...}: let
	home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
        
        flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
	hyprland = (import flake-compat {
	  src = builtins.fetchTarball "https://github.com/hyprwm/Hyprland/archive/master.tar.gz";
 	 }).defaultNix;
in {
  imports = [
    (import "${home-manager}/nixos")
    hyprland.homeManagerModules.default
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
  wayland.windowManager.hyprland = {
    enable = true;
     extraConfig = ''
      bind = SUPER, Q, exec, kitty
    '';
    xwayland.hidpi = true;
};
    home.stateVersion = "23.11";
    programs.home-manager.enable = true;
  };


}
