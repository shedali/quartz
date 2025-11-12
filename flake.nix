{
  # Quartz development environment and build
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/master";
  inputs.flake-utils.url = "github:numtide/flake-utils";
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
        packages =
          let
            # Fixed-output derivation for Bun dependencies
            bunDeps = pkgs.runCommand "bun-deps"
              {
                outputHashMode = "recursive";
                outputHashAlgo = "sha256";
                outputHash = "sha256-EbwWa9J6MDlwC7elRPvb2KefTKoGcRUFCGzLTq7c3FM=";
                nativeBuildInputs = [ pkgs.bun ];
              }
              ''
                export HOME=$TMPDIR
                cp -r ${./.} ./source
                chmod -R u+w ./source
                cd ./source
                bun install --frozen-lockfile --no-progress
                mkdir -p $out
                cp -r node_modules $out/
              '';
          in
          {
            default = pkgs.stdenv.mkDerivation {
              name = "quartz-site";
              src = ./.;

              nativeBuildInputs = with pkgs; [
                bun
                git
              ];

              buildPhase = ''
                # Set HOME for bun cache
                export HOME=$TMPDIR

                # Copy dependencies from fixed-output derivation
                cp -r ${bunDeps}/node_modules .
                chmod -R u+w node_modules

                # Build the site
                bun run quartz/bootstrap-cli.mjs build
              '';

              installPhase = ''
                # Copy the built site to output
                mkdir -p $out
                cp -r public/* $out/
              '';
            };
          };

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
