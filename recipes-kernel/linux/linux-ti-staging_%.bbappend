FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Pull in Toradex security kernel config fragments (dm-verity, dm-crypt,
# op-tee) from meta-toradex-security. meta-ti's linux-ti-staging is not one
# of the kernel recipes that layer bbappends in its dynamic-layers/, so we
# wire it in here using the same idiom (resolved via the security layer's
# root in BBPATH). The .inc self-guards: dm-verity.cfg is only added when
# the tdx-signed-dmverity override is active (INHERIT += "tdx-signed-dmverity").
require recipes-kernel/linux/linux-sec-features.inc

# DTS files for Aquila AM69 not yet in upstream TI kernel tree
SRC_URI:append:aquila-am69 = " \
    file://k3-am69-aquila-clover.dts \
    file://k3-am69-aquila-dev.dts \
    file://k3-am69-aquila-v1.0-clover.dts \
    file://k3-am69-aquila-v1.0-dev.dts \
    file://k3-am69-aquila-v1.0.dtsi \
    file://k3-am69-aquila.dtsi \
"

do_configure:append:aquila-am69() {
    DTS_DIR="${S}/arch/arm64/boot/dts/ti"
    MK="${DTS_DIR}/Makefile"

    cp ${WORKDIR}/k3-am69-aquila-clover.dts       ${DTS_DIR}/
    cp ${WORKDIR}/k3-am69-aquila-dev.dts           ${DTS_DIR}/
    cp ${WORKDIR}/k3-am69-aquila-v1.0-clover.dts   ${DTS_DIR}/
    cp ${WORKDIR}/k3-am69-aquila-v1.0-dev.dts       ${DTS_DIR}/
    cp ${WORKDIR}/k3-am69-aquila-v1.0.dtsi          ${DTS_DIR}/
    cp ${WORKDIR}/k3-am69-aquila.dtsi               ${DTS_DIR}/

    for dtb in \
        k3-am69-aquila-clover.dtb \
        k3-am69-aquila-dev.dtb \
        k3-am69-aquila-v1.0-clover.dtb \
        k3-am69-aquila-v1.0-dev.dtb \
    ; do
        grep -q "${dtb}" "${MK}" || echo "dtb-\$(CONFIG_ARCH_K3) += ${dtb}" >> "${MK}"
    done

}

do_compile:prepend:aquila-am69() {
    # pstore/ramoops — built-in so crash capture works before modules load.
    # Must run here (after do_configure) because kernel-yocto runs a second
    # oldconfig after do_configure:append that reverts any changes made there.
    ${S}/scripts/config --file ${B}/.config \
        -e PSTORE \
        -e PSTORE_RAM \
        -e PSTORE_CONSOLE \
        -e PSTORE_PMSG \
        -d PSTORE_COMPRESS
    yes "" | oe_runmake -C ${S} O=${B} oldconfig
}
