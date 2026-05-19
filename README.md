# meta-aquila-ti-staging

Yocto layer extending the standard [Toradex BSP](https://github.com/toradex/toradex-bsp-platform)
for the Aquila AM69 module to use the upstream TI staging kernel (linux-ti-staging 6.12)
and TI U-Boot 2025.01 in place of Toradex's downstream forks.

All other BSP components (GPU drivers, firmware) remain as configured by the standard Toradex BSP.

## Prerequisites

Install the `repo` tool and standard Yocto host dependencies.
See the [Toradex build guide](https://developer.toradex.com/linux-bsp/in-depth/build-yocto-image-for-toradex-modules/)
for full details.

On Ubuntu/Debian:

```bash
sudo apt install repo gawk wget git diffstat unzip texinfo gcc build-essential \
    chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils \
    iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev \
    pylint xterm python3-subunit mesa-common-dev zstd liblz4-tool
```

## Build Steps

### 1. Initialize the Toradex BSP workspace

```bash
mkdir -p ~/yocto/scarthgap
cd ~/yocto/scarthgap

repo init \
    -u https://github.com/toradex/toradex-bsp-platform.git \
    -b scarthgap \
    -m tdxref/default.xml

repo sync
```

### 2. Install the local manifest and sync

Download the local manifest, sync to check out this layer, then replace the
downloaded file with a symlink so future edits stay in one place:

```bash
mkdir -p .repo/local_manifests

wget -O .repo/local_manifests/aquila-am69-ti-staging.xml \
    https://raw.githubusercontent.com/drewmoseley/meta-aquila-ti-staging/main/local-manifests/aquila-am69-ti-staging.xml

repo sync

# Replace the downloaded copy with a symlink into the checked-out layer
rm .repo/local_manifests/aquila-am69-ti-staging.xml
ln -s ../../layers/meta-aquila-ti-staging/local-manifests/aquila-am69-ti-staging.xml \
      .repo/local_manifests/aquila-am69-ti-staging.xml
```

### 3. Set up the build environment

```bash
cd ~/yocto/scarthgap
source export
```

On the first run this copies template `bblayers.conf` and `local.conf` into `build/conf/`.

### 4. Add this layer

Run from within the build directory (already active after sourcing `export`):

```bash
bitbake-layers add-layer ../layers/meta-aquila-ti-staging
```

### 5. Configure the build

Edit `build/conf/local.conf` and set at minimum:

```
MACHINE = "aquila-am69"
ACCEPT_FSL_EULA = "1"
```

Optionally set a shared download directory:

```
DL_DIR = "/path/to/shared/downloads"
```

### 6. Build an image

```bash
bitbake tdx-reference-minimal-image
```

Other supported images: `tdx-reference-multimedia-image`, `core-image-base`

## Notes

- `linux-ti-staging 6.12` and `u-boot-ti-staging 2025.01` are provided by
  `meta-ti/meta-ti-bsp`, already included in the Toradex BSP manifest.
  This layer selects them via `TI_PREFERRED_BSP = "ti-6_12"`.

- To revert to the Toradex downstream kernel and bootloader, remove this layer:

  ```bash
  bitbake-layers remove-layer ../layers/meta-aquila-ti-staging
  ```
