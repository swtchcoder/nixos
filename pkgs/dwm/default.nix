{ pkgs, ... }:
pkgs.stdenv.mkDerivation rec {
  name = "dwm-custom";
  
  src = pkgs.fetchurl {
    url = "https://dl.suckless.org/dwm/dwm-6.5.tar.gz";
    sha256 = "Ideev6ny+5MUGDbCZmy4H0eExp1k5/GyNS+blwuglyk=";
  };
  
  patches = [
    ./dwm.diff
  ];

  buildInputs = with pkgs; [
    xorg.libX11
    xorg.libXft
    xorg.libXinerama
    freetype
    fontconfig
  ];

  installFlags = [ "PREFIX=$(out)" ];
}
