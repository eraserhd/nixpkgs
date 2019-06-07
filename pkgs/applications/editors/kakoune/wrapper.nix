{ stdenv, makeWrapper }:
with stdenv.lib;

kakoune:

let
  getPlugins = { plugins ? [] }: plugins;

  wrapper = { configure ? {} }:
  stdenv.mkDerivation {
    pname = "kakoune";
    version = getVersion kakoune;

    buildCommand = ''
      mkdir -p $out/share/kak
      for plugin in ${strings.escapeShellArgs (getPlugins configure)}; do
        if [[ -d $plugin/share/kak/autoload ]]; then
          find "$plugin/share/kak/autoload" -type f -name '*.kak'| while read rcfile; do
            printf 'source "%s"\n' "$rcfile"
          done
        fi
      done >>$out/share/kak/plugins.kak

      makeWrapper \
        "$(readlink -v --canonicalize-existing "${kakoune}/bin/kak")" \
        "$out/bin/kak" \
        --add-flags "-E 'source $out/share/kak/plugins.kak'"
    '';

    preferLocalBuild = true;
    buildInputs = [ makeWrapper ];
    passthru = { unwrapped = kakoune; };

    meta = kakoune.meta // {
      # prefer wrapper over the package
      priority = (kakoune.meta.priority or 0) - 1;
      hydraPlatforms = [];
    };
  };
in
  makeOverridable wrapper
