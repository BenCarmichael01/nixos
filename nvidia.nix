{config, lib, pkgs, ...}

{
   hardware.opengl = {
     enable = true;
     driSupport = true;
     driSupport32Bit = true;
   };

   nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
    "nvidia-x11"
    "nvidia-settings"
    ];
  
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };


  }
