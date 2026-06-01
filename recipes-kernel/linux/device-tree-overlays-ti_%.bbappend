FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Placeholder Intuitive Surgical custom-carrier overlay (SOW R.15.1/R.15.3/R.15.4).
#
# Built and deployed to ${DEPLOY_DIR_IMAGE}/overlays as a .dtbo, but deliberately
# NOT added to TEZI_EXTERNAL_KERNEL_DEVICETREE_BOOT, so it is not written to
# overlays.txt and U-Boot does not apply it at boot. Ships disabled until the
# Intuitive carrier schematic is known. See the overlay's header for how to enable.
SRC_URI:append:aquila-am69 = " file://aquila-am69_intuitive-carrier_overlay.dts"

# do_collect_overlays (toradex-devicetree.bbclass) cleans DT_FILES_PATH then copies
# the overlay sources to be compiled into it. Append our placeholder afterwards so
# devicetree.bbclass compiles it to a .dtbo alongside the stock machine overlays.
do_collect_overlays:append:aquila-am69() {
    cp ${WORKDIR}/aquila-am69_intuitive-carrier_overlay.dts ${DT_FILES_PATH}/
}
