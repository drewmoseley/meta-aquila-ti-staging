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
     -u git://git.toradex.com/toradex-manifest.git \
     -b refs/heads/scarthgap-7.x.y \
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

- `recipes-kernel/linux/files/aquila-am69_intuitive-carrier_overlay.dts` is a
  **disabled placeholder overlay** scaffolding SOW signals R.15.1 (TPM_RST_L),
  R.15.3 (SOM_BOOT_WAIT_GPIO#), and R.15.4 (LOW_BATT#) for the Intuitive Surgical
  custom carrier. All pins are fake (`0xFF`) pending confirmed pin/polarity values
  from the Intuitive carrier schematic.

  `device-tree-overlays-ti_%.bbappend` adds it to the overlay build, so it is
  compiled and deployed to `/boot/overlays/` as a `.dtbo`. It is intentionally
  **not** listed in `TEZI_EXTERNAL_KERNEL_DEVICETREE_BOOT`, so it is not written to
  `overlays.txt` and U-Boot does not apply it at boot. To enable during carrier
  bring-up, populate the pins and add the `.dtbo` filename to
  `TEZI_EXTERNAL_KERNEL_DEVICETREE_BOOT` (or to `overlays.txt` on the boot
  partition for a quick on-target test). R.15.2 (TPM interrupt) is already live on
  the SoM TPM node and is not part of this scaffold.
