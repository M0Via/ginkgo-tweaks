# AAC Bluetooth Enabler

A Magisk module that forces the enablement of the AAC codec for Bluetooth audio on some Qualcomm devices where it is disabled by default in the vendor driver.

## Problem

Some Android devices with Qualcomm chipsets have the AAC codec disabled in their Bluetooth stack (`persist.vendor.qcom.bluetooth.aac_vbr_ctl.enabled=false`), even when the hardware supports it and the connected headphones are AAC-capable. This results in the device only using the lower-quality SBC codec.

## Solution

This module sets the required system properties at boot to enable AAC support, specifically:
- `persist.vendor.qcom.bluetooth.aac_vbr_ctl.enabled=true`
- `persist.vendor.bt.aac_vbr_ctl.enable=true`
- `persist.vendor.bt.aac_vbr_frm_ctl=2`

It then restarts the Bluetooth daemon to apply the changes.

## Installation

1. Download the latest module ZIP from the [Releases](https://github.com/M0Via/magisk-AAC/releases) page.
2. Open the Magisk App, go to **Modules** -> **Install from storage** and select the ZIP file.
3. Reboot your device.

## Verification

After reboot, connect your AAC-capable headphones and check the Bluetooth audio codec in Developer Options. It should now show "AAC" or "System selection".

You can also verify via ADB:
```bash
adb shell su -c getprop | grep aac | grep vendor
```

## Compatibility

* **Tested on**: Xiaomi Redmi Note 8 (ginkgo) / Possibly other Qualcomm-based devices.
* **Requirements**: Magisk v20.4+ and a Qualcomm chipset.

## Manual ADB Method (Temporary)

If you don't want to install the module, you can run these commands via ADB (root required). Changes will be lost after reboot.

```bash
adb shell su -c "setprop persist.vendor.qcom.bluetooth.aac_vbr_ctl.enabled true"
adb shell su -c "setprop persist.vendor.bt.aac_vbr_ctl.enable true"
adb shell su -c "setprop persist.vendor.bt.aac_vbr_frm_ctl 2"
adb shell su -c "setprop ctl.restart bluetoothd"
```