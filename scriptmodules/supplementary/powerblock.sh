#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="powerblock"
rp_module_desc="PowerBlock Driver"
rp_module_section="driver"
rp_module_flags="noinstclean"

function depends_powerblock() {
    local depends=(cmake doxygen)
    isPlatform "rpi" && depends+=(libraspberrypi-dev)

    getDepends "${depends[@]}"
}

function sources_powerblock() {
    gitPullOrClone "$md_inst" https://github.com/petrockblog/PowerBlock.git
}

function build_powerblock() {
    cd "$md_inst"
    rm -rf "build"
    mkdir build
    cd build
    cmake ..
    make
    md_ret_require="$md_inst/build/powerblock"
}

function install_powerblock() {
    # install from there to system folders
    cd "$md_inst/build"
    make install
}

function gui_powerblock() {
    cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)
    options=(
        1 "Enable PowerBlock driver"
        2 "Disable PowerBlock driver"

    )
    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    if [[ -n "$choices" ]]; then
        case $choices in
            1)
                make -C "$md_inst/build" installservice
                printMsgs "dialog" "Enabled PowerBlock driver."
                ;;
            2)
                make -C "$md_inst/build" uninstallservice
                printMsgs "dialog" "Disabled PowerBlock driver."
                ;;
        esac
    fi
}

function remove_powerblock() {
    make -C "$md_inst/build" uninstallservice
    make -C "$md_inst/build" uninstall
}
