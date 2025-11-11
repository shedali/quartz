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
        packages = {
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

              # Install dependencies
              bun install --frozen-lockfile

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
