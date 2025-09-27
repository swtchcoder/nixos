{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      wine
      lutris
      steam
      proton-ge-custom
      gamemode
      bottles
    ];

    variables = {
      DXVK_LOG_LEVEL = "none";
      DXVK_HUD = "0";
      WINEPREFIX = "$HOME/.wine";
      GAMEMODE_AUTO_ENGAGE = "1";
    };
  };

  services.gamemode.enable = true;
  powerManagement.cpuFreqGovernor = "performance";
}