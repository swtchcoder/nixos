{ pkgs, ... }: 
let
  customDWM = import ./pkgs/dwm/default.nix { inherit pkgs; };
  customDMenu = import ./pkgs/dmenu/default.nix { inherit pkgs; };
  customST = import ./pkgs/st/default.nix { inherit pkgs; };
  customSlstatus = import ./pkgs/slstatus/default.nix { inherit pkgs; };
in {
  hardware = {
    nvidia = {
      modesetting.enable = true;
      optimus_prime = true;
      package = pkgs.linuxPackages.nvidia_x11;
      cudaSupport = true;
    };

    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        vulkan-loader
        vulkan-tools
        libvulkan
        amdvlk
        nvidia-x11
      ];
    };
  };

  environment = {
    sessionVariables = {
      QT_STYLE_OVERRIDE = "adwaita-dark";
      GTK_THEME = "Adwaita-dark";
    };

    systemPackages = with pkgs; [
      customDWM
      customSlstatus
      customDMenu
      customST
      feh
      xclip
      xrdp
      firefox
    ];
  };

  services = {
    xserver = {
      enable = true;
      
      xkb = {
        layout = "us";
        variant = "";
      }; 

      displayManager.lightdm.enable = true;

      windowManager.session = [{
        name = "dwm";
        start = ''
          ${pkgs.feh}/bin/feh --bg-scale /etc/nixos/assets/wallpaper.png
          ${customSlstatus}/bin/slstatus &
          exec ${customDWM}/bin/dwm
        '';
      }];

      videoDrivers = [ "amdgpu" "nvidia" "intel" ];
    };

    pipewire = {
      enable = true;

      audio.enable = true;
      pulse.enable = true;
      jack.enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };
    };

    xrdp = { # remote desktop - disabled by default
      enable = false;
      defaultWindowManager = "dwm";
      openFirewall = true;
    };

    udev.packages = [ pkgs.mesa ];
  };
}
