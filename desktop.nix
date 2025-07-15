{ pkgs, ... }: 
let
  customDWM = import ./dwm/pkg.nix { inherit pkgs; };
  customDMenu = import ./dmenu/dmenu.nix { inherit pkgs; };
  customST = import ./st/st.nix { inherit pkgs; };
in { 
  environment = {
    sessionVariables = {
      QT_STYLE_OVERRIDE = "adwaita-dark";
      GTK_THEME = "Adwaita-dark";
    }; 

    systemPackages = with pkgs; [
      customDWM
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

      displayManager = {
      	lightdm.enable = true;
        sessionCommands = ''
          ${pkgs.feh}/bin/feh --bg-scale /etc/nixos/wallpaper.png
        '';
      };

      windowManager.session = [{
        name = "dwm";
        start = ''
          ${customDWM}/bin/dwm &  
          waitPID=$!
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
    (nerdfonts.override { fonts = [ "Meslo" ]; })
  ];
}
