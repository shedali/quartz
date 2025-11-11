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

        # Fixed-output derivation to fetch dependencies
        # To update the hash: run 'nix build .#deps' and use the hash from the error message
        deps = pkgs.stdenv.mkDerivation {
          name = "quartz-deps";
          src = ./.;

          nativeBuildInputs = [ pkgs.bun ];

          buildPhase = ''
            export HOME=$TMPDIR
            export BUN_INSTALL_CACHE_DIR=$TMPDIR/bun-cache

            # Install dependencies
            bun install --frozen-lockfile --no-progress
          '';

          installPhase = ''
            mkdir -p $out
            cp -r node_modules $out/
          '';

          outputHashMode = "recursive";
          outputHashAlgo = "sha256";
          outputHash = pkgs.lib.fakeHash;
        };
      in
      {
        packages = {
          # Expose deps for hash computation
          deps = deps;

          default = pkgs.stdenv.mkDerivation {
            name = "quartz-site";
            src = ./.;

            nativeBuildInputs = with pkgs; [
              bun
              git
            ];

            buildPhase = ''
              # Set HOME for bun
              export HOME=$TMPDIR

              # Copy pre-fetched dependencies
              cp -r ${deps}/node_modules .
              chmod -R +w node_modules

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
