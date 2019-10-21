{ rev    ? "67904dccbb0dfc01c9f8d242db6302cbdfcdb195"
, sha256 ? "0klr0fw2mbn35v84c34y3lsi5rz0kyb7c5i9mnj0sdqrv2020v51"
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
