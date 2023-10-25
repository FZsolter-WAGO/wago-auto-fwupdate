#!/bin/bash
if [ "$EUID" -ne 0 ]
then
    echo -e "Please run the script as root"
    exit -1
fi
wget -qO /etc/rc.d/S15_z_auto_fwupdate --no-check-certificate "https://raw.githubusercontent.com/FZsolter-WAGO/wago-auto-fwupdate/main/service/S15_z_auto_fwupdate" &>/dev/null
chmod +x /etc/rc.d/S15_z_auto_fwupdate &>/dev/null