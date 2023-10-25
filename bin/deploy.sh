#!/bin/bash
if [ "$EUID" -ne 0 ]
then
    echo "Please run the script as root"
    exit 1
fi
# Lets download the firmware first
CURRENT_ORDER_NUMBER="$(/etc/config-tools/get_coupler_details order-number)"
CURRENT_FW_REVISION="$(/etc/config-tools/get_coupler_details firmware-revision)"
case $CURRENT_ORDER_NUMBER in
    750-8212)
        FW_TYPE=pfc_g2
        ;;
    *)
        echo ERROR: Unsupported type of device!
        exit 1
        ;;
esac
echo "Trying to download $CURRENT_FW_REVISION for $CURRENT_ORDER_NUMBER..."
wget -qO /tmp/FW.md5 --no-check-certificate "https://raw.githubusercontent.com/FZsolter-WAGO/wago-auto-fwupdate/main/firmwares/$FW_TYPE/$CURRENT_FW_REVISION/FW.md5" &>/dev/null
if [ ! -s "/tmp/FW.md5" ]; then
    echo "Error while downloading MD5 file"
    exit 1
fi
wget -qO /tmp/FW.raucb --no-check-certificate "https://raw.githubusercontent.com/FZsolter-WAGO/wago-auto-fwupdate/main/firmwares/$FW_TYPE/$CURRENT_FW_REVISION/FW.raucb" &>/dev/null
if [ ! -s "/tmp/FW.raucb" ]; then
    echo "Error while downloading RAUCB file"
    exit 1
fi
downloaded_md5=$(md5sum /tmp/FW.raucb | awk '{print $1}')
expected_md5=$(cat /tmp/FW.md5)
if [ "$downloaded_md5" = "$expected_md5" ]; then
    echo "RAUCB file validation successful."
else
    echo "RAUCB file validation failed. The downloaded file is not valid."
    exit 1
fi
wget -qO /etc/rc.d/S15_z_auto_fwupdate --no-check-certificate "https://raw.githubusercontent.com/FZsolter-WAGO/wago-auto-fwupdate/main/service/S15_z_auto_fwupdate" &>/dev/null
chmod +x /etc/rc.d/S15_z_auto_fwupdate &>/dev/null