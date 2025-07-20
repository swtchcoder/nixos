{ pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "slstatus";
  version = "1.1";

  src = pkgs.fetchurl {
    url = "https://dl.suckless.org/tools/slstatus-1.1.tar.gz";
    sha256 = "1NTKd7WRQPJyJy21N+BbuRpZFPVoAmUtxX5hp3PUN5I=";
  };

  buildInputs = with pkgs.xorg; [
    libX11
    libXft
    libXinerama
  ];

  installPhase = ''
    make install PREFIX=$out
  '';
}
