{ stdenv, callPackage, fetchFromGitHub, gambit, gambit-unstable }:

callPackage ./build.nix {
  version = "unstable-2020-02-24";
  git-version = "0.16-DEV-491-g49df553e";
  #gambit = gambit-unstable;
  gambit = gambit;
  src = fetchFromGitHub {
    owner = "vyzo";
    repo = "gerbil";
    rev = "49df553e51a5cd78adb56a978b44258e1add6988";
    sha256 = "1jcq399g6mrz14jbpr3xj8k46ghiqxbf9c3wbcqv9f4h5215955z";
  };
  inherit stdenv;
}
