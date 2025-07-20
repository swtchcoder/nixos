{ pkgs, ... }: 
let
  customDWM = import ./dwm/pkg.nix { inherit pkgs; };
  customDMenu = import ./dmenu/dmenu.nix { inherit pkgs; };
  customST = import ./st/st.nix { inherit pkgs; };
  customSlstatus = import ./slstatus/slstatus.nix { inherit pkgs; };
in { 
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

  networking.hostName = "desktop-0";

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
          ${pkgs.feh}/bin/feh --bg-scale /etc/nixos/wallpaper.png
          ${customSlstatus}/bin/slstatus &
          exec ${customDWM}/bin/dwm
        '';
      }];
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

    xrdp = {
      enable = true;
      defaultWindowManager = "dwm";
      openFirewall = true;
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.meslo-lg
  ];
}
