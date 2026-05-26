#!/system/bin/sh
# Power Saver v2.0 — 无状态息屏省电守护
# 设计原则: 不信任内存变量, 每次决策从系统当前状态获取
#
# 逻辑树:
#   息屏 >= 60min + 未充电 → 省电模式 (飞行模式+WiFi+CPU powersave)
#   亮屏 + 当前飞行模式开启 → 恢复 (关飞行, 保持WiFi, CPU正常)
#   其他情况 → 什么都不做

WAIT_SECONDS=3600
SLEEP_INTERVAL=3

# ─── 工具函数 ───

is_screen_off() {
    [ "$(dumpsys power | grep 'Display Power: state=' | cut -d= -f2)" = "OFF" ]
}

is_charging() {
    STATUS=$(dumpsys battery | grep 'status:' | awk '{print $2}')
    [ "$STATUS" = "2" ] || [ "$STATUS" = "5" ]  # 2=充电中, 5=已充满
}

is_airplane_on() {
    [ "$(settings get global airplane_mode_on 2>/dev/null)" = "1" ]
}

log() {
    /system/bin/log -t power_saver -p i "v2.0 $1"
}

# ─── 动作函数 ───

enter_saving() {
    log "进入省电: 飞行模式+WiFi+CPU powersave"

    # 开飞行模式 (关蜂窝)
    settings put global airplane_mode_on 1
    am broadcast -a android.intent.action.AIRPLANE_MODE --ez state true
    sleep 2

    # 保留WiFi
    svc wifi enable

    # CPU powersave
    echo powersave > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor 2>/dev/null
    echo powersave > /sys/devices/system/cpu/cpufreq/policy4/scaling_governor 2>/dev/null

    # 等待亮屏
    while is_screen_off; do
        sleep 10
    done

    # 亮屏了 → 恢复
    exit_saving
}

exit_saving() {
    # 只在飞行模式确实开着时才恢复
    if is_airplane_on; then
        log "退出省电: 关飞行模式"
        settings put global airplane_mode_on 0
        am broadcast -a android.intent.action.AIRPLANE_MODE --ez state false
    fi

    svc wifi enable
    echo schedutil > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor 2>/dev/null
    echo schedutil > /sys/devices/system/cpu/cpufreq/policy4/scaling_governor 2>/dev/null

    log "退出省电: 已恢复"
}

# ─── 主循环 (无状态, 每次从系统读取) ───

log "守护启动"

while true; do
    if is_screen_off && ! is_charging; then
        # 息屏且未充电 → 等 WAIT_SECONDS 后进入省电
        sleep "$WAIT_SECONDS"
        if is_screen_off && ! is_charging; then
            enter_saving
        fi
    elif ! is_screen_off && is_airplane_on; then
        # 亮屏了但飞行模式还开着 → 恢复 (可能是上次省电残留)
        exit_saving
    fi

    sleep "$SLEEP_INTERVAL"
done
