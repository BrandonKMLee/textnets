{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/acd49fab8ece11a89ef8ee49903e1cd7bb50f4b7.tar.gz") {} }:

with pkgs;

mkShell rec {
  venvDir = "./.VENV";
  buildInputs = [
    cairo
    poetry
    python39.pkgs.venvShellHook
  ];
  postShellHook = ''
    export PS1="\$(__git_ps1) $PS1"
    export LD_LIBRARY_PATH=${stdenv.cc.cc.lib}/lib/:${cairo}/lib/:$LD_LIBRARY_PATH
    poetry install
    poetry install -E doc
    spacy validate | grep en_core_web_sm || poetry run pip install https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-3.2.0/en_core_web_sm-3.2.0.tar.gz
  '';
}
