let
  pkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/fa64ec5c1ca6f17746f3defedb988b9248e97616.tar.gz";
  }) { };
in

pkgs.mkShell {
  name = "developer.rebble.io-devshell";
  packages = with pkgs; [
    bundler
    nodejs
    ruby
    solargraph
    python3
    vscode-langservers-extracted
    zlib
  ];
}
