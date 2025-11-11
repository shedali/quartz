#!/usr/bin/env bash
# Helper script to update the Nix dependencies hash

set -e

echo "Building deps to get the correct hash..."
echo "This will fail, but will show the correct hash to use."
echo ""

# Try to build deps - this will fail with hash mismatch
if nix build .#deps 2>&1 | tee /tmp/nix-build-output.txt; then
    echo "Build succeeded! Hash is already correct."
else
    # Extract the actual hash from error message
    ACTUAL_HASH=$(grep -oP "got:\s+\K(sha256-[A-Za-z0-9+/=]+)" /tmp/nix-build-output.txt | head -1)

    if [ -n "$ACTUAL_HASH" ]; then
        echo ""
        echo "Found hash: $ACTUAL_HASH"
        echo ""
        echo "Updating flake.nix..."

        # Update the hash in flake.nix
        sed -i "s|outputHash = pkgs.lib.fakeHash;|outputHash = \"$ACTUAL_HASH\";|" flake.nix

        echo "Hash updated! Now run 'nix build' to verify."
    else
        echo "Could not extract hash from build output."
        echo "Check /tmp/nix-build-output.txt for details."
        exit 1
    fi
fi
