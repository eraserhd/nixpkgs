{ stdenv, parinfer-rust, fetchFromGitHub }:

{
  inherit parinfer-rust;

  kak-ansi = stdenv.mkDerivation rec {
    name = "kak-ansi";
    version = "0.2.0";
    src = fetchFromGitHub {
      owner = "eraserhd";
      repo = "kak-ansi";
      rev = "v${version}";
      sha256 = "15bw3rhwmary50j850akm766ig6klflgkily60m5zvic0rsvlk2p";
    };

    buildInputs = [ stdenv ];

    buildPhase = ''
      $CC -O2 -std=c99 -o kak-ansi-filter kak-ansi-filter.c
    '';

    installPhase = ''
      mkdir -p $out/bin $out/share/kak/autoload/plugins/
      cp kak-ansi-filter $out/bin/

      # Hard-code path of filter and don't try to build when Kakoune boots
      sed '
        /^declare-option.* ansi_filter /i\
declare-option -hidden str ansi_filter %{'"$out"'/bin/kak-ansi-filter}
        /^declare-option.* ansi_filter /,/^}/d
      ' rc/ansi.kak >$out/share/kak/autoload/plugins/ansi.kak
    '';

    meta = with stdenv.lib; {
      description = "Kakoune support for rendering ANSI code.";
      homepage = "https://github.com/eraserhd/kak-ansi";
      license = licenses.publicDomain;
      maintainers = with maintainers; [ eraserhd ];
      platforms = platforms.all;
    };
  };
}
