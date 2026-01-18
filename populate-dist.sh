#!/bin/sh

set -e -u

# Check that script is being run from the correct directory
echo "Checking for correct calling directory..."
if [ ! -d "pool" ]; then
    echo "[Error] Dist must be populated from the directory containing the package pool."
    exit 1
fi

# Check that environment has all the required tools
echo "Checking for required tools..."
for cmd in "dpkg-scanpackages" "gzip" "apt-ftparchive"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "[Error] $cmd is missing from shell."
        exit 1
    else
        echo "\"$cmd\" is present in shell."
    fi
done

echo "Creating dist/ folder package metadata..."

mkdir -p ./dists/stable/main/binary-all
dpkg-scanpackages pool/ 2>/dev/null > dists/stable/main/binary-all/Packages
gzip -c dists/stable/main/binary-all/Packages > dists/stable/main/binary-all/Packages.gz

cat << EOF > dists/stable/Release
Origin: ForsakenIdol
Label: Pathfinder Repo
Suite: stable
Codename: stable
Architectures: all
Components: main
Description: Pathfinder APT Repository
EOF

cd dists/stable && apt-ftparchive release . >> Release
echo "Done!"
