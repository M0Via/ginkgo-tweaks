[English](./README_EN.md) | [中文](./README.md)

<h1 align="center">ginkgo-tweaks 🛠️</h1>

<div align="center">

<h3>Redmi Note 8 (ginkgo) Root 后一站式优化工具集</h3>

</div>

---

## 简介

收集和完善了 Redmi Note 8 (ginkgo) Root 后的常见优化方案，涵盖蓝牙音频、系统服务、省电续航、系统精简等多个方面。

> 部分优化可能也适用于其他高通骁龙 665 机型。

---

## 包含内容

### 🎧 AAC 蓝牙编码器启用

高通平台默认关闭了 AAC 蓝牙编码协议，导致 AirPods 等 AAC 耳机只能使用 SBC 编码。模块在开机时写入参数并重启蓝牙服务，强制启用 AAC。

**模块文件：** `ginkgo-tweaks_v1.1.zip`

### 🔧 qccsyshalservice 崩溃修复

`qccsyshalservice`（QTI qcc 系统 HAL 服务）每 5 秒崩溃一次，错误 `registerAsService() failed: -2147483648`。创建 Magisk 模块在开机时停止该服务，摄像头/音频不受影响。

### 🔋 息屏省电脚本

息屏 60 分钟后自动触发：
- 开启飞行模式（关闭蜂窝网络）
- 保留 WiFi 连接（BT下载/在线听歌不受影响）
- CPU 切换 `powersave` 调频策略
- 亮屏/充电时自动恢复

配套 Magisk 开机自启，延迟 30 秒启动，错开开机高峰。

### ⚙️ 开机一次性优化

- 禁用 I/O 统计 → 减少 eMMC 写入
- 禁用调度统计 → 减少 CPU 开销
- 关闭内核 printk 日志 → 减少内核唤醒
- 关闭 Binder 调试
- 停止诊断后台进程 (`cnss_diag`, `tcpdump`)

### 🧹 Debloat 参考清单

冻结的 10 个 MIUI 系统应用（通过 `pm disable-user`）：

| 应用 | 说明 |
|------|------|
| 小米钱包 / NextPay / 银联TSM / 支付服务 | 无 NFC 硬件，无用 |
| 小米音乐 / 小米视频 | 可用第三方替代 |
| 智能出行 / 游戏工具箱 / 悬浮球 | 备用机不需要 |
| 个人助手 | 负一屏 |

---

## 安装

下载 `ginkgo-tweaks_v1.1.zip` 后，在 Magisk App 中安装即可。

[下载 Release](https://github.com/M0Via/ginkgo-tweaks/releases)

---

## 兼容性

| 项目 | 说明 |
|------|------|
| **测试设备** | Redmi Note 8 (ginkgo), Android 11 MIUI 12.5 |
| **Root 方案** | Magisk v29.0 |
| **Bootloader** | 已解锁 |

---

<p align="center">
  <sub>Built with ❤️ by <a href="https://github.com/M0Via">M0Via</a></sub>
</p>
