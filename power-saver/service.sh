#!/system/bin/sh
# Power Saver v2.1 — 开机自启服务
MODDIR=${0%/*}

until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 5
done
sleep 30

/system/bin/log -t power_saver -p i "v2.1 开机: 恢复初始状态"

CURRENT=$(settings get global airplane_mode_on 2>/dev/null)
if [ "$CURRENT" = "1" ]; then
    settings put global airplane_mode_on 0
    am broadcast -a android.intent.action.AIRPLANE_MODE --ez state false
    /system/bin/log -t power_saver -p i "v2.1 开机: 飞行模式已关闭"
fi

svc wifi enable
echo schedutil > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor 2>/dev/null
echo schedutil > /sys/devices/system/cpu/cpufreq/policy4/scaling_governor 2>/dev/null

echo 0 > /sys/block/mmcblk0/queue/iostats 2>/dev/null
echo 0 > /proc/sys/kernel/sched_schedstats 2>/dev/null
echo off > /proc/sys/kernel/printk_devkmsg 2>/dev/null
echo 0 > /sys/module/binder/parameters/debug_mask 2>/dev/null
echo 0 > /sys/module/binder_alloc/parameters/debug_mask 2>/dev/null
stop cnss_diag 2>/dev/null
stop tcpdump 2>/dev/null
setprop sys.miui.ndcd off

/system/bin/log -t power_saver -p i "v2.1 开机: 初始状态恢复完成"

mkdir -p /data/local/tmp
cp "$MODDIR/power_saver.sh" /data/local/tmp/power_saver.sh 2>/dev/null
chmod 755 /data/local/tmp/power_saver.sh
/system/bin/sh /data/local/tmp/power_saver.sh &

/system/bin/log -t power_saver -p i "v2.1 省电守护已启动"
