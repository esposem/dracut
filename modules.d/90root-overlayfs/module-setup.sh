#!/bin/bash

check() {

    # If the binary(s) requirements are not fulfilled the module can't be installed.
    require_any_binary systemd-cryptsetup cryptsetup || return 1
    require_binaries systemd-repart || return 1
    require_kernel_modules overlay || return 1

    # Return 255 to only include the module, if another module requires it.
    return 255
}

depends() {
    echo systemd-repart crypt
}

installkernel() {
    instmods overlay
}

install() {
    inst_hook pre-pivot 00 "$moddir/mount-overlayroot.sh"
    inst_multiple -o mkfs.btrfs mkfs.ext4 mkfs.xfs
    inst_multiple chcon
}
