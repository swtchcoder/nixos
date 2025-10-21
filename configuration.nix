{ pkgs, ... }:
let 
  dotfiles = builtins.fetchGit {
    url = "https://github.com/swtchcoder/dotfiles";
    rev = "73c21e900397d8ab2551d5a08189978c5e5723ae";
  };
in {
  imports = [
    ./hardware-configuration.nix 
  ];
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      useOSProber = true;
      efiSupport = true;
    };
    efi.canTouchEfiVariables = true;
  };
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    gc.automatic = true;
  };
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall.enable = true;
  };
  time.timeZone = "Europe/Paris";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS        = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT    = "en_US.UTF-8";
      LC_MONETARY       = "en_US.UTF-8";
      LC_NAME           = "en_US.UTF-8";
      LC_NUMERIC        = "en_US.UTF-8";
      LC_PAPER          = "en_US.UTF-8";
      LC_TELEPHONE      = "en_US.UTF-8";
      LC_TIME           = "en_US.UTF-8";
    };
  };
  users.users.switchcodeur = {
    isNormalUser = true;
    description = "switchcodeur";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" ];
  };
  nixpkgs.config.allowUnfree = true;
  services.udisks2.enable = true;
  home-manager.users.switchcodeur = {
    home = {
      stateVersion = "24.11";
      packages = with pkgs; [
        neovim
        tmux
        udiskie
      ];
      file = {
        ".config/nvim".source = "${dotfiles}/nvim";
        ".config/tmux".source = "${dotfiles}/tmux";
      };
    };
    services.udiskie = {
      enable = true;
      tray = "never";
      notify = true;
      automount = true;
    };
  };
  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      nerd-fonts.meslo-lg
    ];
  };
  system.stateVersion = "24.11";
}
