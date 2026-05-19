FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# DTS files for Aquila AM69 not yet in upstream TI kernel tree
SRC_URI:append:aquila-am69 = " \
    file://k3-am69-aquila-clover.dts \
    file://k3-am69-aquila-dev.dts \
    file://k3-am69-aquila-v1.0-clover.dts \
    file://k3-am69-aquila-v1.0-dev.dts \
    file://k3-am69-aquila-v1.0.dtsi \
    file://k3-am69-aquila.dtsi \
    file://pstore.cfg \
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
