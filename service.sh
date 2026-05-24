#!/system/bin/sh

# Wait for boot to complete and system props to be ready
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 1
done

# Sleep a bit more to ensure vendor init is done
sleep 15

# Set the crucial properties that we confirmed work
setprop persist.vendor.qcom.bluetooth.aac_vbr_ctl.enabled true
setprop persist.vendor.bt.aac_vbr_ctl.enable true
setprop persist.vendor.bt.aac_vbr_frm_ctl 2

# Restart Bluetooth daemon to apply changes
setprop ctl.restart bluetoothd
