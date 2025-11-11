{
  # Quartz development environment
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/master";
  inputs.systems.url = "github:nix-systems/default";
  inputs.xc_src.url = "github:joerdav/xc/main";

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , systems
    , xc_src
    }:
    flake-utils.lib.eachSystem (import systems)
      (system:
      let
        overlays = [
          (final: prev: { xc = xc_src.defaultPackage.${system}; })
        ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs;[
            fzf
            xc
            mdcat
            bun
            git
            rsync
          ];
        };
      });
}
