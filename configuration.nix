{ pkgs, ... }: let
	home-manager = builtins.fetchTarball {
		url = "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
		sha256 = "1mwq9mzyw1al03z4q2ifbp6d0f0sx9f128xxazwrm62z0rcgv4na";
	};
	dotfiles = builtins.fetchGit {
		url = "https://github.com/swtchcoder/dotfiles";
		rev = "e331725daa22ffe0a011e91c20615ba9348d6e6d";
	};
# DESKTOP
	scroll-patched = pkgs.stdenv.mkDerivation {
		pname = "scroll-patched";
		version = "0.1";
		src = pkgs.fetchurl {
			url = "https://dl.suckless.org/tools/scroll-0.1.tar.gz";
			sha256 = "nrLVnOat9gEAvSFxsNIx3bR+J0sp3tAiVpYKEezO7tY=";
		};
		patches = [ ./patches/mouse.diff ];
		installPhase = "make install PREFIX=$out";
	};
	st-patched = pkgs.stdenv.mkDerivation {
		pname = "st-patched";
		version = "0.8.5";
		src = pkgs.fetchurl {
			url = "https://dl.suckless.org/st/st-0.8.5.tar.gz";
			sha256 = "6mgyID7QL/dBgry4raqexFTI+YnnkjLLhZZl4vVEqzc=";
		};
		patches = [
			./patches/meslonf.diff
			(pkgs.fetchurl {
				url = "https://st.suckless.org/patches/gruvbox/st-gruvbox-dark-0.8.5.diff";
				sha256 = "W1qMGJRcfvmLp9hXzISIGo6XAk/Q88oaYoMD6kAEdks=";
			})
			(pkgs.fetchurl {
				url = "https://st.suckless.org/patches/scrollback/st-scrollback-0.8.5.diff";
				sha256 = "3H9SI7JvyBPZHUrjW9qlTWMCTK6fGK/Zs1lLozmd+lU=";
			})
			(pkgs.fetchurl {
				url = "https://st.suckless.org/patches/scrollback/st-scrollback-mouse-20191024-a2c479c.diff";
				sha256 = "MZRY2YAZXRj6D4GmiY1Y+NBGxf+YKrhy10H1S7YOJn0=";
			})
			(pkgs.fetchurl {
				url = "https://st.suckless.org/patches/anysize/st-anysize-20220718-baa9357.diff";
				sha256 = "sha256-eO8MEPRb3uaCTtBznG+LaojXqlcj4eT422rQgpxopfo="; 
			})
		];
		buildInputs = with pkgs; [
			xorg.libX11
			xorg.libXft
			pkg-config
			fontconfig
			harfbuzz
			freetype
			ncurses
		];
		installPhase = ''
mkdir -p $out/share/terminfo
TERMINFO=$out/share/terminfo make install PREFIX=$out
		'';
	};
	slstatus-patched = pkgs.stdenv.mkDerivation {
		pname = "slstatus-patched";
		version = "1.1";
		src = pkgs.fetchurl {
			url = "https://dl.suckless.org/tools/slstatus-1.1.tar.gz";
			sha256 = "fccUDeXeYfxVHE4P62QQr9RNeODNyu5F0G5XAfNOrBQ=";
		};
		buildInputs = with pkgs.xorg; [
			libX11
			libXft
			libXinerama
		];
		installPhase = "make install PREFIX=$out";
	};
	dmenu-patched = pkgs.stdenv.mkDerivation {
		pname = "dmenu-patched";
		version = "5.2";
		src = pkgs.fetchurl {
			url = "https://dl.suckless.org/tools/dmenu-5.2.tar.gz";
			sha256 = "1NTKd7WRQPJyJy21N+BbuRpZFPVoAmUtxX5hp3PUN5I=";
		};
		patches = [
			(pkgs.fetchurl {
				url = "https://tools.suckless.org/dmenu/patches/border/dmenu-border-5.2.diff";
				sha256 = "5R5pkUKmX7OPEP3kE2RiF7/zqmXpToLXC8gHZj4o0U8=";
			})
			(pkgs.fetchurl {
				url = "https://tools.suckless.org/dmenu/patches/center/dmenu-center-5.2.diff";
				sha256 = "mnssQ/j6HTH0dg3gspRoj+sZcTXuaA/iOGugfj1Ck8k=";
			})
		];
		buildInputs = with pkgs.xorg; [
			libX11
			libXft
			libXinerama
		];
		installPhase = "make install PREFIX=$out";
	};
	dwm-patched = pkgs.stdenv.mkDerivation {
		pname = "dwm-patched";
		version = "6.5";
		src = pkgs.fetchurl {
			url = "https://dl.suckless.org/dwm/dwm-6.5.tar.gz";
			sha256 = "Ideev6ny+5MUGDbCZmy4H0eExp1k5/GyNS+blwuglyk=";
		};
		patches = [ ./patches/dwm.diff ];
		buildInputs = with pkgs; [
			xorg.libX11
			xorg.libXft
			xorg.libXinerama
			freetype
			fontconfig
		];
		installPhase = "make install PREFIX=$out";
	};
# ---
in {
	imports = [
		(import "${home-manager}/nixos")
		./hardware-configuration.nix
	];
# DUAL BOOT
# 	boot.loader = {
# 		grub = {
# 			enable = true;
# 			device = "nodev";
# 			useOSProber = true;
# 			efiSupport = true;
# 		};
# 		efi.canTouchEfiVariables = true;
#	};
# ---
	nix = {
		settings.experimental-features = [ "flakes" "nix-command" ];
		gc.automatic = true;
	};
	networking = {
		hostName = "nixos";
		networkmanager.enable = true;
		firewall = {
			enable = true;
			allowedTCPPorts = [ 22 ];
		};
	};
	time.timeZone = "Europe/Paris";
	i18n = {
		defaultLocale = "en_US.UTF-8";
		extraLocaleSettings = {
			LC_ADDRESS        = "en_US.UTF-8";
			LC_IDENTIFICATION = "en_US.UTF-8";
			LC_MEASUREMENT    = "en_US.UTF-8";
			LC_MONETARY       = "en_US.UTF-8";
			LC_NAME	          = "en_US.UTF-8";
			LC_NUMERIC        = "en_US.UTF-8";
			LC_PAPER          = "en_US.UTF-8";
			LC_TELEPHONE      = "en_US.UTF-8";
			LC_TIME		      = "en_US.UTF-8";
		};
	};
	nixpkgs.config.allowUnfree = true;
	virtualisation.docker.enable = true;
	users.users.switchcodeur = {
		isNormalUser = true;
		extraGroups = [ "networkmanager" "wheel" "docker" "video" ];
	};
	security.sudo = {
		enable = true;
		wheelNeedsPassword = false;
	};
	hardware = {
# NVIDIA GPU
# 		nvidia = {
# 			modesetting.enable = true;
# 			optimus_prime = true;
# 			package = pkgs.linuxPackages.nvidia_x11;
# 			cudaSupport = true;
# 		};
# ---
		opengl = {
			enable = true;
			extraPackages = with pkgs; [
				vulkan-loader
				vulkan-tools
# MAIN GPU (AMD/NVIDIA)
# 				amdvlk
# 				nvidia-x11
# ---
			];
		};
# XBOX CONTROLLER
# 		xone.enable = true;
# ---
	};
	environment = {
		systemPackages = with pkgs; [ 
			git
# NVIDIA GPU
# 			cudatoolkit
# ---
		];
# PC GAMING
# 		variables = {
# 			DXVK_LOG_LEVEL = "none";
# 			DXVK_HUD = "0";
# 			WINEPREFIX = "$HOME/.wine";
# 			GAMEMODE_AUTO_ENGAGE = "1";
# 		};
# ---
	};
	services = {
# DESKTOP
		xserver = {
			enable = true; # DESKTOP
			xkb = {
	# KEYBOARD LAYOUT (QWERTY/AZERTY)
				layout = "us";
	# 			layout = "fr";
	# ---
				variant = "";
			};
			displayManager.startx.enable = true;
	# MAIN GPU (AMD/NVIDIA)
	# 		videoDrivers = [ "amdgpu" ];
	# 		videoDrivers = [ "nvidia" ];
	# ---
		};
		pipewire = {
			audio.enable = true;
			pulse.enable = true;
			jack.enable = true;
			alsa = {
				enable = true;
				support32Bit = true;
			};
		};
# ---
# NVIDIA GPU
# 		udev.packages = [ pkgs.mesa ];
# ---
		udisks2.enable = true;
		avahi = {
			enable = true;
			nssmdns4 = true;
			publish = {
				enable = true;
				addresses = true;
				workstation = true;
			};
		};
		openssh.enable = true;
	};
# PC GAMING
# 	programs.steam = {
# 		enable = true;
# 		remotePlay.openFirewall = true;
# 		dedicatedServer.openFirewall = true;
# 		localNetworkGameTransfers.openFirewall = true;
# 	};
# ---
# CPU GOVERNOR (PERFORMANCE/POWERSAVE)
	powerManagement.cpuFreqGovernor = "performance";
# 	powerManagement.cpuFreqGovernor = "powersave";
# ---
	home-manager.users.switchcodeur = {
		home = {
			stateVersion = "24.11";
			packages = with pkgs; [
				neovim
				tmux
				udiskie
# DESKTOP
				dconf
				scroll-patched
				st-patched
				slstatus-patched
				dmenu-patched
				dwm-patched
				feh
				firefox
	# PC GAMING
	# 				wine
	# 				steam
	# 				lutris
	# 				bottles
	# 				heroic
	# 				protonplus
	# 				gamemode
	# ---
# ---
			];
			file = {
# DESKTOP
				".bash_profile".text = ''
if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]]; then
	exec startx
fi
				'';
				".xinitrc".text = ''
#!/bin/sh
${pkgs.feh}/bin/feh --bg-scale /etc/nixos/assets/wallpaper.png &
${slstatus-patched}/bin/slstatus &
exec ${dwm-patched}/bin/dwm
				'';
# ---
				".config/nvim".source = "${dotfiles}/nvim";
				".config/tmux".source = "${dotfiles}/tmux";
				".config/nixpkgs/config.nix".text = ''
{
	allowUnfree = true;
}
				'';
			};
		};
		services.udiskie = {
			enable = true;
			tray = "never";
			notify = true;
			automount = true;
		};
# DESKTOP
		dconf = {
			enable = true;
			settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
		};
		gtk = {
			enable = true;
			theme = {
				name = "Adwaita-dark";
				package = pkgs.gnome-themes-extra;
			};
			gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
			gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
		};
		qt = {
			enable = true;
			style.name = "adwaita-dark";
		};
# ---
	};
# DESKTOP
	fonts = {
		fontconfig.enable = true;
		packages = [ (pkgs.nerdfonts.override { fonts = [ "Meslo" ]; }) ];
	};
# ---
	system.stateVersion = "24.11";
}
