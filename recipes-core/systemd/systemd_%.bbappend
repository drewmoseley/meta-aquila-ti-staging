FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://journald-persistent.conf"

PACKAGECONFIG:append = " pstore"

do_install:append() {
    install -d ${D}${sysconfdir}/systemd/journald.conf.d
    install -m 0644 ${WORKDIR}/journald-persistent.conf \
        ${D}${sysconfdir}/systemd/journald.conf.d/
}

FILES:${PN} += "${sysconfdir}/systemd/journald.conf.d/journald-persistent.conf"
