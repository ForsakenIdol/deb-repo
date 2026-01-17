# ForsakenIdol's Debian / Apt Package Repository

This is the structure that will store all of my Debian (`.deb`) packages.

There are 2 important top-level folders:

- `dist`: Contains information about the available packages in this repo and where they are.
- `pool`: Contains the actual `.deb` packages, and optionally anny source packages.

The basic directory structure of a Debian package repository is as follows.

```
repository-root
├── dists                                           # Folder containing information about all available packages
│   └── repository-codename                         # E.g. stable / unstable / bookworm
│       ├── component-name                          # E.g. main (or just the name of your package)
│       │   └── binary-architecture-name            # E.g. binary-all / binary-amd64 / binary-i386
│       │       ├── Packages                        # Text file index for each available package
│       │       └── Packages.gz                     # Gzipped copy of the "Packages" file
│       └── Release                                 # Metadata, e.g. Origin, Label, Suite, Codename, Arch, Components
│
└── pool                                            # Folder where the packages actually reside
    └── component-name                              # Matches the component name under "dists", e.g. main
        └── 1-letter-identifier                     # 1-letter identifier for package, prevents package name collisions
            └── package-name                        # Name of the package only
                └── package_version_arch.deb        # The actual package users will install
```
