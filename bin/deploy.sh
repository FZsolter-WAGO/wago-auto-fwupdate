#!/bin/bash
main() {
    input1="${1:-help}"
    if [[ "$input1" == "help" ]]; then
        echo "   wago-auto-fwupdate 1.0.0 - Tool for downloading and deploying a specific firmware version from the Github repository"
        echo ""
        echo "   Usage: .../deploy.sh help|FIRMWARE_REVISION"
        echo ""
        echo "   Example: .../deploy.sh \"04.03.03(25)\""
        exit 0
    fi
    if [ "$EUID" -ne 0 ]
    then
        echo "ERROR: Please run the script as root"
        exit 1
    fi
    WAGO_FWUPDATE="/etc/config-tools/fwupdate"
    CURRENT_FWUPDATE_STATUS=$($WAGO_FWUPDATE status | grep status= | awk -F'=' '{print $2}')
    if [[ -z "$CURRENT_FWUPDATE_STATUS" ]]; then
        echo "ERROR: /etc/config-tools/fwupdate is not available"
        exit 1
    fi
    if [[ "$CURRENT_FWUPDATE_STATUS" != "inactive" ]]; then
        echo "ERROR: Firmware update is in progress"
        exit 1
    fi
    # Lets download the firmware first
    CURRENT_ORDER_NUMBER="$(/etc/config-tools/get_coupler_details order-number)"
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
    wget -qO /tmp/FW.md5 --no-check-certificate "https://raw.githubusercontent.com/FZsolter-WAGO/wago-auto-fwupdate/main/firmwares/$FW_TYPE/$input1/FW.md5" &>/dev/null
    if [ ! -s "/tmp/FW.md5" ]; then
        echo "Error while downloading MD5 file"
        exit 1
    fi
    wget -qO /tmp/FW.raucb --no-check-certificate "https://raw.githubusercontent.com/FZsolter-WAGO/wago-auto-fwupdate/main/firmwares/$FW_TYPE/$input1/FW.raucb" &>/dev/null
    if [ ! -s "/tmp/FW.raucb" ]; then
        echo "Error while downloading firmware file"
        exit 1
    fi
    downloaded_md5=$(md5sum /tmp/FW.raucb | awk '{print $1}')
    expected_md5=$(cat /tmp/FW.md5)
    if [ "$downloaded_md5" = "$expected_md5" ]; then
        echo "Firmware file validation successful."
    else
        echo "Firmware file validation failed. The downloaded file is not valid."
        exit 1
    fi
    wget -qO /etc/rc.d/S15_z_auto_fwupdate --no-check-certificate "https://raw.githubusercontent.com/FZsolter-WAGO/wago-auto-fwupdate/main/service/S15_z_auto_fwupdate" &>/dev/null
    chmod +x /etc/rc.d/S15_z_auto_fwupdate &>/dev/null
    echo "Starting the background process"
    /etc/rc.d/S15_z_auto_fwupdate start
}
main