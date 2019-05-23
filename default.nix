{ rev    ? "650a295621b27c4ebe0fa64a63fd25323e64deb3"
, sha256 ? "0rxjkfiq53ibz0rzggvnp341b6kgzgfr9x6q07m2my7ijlirs2da"
, pkgs   ? import (builtins.fetchTarball {
             url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
             inherit sha256; }) {}
}:

with pkgs; stdenv.mkDerivation {

  name = "bazel";

  buildInputs = [
    bazel
    makeWrapper
    openjdk
    python
    unzip
    which
    zip
  ];

  buildPhase = ''
    export TMPDIR=/tmp/.bazel-$UID
    bazel --output_user_root=$TMPDIR/.bazel build //src:bazel
  '';

  src = pkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ] ./. ;

}
