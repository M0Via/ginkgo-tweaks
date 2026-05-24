[English](./README_EN.md) | [中文](./README.md)

<h1 align="center">ginkgo-tweaks 🛠️</h1>

<div align="center">

<h3>One-stop post-root tuning suite for Redmi Note 8 (ginkgo)</h3>

</div>

---

## About

A collection of verified optimizations for the Redmi Note 8 (ginkgo) after rooting, covering Bluetooth audio, system services, power saving, and debloating.

> Some tweaks may also work on other Snapdragon 665 devices.

---

## Contents

### 🎧 AAC Bluetooth Enabler

Qualcomm devices often disable the AAC Bluetooth codec by default, forcing AAC-capable headphones (e.g. AirPods) to use SBC. This module sets required properties at boot and restarts Bluetoothd to force AAC enablement.

**Module ZIP:** `ginkgo-tweaks_v1.1.zip`

### 🔧 qccsyshalservice Crash Fix

`qccsyshalservice` (QTI qcc system HAL) crashes every 5 seconds with `registerAsService() failed: -2147483648`. A Magisk module stops this service at boot — camera/audio are unaffected (handled by a separate `qccvndhal` service).

### 🔋 Power Saving Script

Triggers after 60 minutes of screen-off:
- Airplane mode ON (cellular OFF)
- WiFi stays ON (for downloads / music streaming)
- CPU governor switches to `powersave`
- Restores to normal when screen is on or charging

Auto-starts via Magisk service.d with a 30-second boot delay.

### ⚙️ Boot-Time Optimizations

- Disable I/O stats → reduces eMMC writes
- Disable scheduler stats → reduces CPU overhead
- Disable kernel printk logging → reduces kernel wakeups
- Disable Binder debugging
- Stop diagnostic daemons (`cnss_diag`, `tcpdump`)

### 🧹 Debloat Reference

10 frozen MIUI system apps (via `pm disable-user`):

| App | Reason |
|-----|--------|
| Mi Wallet / NextPay / UnionPay TSM / Payment Service | No NFC hardware |
| Mi Music / Mi Video | Third-party alternatives available |
| Smart Travel / Game Toolbox / Touch Assistant | Unnecessary for backup device |
| Personal Assistant | Launcher left page |

---

## Installation

Download `ginkgo-tweaks_v1.1.zip` and install via Magisk App.

[Download Release](https://github.com/M0Via/ginkgo-tweaks/releases)

---

## Compatibility

| Item | Info |
|------|------|
| **Tested on** | Redmi Note 8 (ginkgo), Android 11 MIUI 12.5 |
| **Root** | Magisk v29.0 |
| **Bootloader** | Unlocked |

---

<p align="center">
  <sub>Built with ❤️ by <a href="https://github.com/M0Via">M0Via</a></sub>
</p>
