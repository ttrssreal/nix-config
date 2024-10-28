# https://github.com/nix-community/nix-direnv/wiki/Shell-integration

nixify() {
  if [ ! -e ./.envrc ]; then
    echo "use nix" > .envrc
    direnv allow
  fi
  if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
    cat > default.nix <<'EOF'
with import <nixpkgs> {};
mkShell {
  nativeBuildInputs = [
    bashInteractive
  ];
}
EOF
    ${EDITOR:-vim} default.nix
  fi
}
flakify() {
  if [ ! -e flake.nix ]; then
    nix flake new -t github:ttrssreal/nix-config#shell .
    curl -LOs https://github.com/nix-community/nix-direnv/raw/refs/heads/master/templates/flake/.envrc
    direnv allow
  elif [ ! -e .envrc ]; then
    echo "use flake" > .envrc
    direnv allow
  fi
  ${EDITOR:-vim} flake.nix
}
