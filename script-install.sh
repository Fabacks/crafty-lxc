#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/Fabacks/crafty-lxc/main/build.func)
# Copyright (c) 2024
# Author: Fabacks
# License: MIT
# https://github.com/Fabacks/crafty-lxc/blob/main/LICENSE


echo -e "Loading..."
APP="Crafty"
var_disk="10"
var_cpu="2"
var_ram="2048"
var_os="debian"
var_version="11"
variables
color
catch_errors

function default_settings() {
    CT_TYPE="1"
    PASSWORD=""
    CT_ID=$NEXTID
    HN=$NSAPP
    DISK_SIZE="$var_disk"
    CORE_COUNT="$var_cpu"
    RAM_SIZE="$var_ram"
    BRG="vmbr0"
    NET="dhcp"
    PORT=""
    APT_CACHER=""
    APT_CACHER_IP=""
    DISABLEIP6="no"
    MTU=""
    SD=""
    MAC=""
    VLAN=""
    SSH="no"
    VERBOSE="no"
    echo_default
}

function install_crafty() {
    msg_info "Installing Crafty in the LXC container"
    # Update and upgrade packages
    pct exec $CT_ID -- bash -c "apt update && apt upgrade -y"
    # Install Git
    pct exec $CT_ID -- bash -c "apt install git -y"
    # Install JDK 21
    pct exec $CT_ID -- bash -c "apt install openjdk-21-jdk -y"
    # Clone the Crafty installer and run it
    pct exec $CT_ID -- bash -c "git clone https://gitlab.com/crafty-controller/crafty-installer-4.0.git && cd crafty-installer-4.0 && sudo ./install_crafty.sh"
    msg_ok "Crafty successfully installed"
}

start
build_container
default_settings
description
install_crafty

msg_ok "Installation successful!\n"
echo -e "${APP} should be accessible once configured and started.\n"