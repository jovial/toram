#!/bin/sh

type getarg >/dev/null 2>&1 || . /lib/dracut-lib.sh
type det_fs >/dev/null 2>&1 || . /lib/fs-lib.sh

mount_root() {
    local _ret
    local _rflags_ro
    # sanity - determine/fix fstype
    rootfs=$(det_fs "${root#block:}" "$fstype")

    journaldev=$(getarg "root.journaldev=")
    if [ -n "$journaldev" ]; then
        case "$rootfs" in
            xfs)
                rflags="${rflags:+${rflags},}logdev=$journaldev"
                ;;
            reiserfs)
                fsckoptions="-j $journaldev $fsckoptions"
                rflags="${rflags:+${rflags},}jdev=$journaldev"
                ;;
            *);;
        esac
    fi

    _rflags_ro="$rflags,ro"
    _rflags_ro="${_rflags_ro##,}"
    
    mkdir /ramboottmp
    mount -t ${rootfs} -o "$_rflags_ro" "${root#block:}" /ramboottmp
    mount -t tmpfs -o size=100% none "$NEWROOT"
    cp -rfa /ramboottmp/* "$NEWROOT"
    umount /ramboottmp

}

if [ -n "$root" -a -z "${root%%block:*}" ]; then
    mount_root
fi
