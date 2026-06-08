# Default the aquila-am69 carrier DTB to Clover.
# U-Boot PREBOOT builds fdtfile=k3-am69-aquila${variant}-${fdt_board}.dtb from
# board/toradex/aquila-am69/aquila-am69.env, which ships fdt_board=dev.
# Patch that default to clover at configure time so no manual setenv is needed.
do_configure:append() {
    if [ -f "${S}/board/toradex/aquila-am69/aquila-am69.env" ]; then
        sed -i 's/^fdt_board=dev$/fdt_board=clover/' \
            ${S}/board/toradex/aquila-am69/aquila-am69.env
    fi
}
