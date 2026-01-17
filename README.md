# ForsakenIdol's Debian / Apt Package Repository

This is the structure that will store all of my Debian (`.deb`) packages.

There are 2 important top-level folders:

- `dist`: Contains information about the available packages in this repo and where they are.
- `pool`: Contains the actual `.deb` packages, and optionally anny source packages.

The basic directory structure of a Debian package repository is as follows.

```
repository-root
├── index.html                                      # Optional top-level HTML page for users visiting the repo directly.
│
├── dists                                           # Folder containing information about all available packages
│   └── repository-codename                         # E.g. stable / unstable / bookworm
│       ├── Release                                 # Metadata, e.g. Origin, Label, Suite, Codename, Arch, Components
│       └── component-name                          # E.g. main (or just the name of your package)
│           └── binary-architecture-name            # E.g. binary-all / binary-amd64 / binary-i386
│               ├── Packages                        # Text file index for each available package
│               └── Packages.gz                     # Gzipped copy of the "Packages" file
│
└── pool                                            # Folder where the packages actually reside
    └── component-name                              # Matches the component name under "dists", e.g. main
        └── 1-letter-identifier                     # 1-letter identifier for package, prevents package name collisions
            └── package-name                        # Name of the package only
                └── package_version_arch.deb        # The actual package users will install
```

## Creating the Repository

Creating the repository from scratch, from the repository's root directory, for the `pathfinder` package:

```
mkdir -p ./{dists/stable/main/binary-all,pool/main/p/pathfinder}
cp /path/to/pathfinder_0.1.0-1_all.deb pool/main/p/pathfinder/
dpkg-scanpackages pool/ 2>/dev/null > dists/stable/main/binary-all/Packages
gzip -c dists/stable/main/binary-all/Packages > dists/stable/main/binary-all/Packages.gz

cat << EOF > dists/stable/Release
Origin: ForsakenIdol
Label: Pathfinder Repo
Codename: stable
Architectures: all
Components: main
Description: Pathfinder APT Repository
EOF
```

- Notice that the `dpkg-scanpackages` command is run from the repository root directory.
    - The `2>/dev/null` is there to remove the final line that `dpkg-scanpackages` prints to `stderr` regarding the entries it's written. Keeping this line in will mess up the format of the `Packages` file. The blackholed line looks like this: `dpkg-scanpackages: info: Wrote 1 entries to output Packages file.`

## Hosting the Repository (Locally)


