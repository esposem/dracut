#!/bin/bash
# This file is part of dracut.
# SPDX-License-Identifier: GPL-2.0-or-later

# Prerequisite check(s) for module.
check() {

    # Return 0 to include the module(s) in the initramfs.
    return 0

}

# Module dependency requirements.
depends() {

    # This module has external dependency on other module(s).
    echo systemd
    # Return 0 to include the dependent module(s) in the initramfs.
    return 0

}

# Install the required file(s) and directories for the module in the initramfs.
install() {
    inst_simple "$moddir/initrd-modules-copy.service" "${systemdsystemunitdir}"/initrd-modules-copy.service

    for _f in modules.builtin.bin modules.order modules.alias modules.builtin.modinfo modules.softdep modules.alias.bin modules.dep modules.symbols modules.builtin modules.dep.bin modules.symbols.bin modules.builtin.alias.bin modules.devname; do
        [[ -e $srcmods/$_f ]] && inst_simple "$srcmods/$_f" "/lib/modules/$kernel/$_f"
    done

    $SYSTEMCTL -q --root "$initdir" enable initrd-modules-copy.service
}