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

This structure omits GPG key signing, requiring end users to explicitly trust the Apt repository when using it.

## Creating the Repository

The following steps create the Apt repository structure from scratch for the `pathfinder` package. Start at the root directory of the Git repository.

```sh
PATHFINDER_DEB_PATH=~/Documents/pathfinder/pathfinder_0.1.0-1_all.deb

mkdir forsakenidol && cd forsakenidol
mkdir -p ./{dists/stable/main/binary-all,pool/main/p/pathfinder}
cp $PATHFINDER_DEB_PATH pool/main/p/pathfinder/
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
```

- Notice that the `dpkg-scanpackages` command is run from the repository root directory.
    - The `2>/dev/null` is there to remove the final line that `dpkg-scanpackages` prints to `stderr` regarding the entries it's written. Keeping this line in will mess up the format of the `Packages` file. The blackholed line looks like this: `dpkg-scanpackages: info: Wrote 1 entries to output Packages file.`

## Hosting the Repository (Locally)

Given the correct directory structure, we can host a simple repository with `python3 -m http.server 5000` in the Git repository's top-level directory.

We then need to add the repository to Apt's source list. All files in the `/etc/apt/sources.list.d` are owned by `root`.

```sh
sudo touch /etc/apt/sources.list.d/forsakenidol.list
echo "deb [trusted=yes] http://localhost:5000/forsakenidol stable main" | sudo tee /etc/apt/sources.list.d/forsakenidol.list > /dev/null
sudo apt update
apt-cache search pathfinder     # Look for: "pathfinder - PATH environment consolidation and enumeration"
```

You can then test installation and removal of the `pathfinder` package.

To clean up:

```sh
sudo rm /etc/apt/sources.list.d/forsakenidol.list
```

## Hosting the Repository (Azure)

The Terraform scripts in this repository under `terraform/azure` are responsible for setting up the Azure blob storage container and adjacent utilities to host the Debian repository remotely on Microsoft Azure. The `terraform/` directory and the `README.md` top-level markdown file are not synced to Azure when using the `azcopy` command-line utility.

TODO:

- Set up Terraform and azurerm providers
- Set up a backend (probably azure blob storage in its own resource group, created **before** configuring it as the terraform backend)
- Use Terraform to set up the Azure blob storage container and all other adjacent required components
    - I might just choose to import the resource group used for the backend so I create the other blob storage container in the same resource group

It might be easier to just run `terraform plan` and `terraform apply` locally for the actual infrastructure to avoid having to set up federated Azure credentials for now; these can be added later with the following TODO tasks.

- Set up Azure authentication identities to be used with GitHub Actions
- Set up a GitHub Actions pipeline to validate, plan, and apply changes on push to the master branch
- (remember to run `terraform fmt` locally before pushing)

Then again, I might need those credentials anyway for the next few tasks.

- Configure `azcopy` syncing pipeline for this repo, excluding the `terraform/` directory and `README.md` scripts
