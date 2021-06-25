{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/acd49fab8ece11a89ef8ee49903e1cd7bb50f4b7.tar.gz") {} }:

with pkgs;

mkShell rec {
  name = "env";
  env = buildEnv { name = name; paths = buildInputs; };
  venvDir = "./.VENV";
  buildInputs = [
    cairo
    poetry
    python3
    python3.pkgs.venvShellHook
  ];
  postShellHook = ''
    export LD_LIBRARY_PATH=${stdenv.cc.cc.lib}/lib/:${cairo}/lib/:$LD_LIBRARY_PATH
    export PS1="\$(__git_ps1) $PS1"
    poetry install
    poetry install -E doc
    poetry install -E test
  '';
}
