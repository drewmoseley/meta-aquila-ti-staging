FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# aquila-am69.conf sets UBOOT_CONFIG ??= "sd" with Toradex-specific defconfigs
# that don't exist in the upstream TI u-boot tree.  Clear UBOOT_CONFIG so
# u-boot.inc falls through to the UBOOT_MACHINE single-config path.
#
# The patch series adds TARGET_AQUILA_AM69_A72/R5 Kconfig targets, the full
# board/toradex/aquila-am69/ board port (DDR detect/patch, PMIC, MCU CLK),
# and Aquila-specific DTS files + defconfigs for both A72 and R5 builds.
UBOOT_CONFIG:aquila-am69 = ""
UBOOT_MACHINE:aquila-am69 = "aquila-am69_a72_defconfig"

UBOOT_CONFIG:aquila-am69-k3r5 = ""
UBOOT_MACHINE:aquila-am69-k3r5 = "aquila-am69_r5_defconfig"

SRC_URI:append:aquila-am69 = " \
    file://0001-arm-k3-board-dts-Add-Toradex-Aquila-AM69-SoM-support.patch \
    file://0002-arm-aquila-am69-add-defconfig-options-and-board-envi.patch \
    file://0003-board-toradex-aquila-am69-add-Toradex-config-block-s.patch \
    file://0004-board-toradex-aquila-am69-auto-select-carrier-DTB-fr.patch \
"

SRC_URI:append:aquila-am69-k3r5 = " \
    file://0001-arm-k3-board-dts-Add-Toradex-Aquila-AM69-SoM-support.patch \
    file://0002-arm-aquila-am69-add-defconfig-options-and-board-envi.patch \
    file://0003-board-toradex-aquila-am69-add-Toradex-config-block-s.patch \
    file://0004-board-toradex-aquila-am69-auto-select-carrier-DTB-fr.patch \
"
